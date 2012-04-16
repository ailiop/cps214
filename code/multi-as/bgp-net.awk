#! /usr/bin/awk -v NODE=$NODE

function reverse(s) {
    p = "";
    for (i = length(s); i > 0; i--)
	p = p substr(s, i, 1);
    return p;
}

BEGIN {
    min_ip_nolan = "255.255.255.255";
    neighbors_num = 0;
    
    bgp_ifs_num = 0;

    split( NODE, nodeinfo, "-" );
    ASN = nodeinfo[2];
}

$1 ~ /^eth/  &&  $2 ~ /^(192[.]168[.]|172[.]16[.])/ {
    split( $2, ipcidr, "/" );
    interfaces[ipcidr[1]] = $1;
    
    if ($2 ~ /^192[.]168[.]/) {
	bgp_ips[bgp_ifs_num] = $2;
	bgp_ifs_num++;
    }

    if (ipcidr[1] < min_ip_nolan)
	min_ip_nolan = ipcidr[1];
}

$1 ~ NODE  &&  $2 != "LAN" {
    split( $2, neighbor, "," );
    split( neighbor[1], neighborinfo, "-" );
    split( $1, self, "," );

    neighbors_ip[neighbors_num] = neighbor[2];
    neighbors_as[neighbors_num] = neighborinfo[2];
    neighbors_if[neighbors_num] = interfaces[self[2]];
    neighbors_num++;
}

END {
    print "router bgp " ASN;
    print "!";
    print "bgp router-id " min_ip_nolan;
    print "redistribute connected";
    print "redistribute ospf";
    print "!";

    # for (i = 0; i < bgp_ifs_num; i++)
    # 	print "network " bgp_ips[i];
    # print "!";

    for (i = 0; i < neighbors_num; i++) {
	print "neighbor " neighbors_ip[i] " remote-as " neighbors_as[i];
	print "neighbor " neighbors_ip[i] " update-source " neighbors_if[i];
	print "neighbor " neighbors_ip[i] " ebgp-multihop";
	print "neighbor " neighbors_ip[i] " next-hop-self";
	print "!";
    }
}

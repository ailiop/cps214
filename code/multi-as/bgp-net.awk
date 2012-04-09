#! /usr/bin/awk 

function reverse(s) {
    p = ""
    for(i=length(s); i > 0; i--) { p = p substr(s, i, 1) }
    return p
}

!($2 ~ /^(155[.]98[.]39[.]|100[.]100[.]100[.]|.*[.].*[.]1[.])/) {
    split( $2, ipcidr, "/" )
    split( ipcidr[1], ipfields, "." );
    asn = ipfields[1];
    neighbor = ipfields[1] "." ipfields[2] "." ipfields[3] "." reverse(ipfields[4]);
    interface = $1;
}

END {
    print "router bgp " asn;
    print "!";
    print "bgp router-id " ipcidr[1];
    print "redistribute connected";
    print "redistribute ospf";
    print "!";
    print "neighbor " neighbor " remote-as " asn;
    print "neighbor " neighbor " update-source " interface;
    print "!";
}

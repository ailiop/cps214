BEGIN {
    is_eth_if = 0;
    curr_eth_if = 0;
    if_cidr_eth0 = "/22";
    if_cidr_LAN  = "/24";
    if_cidr_LINK = "/30";
}

/.*/ {
    if (is_eth_if) {
	split( $2, ipaddr, ":" );

	if (ipaddr[2] ~ /^155[.]98[.]/)
	    if_cidr_curr = if_cidr_eth0;
	else if (ipaddr[2] ~ /^10[.]/)
	    if_cidr_curr = if_cidr_LAN;
	else if (ipaddr[2] ~ /^(172[.]16[.]|192[.]168[.])/)
	    if_cidr_curr = if_cidr_LINK;

	print curr_eth_if " " ipaddr[2] if_cidr_curr;
    }
    is_eth_if = 0;
}

$1 ~ /^eth[0-9]/ {
    is_eth_if = 1;
    curr_eth_if = $1;
}

BEGIN {
    is_eth_if = 0;
    curr_eth_if = 0;
    if_pref = "/24"
}

/.*/ {
    if (is_eth_if) {
	split( $2, ipaddr, ":" );
	print curr_eth_if " " ipaddr[2] if_pref;
    }
    is_eth_if = 0;
}

$1 ~ /^eth[0-9]/ {
    is_eth_if = 1;
    curr_eth_if = $1;
    if (curr_eth_if ~ /eth0/)
	if_pref = "/22";
    else
	if_pref = "/24";
}

#! /usr/bin/awk -F.

BEGIN {
    num_nets = 0;
}

!($0 ~ /^(100[.]100[.]100[.]|155[.]98[.]39[.])/) {
    nets[num_nets] = "network " $1 "." $2 "." $3 ".0/24 area " $3;
    num_nets++;
}

END {
    for (i = 0; i < num_nets; i++)
	print nets[i]
}

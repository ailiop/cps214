#! /usr/bin/awk -F.

!($0 ~ /^(155[.]98[.]39[.]|192[.]168[.])/) {

    if ($0 ~ /^172[.]16[.]/)
	area = 0;
    else
	area = $3;

    print "network " $0 " area " area;
}

$0 ~ /^192[.]168[.]/ {
    print "network " $0 " area 255";
}

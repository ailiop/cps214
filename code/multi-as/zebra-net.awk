#! /usr/bin/awk

$1 != "eth0" {
    print "interface " $1;
    print "ip address " $2;
    print "!"
}

#! /bin/csh

set NODE = `hostname | awk -F. '{print $1}'`

set IPS = ( 100.100.100.0/24 10.0.0.0/16 20.0.0.0/16 30.0.0.0/16 40.0.0.0/16 50.0.0.0/16 )

set ASN = `echo $NODE | awk -F- '{print $2}'`
set RTR = `echo $NODE | awk -F- '{print $3}'`

set GATEWAY = ${ASN}.0.${RTR}.1

foreach ip ($IPS)
    sudo route add $ip $GATEWAY
end

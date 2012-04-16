#! /bin/csh

set LAN_PREF = $1
set AS_NUM   = $2

set NODE = `hostname | awk -F. '{print $1}'`
set ASN  = `echo $NODE | awk -F- '{print $2}'`
set RTR  = `echo $NODE | awk -F- '{print $3}'`

set IPS = ( 192.168.0.0/16 172.16.0.0/16 )
foreach as (`seq 1 1 $AS_NUM`)
    if ($as == $ASN) continue
    set IPS = ( $IPS $LAN_PREF.$as.0.0/16 )
end

set GATEWAY = $LAN_PREF.$ASN.$RTR.254

foreach ip ($IPS)
    sudo route add $ip $GATEWAY
end

exit 0

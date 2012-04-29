#! /bin/csh

set LAN_PREF = $1
set AS_NUM   = $2

set NODE = `hostname | awk -F. '{print $1}'`
set ASN  = `echo $NODE | awk -F- '{print $2}'`
set RTR  = `echo $NODE | awk -F- '{print $3}'`
set PCN  = `echo $NODE | awk -F- '{print $4}'`

set RON_DIR        = $HOME/ron/$NODE
set RON_INIT_FILE  = $RON_DIR/peerinit.txt
set RON_CACHE_FILE = $RON_DIR/peercache.txt
set RON_PORT       = 9432

mkdir -p $RON_DIR
if ( -e $RON_INIT_FILE ) then
    rm $RON_INIT_FILE
endif
touch $RON_INIT_FILE

rm -f $RON_CACHE_FILE

echo "${LAN_PREF}.${ASN}.${RTR}.${PCN}:${RON_PORT}" >> $RON_INIT_FILE

set IPS = ( 192.168.0.0/16 172.16.0.0/16 )
foreach as (`seq 1 1 $AS_NUM`)
    set IPS = ( $IPS $LAN_PREF.$as.0.0/16 )
end

set GATEWAY = $LAN_PREF.$ASN.$RTR.254

foreach ip ($IPS)
    sudo route add $ip $GATEWAY
end

exit 0

#! /bin/csh

set NODE = `hostname | awk -F. '{print $1}'`

set IF_IP_FILE = IF_IPs-$NODE

set CONF_HEAD_FILE = "ospf.conf.head"
set CONF_TAIL_FILE = "ospf.conf.tail"
set CONF_FILE = "ospf-$NODE.conf"

set AWK_GETNET = "awk -F. -f ospf-net.awk"

if ( -e $CONF_FILE ) then
    rm $CONF_FILE
endif
touch $CONF_FILE

cat $CONF_HEAD_FILE >> $CONF_FILE
foreach ip ( `cat $IF_IP_FILE | awk '{print $2}'` )
    echo $ip | $AWK_GETNET >> $CONF_FILE
end
cat $CONF_TAIL_FILE >> $CONF_FILE

exit 0

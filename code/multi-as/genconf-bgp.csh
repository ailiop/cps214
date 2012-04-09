#! /bin/csh

set NODE = `hostname | awk -F. '{print $1}'`

set IF_IP_FILE = IF_IPs-$NODE

set CONF_HEAD_FILE = "bgp.conf.head"
set CONF_TAIL_FILE = "bgp.conf.tail"

set CONF_FILE = "bgp-$NODE.conf"

set AWK_GENCONF = "awk -f bgp-net.awk"

if ( -e $CONF_FILE ) then
    rm $CONF_FILE
endif
touch $CONF_FILE

cat $CONF_HEAD_FILE >> $CONF_FILE
cat $IF_IP_FILE | $AWK_GENCONF >> $CONF_FILE
cat $CONF_TAIL_FILE >> $CONF_FILE

exit 0

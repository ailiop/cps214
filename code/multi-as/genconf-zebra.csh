#! /bin/csh

# set NODE = `hostname | awk -F. '{print $1}'`
set NODE = $1

set IF_IP_FILE = IF_IPs-$NODE

set CONF_HEAD_FILE = "zebra.conf.head"
set CONF_TAIL_FILE = "zebra.conf.tail"
set CONF_FILE = "zebra-$NODE.conf"

set AWK_GENCONF = "awk -f zebra-net.awk"

if ( -e $CONF_FILE ) then
    rm $CONF_FILE
endif
touch $CONF_FILE

cat $CONF_HEAD_FILE >> $CONF_FILE
# foreach line ( "`cat $IF_IP_FILE`" )
#     set IF = `echo $line | awk '{print $1}'`
#     set IP = `echo $line | awk '{print $2}'`
#     echo "interface $IF" >> $CONF_FILE
#     echo "ip address $IP" >> $CONF_FILE
#     echo "!" >> $CONF_FILE
# end
cat $IF_IP_FILE | $AWK_GENCONF >> $CONF_FILE
cat $CONF_TAIL_FILE >> $CONF_FILE

exit 0

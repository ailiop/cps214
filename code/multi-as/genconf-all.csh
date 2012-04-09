#! /bin/csh

set BIN_DIR = /proj/DukeCPS214/exp/multi-as-fullprot/bin
set EXP_DIR = ~/exp/multi-as-fullprot
set AWK_IFIP = if-ip.awk

set GEN_ZEBRA = "$BIN_DIR/genconf-zebra.csh"
set GEN_OSPF  = "$BIN_DIR/genconf-ospf.csh"
set GEN_BGP   = "$BIN_DIR/genconf-bgp.csh"

set NODE = `hostname | awk -F. '{print $1}'`

cd $EXP_DIR

set IF_IP_FILE = IF_IPs-$NODE

if ( -e $IF_IP_FILE ) then
    rm $IF_IP_FILE
endif
touch $IF_IP_FILE

ifconfig | awk -f $AWK_IFIP >> $IF_IP_FILE

eval $GEN_ZEBRA
eval $GEN_OSPF
eval $GEN_BGP

cd ~

exit 0

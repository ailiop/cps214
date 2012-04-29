#! /bin/csh

#
# SCRIPT
#
#     genconf-all.csh
#
# DESCRIPTION
#
#     Generate the configuration files for the 'zebra', 'ospfd' and
#     'bgpd' daemons of a Quagga software router.
#
# PARAMETERS
#
#     BIN_DIR
#         The directory where the specific configuration file
#         generators are stored.
#
#     EXP_DIR
#         The directory where the configutarion files will be output in.
#
#     AWK_IFIP
#         Path to an AWK grammar that outputs only the
#         interface/IP-address couples for a host, as returned by
#         'ifconfig'.
#
#     GEN_{ZEBRA|OSPF|BGP}_B
#         The zebra, OSPF or BGP configuration file generator
#         program's base filename.
#
# AUTHOR
#
#     Alexandros-Stavros Iliopoulos <ailiop@cs.duke.edu>
#



##################################################
## MACROS

set BIN_DIR   = /proj/DukeCPS214/exp/multi-as-fullprot/bin
set EXP_DIR_L = $HOME/exp/multi-as-fullprot
# set EXP_DIR = /proj/DukeCPS214/exp/multi-as-fullprot
set AWK_IFIP = if-ip.awk

set GEN_ZEBRA = "$BIN_DIR/genconf-zebra.csh"
set GEN_OSPF  = "$BIN_DIR/genconf-ospf.csh"
set GEN_BGP   = "$BIN_DIR/genconf-bgp.csh"

set NODE = $1
#set NODE = `hostname | awk -F. '{print $1}'`

set IF_IP_FILE = IF_IPs-$NODE



##################################################
## MAIN SCRIPT

# make sure the local experiment directory exists
mkdir -p $EXP_DIR_L

# change to the local experiment directory
cd $EXP_DIR_L

# truncate the interface-to-IP coupling log file's length to zero
if ( -e $IF_IP_FILE ) then
    rm -f $IF_IP_FILE
endif
touch $IF_IP_FILE

# output the IP addresses of the local host's interfaces
ifconfig | awk -f $AWK_IFIP >> $IF_IP_FILE

# generate the configuration files
eval "$GEN_ZEBRA $NODE"
eval "$GEN_OSPF $NODE"
eval "$GEN_BGP $NODE"

# go back to the user's home directory
cd ~

# bye-bye
exit 0

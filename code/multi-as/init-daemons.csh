#! /bin/csh

#
# SCRIPT
#
#     init-daemons.csh
#
# DESCRIPTION
#
#     Start the Quagga daemons 'zebra', 'ospfd', and 'bgpd' with the
#     appropriate configuration files.
#
# PARAMETERS
#
#     CONF_EXT
#         The configuration files' extension.
#
#     ZEBRA_CONF_B
#         The zebra configuration base filename.
#
#     OSPF_CONF_B
#         The ospfd configuration base filename sans node ID#.
#
#     BGP_CONF_B
#         The bgpd configuration base filename sans node ID#.
#
#     QUAGGA_LIB
#         Path to the Quagga library directory (where the daemons are
#         stored).
#
# AUTHOR
#
#     Alexandros-Stavros Iliopoulos <ailiop@cs.duke.edu>
#



##################################################
## ERRORS

# codes
set E_INITD = 202

# messages
set E_INITD_STR = "Not all 3 daemons have been initialised."



##################################################
## MACROS

set CONF_EXT = conf

set ZEBRA_CONF_B = zebra
set OSPF_CONF_B  = ospf
set BGP_CONF_B   = bgp

set QUAGGA_LIB = /usr/lib/quagga
set CONF_DIR   = $HOME/exp/multi-as-fullprot

set ZEBRA_D = zebra
set OSPF_D  = ospfd
set BGP_D   = bgpd
#set FLAGS_D = "-u root -d"
set FLAGS_D = "-d"

set ACTIVE_D_CMD = ( "ps -e | grep -E '(${ZEBRA_D}|${OSPF_D}|${BGP_D})'" )
set LCOUNT_CMD = "wc -l"
set NUM_D_CMD = ( ${ACTIVE_D_CMD} | ${LCOUNT_CMD} )



##################################################
## MAIN SCRIPT

# get node's name
set NODE = $1
# set NODE = `hostname | awk -F. '{print $1}'`

# build configuration file names
set ZEBRA_CONF = ${ZEBRA_CONF_B}-${NODE}.${CONF_EXT}
set OSPF_CONF  = ${OSPF_CONF_B}-${NODE}.${CONF_EXT}
set BGP_CONF   = ${BGP_CONF_B}-${NODE}.${CONF_EXT}

# initiate the zebra, ospf and bgp daemons
sudo ${QUAGGA_LIB}/${ZEBRA_D} ${FLAGS_D} -f ${CONF_DIR}/${ZEBRA_CONF}
sudo ${QUAGGA_LIB}/${OSPF_D} ${FLAGS_D} -f ${CONF_DIR}/${OSPF_CONF}
sudo ${QUAGGA_LIB}/${BGP_D} ${FLAGS_D} -f ${CONF_DIR}/${BGP_CONF}

# check if all three daemons have been initiated
set NUM_D = `eval ${NUM_D_CMD}`
if ( ${NUM_D} != 3 ) then
    echo "ERROR $E_INITD! $E_INITD_STR"
    exit $E_INITD
endif

# bye-bye
exit 0

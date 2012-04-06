#! /bin/csh

#
# SCRIPT
#
#     startup-daemons.csh
#
# DESCRIPTION
#
#     Start the Quagga daemons 'zebra', 'ospfd', and 'bgpd' with the
#     appropriate configuration files.
#
# SYNOPSIS
#
#     startup-daemons.csh NODE_SN
#
# ARGUMENTS
#
#     NODE_SN
#         The serial number (ID) of the node the daemons will be
#         initiated on. This is necessary as the daemon configuration
#         files adhere to a strict naming convention that depends on
#         the node's ID.
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
set E_ARGNUM = 201
set E_INITD = 202

# messages
set E_ARGNUM_STR = "Syntax: startup-daemons.csh NODE_SN"
set E_INITD_STR = "Not all 3 daemons have been initialised."



##################################################
## MACROS

set CONF_EXT = conf

set ZEBRA_CONF_B = zebra
set OSPF_CONF_B  = ospf-node
set BGP_CONF_B   = bgp-node

set QUAGGA_LIB = /usr/lib/quagga
# set CONF_DIR = /proj/DukeCPS214/exp/dummy-isp
set CONF_DIR = ${HOME}

set ZEBRA_D = zebra
set OSPF_D = ospfd
set BGP_D = bgpd
set FLAGS_D = "-u root -d"

set ACTIVE_D_CMD = ( "ps -e | grep -E '(${ZEBRA_D}|${OSPF_D}|${BGP_D})'" )
set LCOUNT_CMD = "wc -l"
set NUM_D_CMD = ( ${ACTIVE_D_CMD} | ${LCOUNT_CMD} )



##################################################
## MAIN SCRIPT

# check if 1 argument has been given; rename it
if ( $# != 1 ) then
    echo "ERROR $E_ARGNUM! $E_ARGNUM_STR"
    exit $E_ARGNUM
endif
set NODE = $1

# build configuration file names
set ZEBRA_CONF = ${ZEBRA_CONF_B}.${CONF_EXT}
set OSPF_CONF = ${OSPF_CONF_B}${NODE}.${CONF_EXT}
set BGP_CONF = ${BGP_CONF_B}${NODE}.${CONF_EXT}

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

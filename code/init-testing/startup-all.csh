#! /bin/csh

#
# SCRIPT
#
#     startup-all.csh
#
# DESCRIPTION
#
#     Does all the necessary start-up work for a newly swapped-in
#     Emulab experiment where OSPF/BGP routing is to be used among the
#     nodes of the mulated network.
#
#     Essentially this simply serves as a wrapper for the rest of the
#     startup-*.csh scripts.
#
# SYNOPSIS
#
#     startup-all.csh NODE_SN
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
#     STARTUP_DIR
#         Path to the directory where the startup-*.csh scripts are
#         located.
#
# SEE ALSO
#
#     startup-quagga.csh, startup-daemons.csh
#
# AUTHOR
#
#     Alexandros-Stavros Iliopoulos <ailiop@cs.duke.edu>
#



##################################################
## MACROS

set STARTUP_DIR = /proj/DukeCPS214/exp/dummy-isp/bin



##################################################
## MAIN SCRIPT

${STARTUP_DIR}/startup-quagga.csh $*
${STARTUP_DIR}/startup-daemons.csh $*

exit 0

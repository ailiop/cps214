#! /bin/csh

#
# SCRIPT
#
#     prepare-quagga.csh
#
# DESCRIPTION
#
#     Add the user 'quagga' and groups 'quaggavty' and 'quagga' in the
#     relevant /etc/ files, in order for the Quagga daemons to work.
#
# AUTHOR
#
#     Alexandros-Stavros Iliopoulos <ailiop@cs.duke.edu>
#



##################################################
## MACROS

set ADD_GRP_CMD = "sudo groupadd"
set ADD_GRP_FLG = ""

set ADD_USR_CMD = "sudo useradd"
set ADD_USR_FLG = "-c 'Quagga routing daemons' -d /var/run/quagga/ -s /bin/false -g "



##################################################
## MAIN SCRIPT

# add groups 'quagga' and 'quaggavty'
$ADD_GRP_CMD quagga
$ADD_GRP_CMD quaggavty

# add 'quagga' user in 'quagga' group
eval "$ADD_USR_CMD $ADD_USR_FLG quagga quagga"

# bye-bye
exit 0

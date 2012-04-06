#! /bin/csh

#
# SCRIPT
#
#     startup-quagga.csh
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
## ERRORS

# codes
set E_CP = 101
set E_MV = 102
set E_ECHO = 103

# messages
set E_CP_STR = "Could not create copy: "
set E_MV_STR = "Could not move to: "
set E_ECHO_STR = "Could not echo in: "



##################################################
## MACROS

set USR_QG = 666
set GRP_QGVTY = 114
set GRP_QG = 115

set USERS = ( quagga:x:${USR_QG}:${GRP_QG}:Quagga-routing-suite,,,:/var/run/quagga/:/bin/false )
set GROUPS = ( quaggavty:x:${GRP_QGVTY}: quagga:x:${GRP_QG}: )


##################################################
## MAIN SCRIPT

# copy /etc/passwd and /etc/group in the local directory
cp /etc/passwd ./
cp /etc/group ./

# add Quagga users and groups in 'passwd' and 'group', respectively
foreach usr ( $USERS )
    echo $usr >> passwd
end
foreach grp ( $GROUPS )
    echo $grp >> group
end

# move files back as root
sudo mv passwd /etc/
sudo mv group /etc/

# bye-bye
exit 0

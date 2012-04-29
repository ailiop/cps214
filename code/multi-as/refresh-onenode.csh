#! /bin/csh

set EXP_DIR = "/proj/DukeCPS214/exp/multi-as-fullprot"

set STARTUP_CMD = "$EXP_DIR/bin/startup-rt.csh"

set ZEBRA_ID = `ps -e | grep zebra | awk '{print $1}'`
set OSPFD_ID = `ps -e | grep ospfd | awk '{print $1}'`
set BGPD_ID  = `ps -e | grep bgpd  | awk '{print $1}'`

set ALL_IDS = ( $ZEBRA_ID $OSPFD_ID $BGPD_ID )

set KILL_CMD = "sudo kill"

if ( ${%ALL_IDS} != 0 ) then
    $KILL_CMD $ALL_IDS
endif

eval "$STARTUP_CMD"

exit 0

#! /bin/csh

set LAN_PREF = 10

set EXP_DIR  = "/proj/DukeCPS214/exp/multi-as-fullprot"
set LOG_FILE = "$EXP_DIR/sizes.log"

set SSH_USER = "ailiop"
set SSH_HOST = "multi-as-fullprot.DukeCPS214.emulab.net"

set REFRESH_CMD_RT = "$EXP_DIR/bin/refresh-onenode.csh"
set REFRESH_CMD_PC = "$EXP_DIR/bin/startup-pc.csh"

set AS_NUM     = `cat $LOG_FILE | awk '$1 == "AS_NUM" {print $2}'`
set AS_SIZE    = `cat $LOG_FILE | awk '$1 == "AS_SIZE" {print $2}'`
set LAN_NUM_AS = `cat $LOG_FILE | awk '$1 == "LAN_NUM_AS" {print $2}'`
set LAN_SIZE   = `cat $LOG_FILE | awk '$1 == "LAN_SIZE" {print $2}'`

set ROUTER_LIST = ""

foreach a (`seq 1 1 $AS_NUM`)
    foreach r (`seq 1 1 $AS_SIZE`)
	ssh $SSH_USER@rt-$a-$r.$SSH_HOST $REFRESH_CMD_RT
    end
end

foreach a (`seq 1 1 $AS_NUM`)
    foreach l (`seq 1 1 $LAN_NUM_AS`)
	foreach p (`seq 1 1 $LAN_SIZE`)
	    ssh $SSH_USER@pc-$a-$l-$p.$SSH_HOST $REFRESH_CMD_PC $LAN_PREF $AS_NUM
	end
    end
end

exit 0

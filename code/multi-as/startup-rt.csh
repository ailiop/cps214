#! /bin/csh

set BIN_DIR = /proj/DukeCPS214/exp/multi-as-fullprot/bin
set EXP_DIR = ~/exp/multi-as-fullprot

set NODE = `hostname | awk -F. '{print $1}'`

eval "$BIN_DIR/prepare-quagga.csh"
eval "$BIN_DIR/genconf-all.csh"
eval "$BIN_DIR/init-daemons.csh"

exit 0

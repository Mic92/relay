#!/usr/bin/env bash

# Dumps the call graph, and cil ASTs to the DUMPROOT specified below
# Reads the information from "gcc-log"
# Requires the "duppy" script
# Remember to change RELAYROOT

CURROOT=$PWD
DUMPROOT=$PWD/ciltrees
RELAYROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
DUPPYROOT=$RELAYROOT/scripts
CILLYROOT=$RELAYROOT/cil/bin
LOG=$DUMPROOT/log.txt

#gcc-log has "cd" and "duppy" commands on each line
CMDS=$PWD/gcc-log.txt


/bin/rm -rf $DUMPROOT
mkdir -p $DUMPROOT
/bin/rm -f $LOG

export CURROOT
export DUMPROOT
export CILLYROOT
export RELAYROOT
SKIP_AFTERCIL=1
export SKIP_AFTERCIL

NODEF=$PWD/nodef.h
export NODEF

# nodef?

# first dump the files

duppy ()
{
    echo duppy $*
    $DUPPYROOT/duppy $*
}

STARTTIME=$(date +%s)

(. $CMDS) 2>&1 | tee $LOG

# fix variable / struct ids + dump the call graph

# hard-coding to use steens
cd $RELAYROOT; ./fix_id_cg.exe -cg $DUMPROOT -su client.cfg.steens >> $LOG 2>&1
cd $RELAYROOT; ./scc_stats.exe -cg $DUMPROOT/calls.steens -su client.cfg.steens >> $LOG 2>&1


ENDTIME=$(date +%s)

DIFF=$(( $ENDTIME - $STARTTIME ))

echo "Dumped in $DIFF seconds"

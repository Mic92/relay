#!/usr/bin/env bash

# Merge the source files according to info in "gcc-log"
# Requires the "mergy" script
# Remember to change RELAYROOT

CURROOT=$PWD
DUMPROOT=$PWD/cilmerged
RELAYROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
CILLYROOT=$RELAYROOT/cil/bin
MERGYROOT=$RELAYROOT/scripts
LOG=$DUMPROOT/log.txt



#gcc-log has "cd" and "duppy" commands on each line
#will interpret "duppy" as "mergy" later...
CMDS=$PWD/gcc-log.txt

rm -rf $DUMPROOT
mkdir -p $DUMPROOT
rm -f $LOG

export CURROOT
export DUMPROOT
export CILLYROOT
SKIP_AFTERCIL=1
export SKIP_AFTERCIL

NODEF=$PWD/nodef.h
export NODEF

# nodef?

duppy ()
{
    echo mergy $*
    $MERGYROOT/mergy $*
}

myar ()
{
  echo myar $*
  $CILLYROOT/cilly --merge --mode=AR --keepmerged
}

STARTTIME=$(date +%s)

(. $CMDS) #> /dev/null #| tee $LOG 2>&1

ENDTIME=$(date +%s)

DIFF=$(( $ENDTIME - $STARTTIME ))

echo "Dumped in $DIFF seconds"

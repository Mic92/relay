#!/usr/bin/env bash
LOG=$1
FUNC=$2
DIVPATTERN="======="
OUTDIR="tempcontexts"
echo "Getting contexts for $FUNC from $LOG into $OUTDIR"
scripts/grepbetween.py "Starting.* $FUNC" "$DIVPATTERN" $LOG > $OUTDIR/temp
scripts/split_on.py "$DIVPATTERN" $OUTDIR/temp $OUTDIR/$FUNC

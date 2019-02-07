#!/bin/bash

INPUT="*daily.txt"
INPUTDIR=out
OUTPUTDIR=headers

INPUTFILES=$(find "$INPUTDIR" -name "$INPUT")

for f in $INPUTFILES
do
  OUTFILE="$OUTPUTDIR/$f"

  mkdir -p $(dirname "$OUTFILE")

  head -n 1 $f > "$OUTFILE"
  md5 "$OUTFILE"
done

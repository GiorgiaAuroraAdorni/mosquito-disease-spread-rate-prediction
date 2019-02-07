#!/bin/bash

INPUT="*daily.txt"
INPUTDIR=out
OUTFILE=daily.txt

INPUTFILES=$(find "$INPUTDIR" -name "$INPUT" | sort)

rm "$OUTFILE"

for f in $INPUTFILES
do
  echo "Processing file $f..."

  if [ ! -f "$OUTFILE" ]
  then
    head -n 1 "$f" > "$OUTFILE"
  fi

  tail -n +2 "$f" >> "$OUTFILE"
done

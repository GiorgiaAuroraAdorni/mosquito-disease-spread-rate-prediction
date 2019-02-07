#!/bin/bash

INPUT="*station.txt"
INPUTDIR=out

INPUTFILES=$(find "$INPUTDIR" -name "$INPUT" | sort)

echo "Changes:"
md5 $INPUTFILES | uniq -f 3

echo
echo "Unique revisions:"
md5 $INPUTFILES | sort -sk 4 | uniq -f 3

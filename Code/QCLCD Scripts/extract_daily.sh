#!/bin/bash

INPUT="QCLCD*.zip"
OUTPUT="out"

INPUTFILES=$(find . -name $INPUT)

FILEPATTERN=("*daily.txt" "*station.txt")
GREPPATTERN='^(WBAN|04807|04838|04879|14819|94846)'

for archive in $INPUTFILES
do
  SUBDIR="$OUTPUT/$(dirname $archive)"
  TMPDIR="$SUBDIR/tmp"

  mkdir -p "$TMPDIR"

  unzip "$archive" ${FILEPATTERN[@]} -d "$TMPDIR"

  for f in $TMPDIR/*
  do
    OUTFILE="$SUBDIR/$(basename $f)"

    cat "$f" | grep -E "$GREPPATTERN" > "$OUTFILE"
  done
  
  rm -rf "$TMPDIR"
done
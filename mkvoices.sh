#!/bin/bash

#Output directory for finished sound files
OUTDIR=$(dirname $0)/SOUNDS/en

#Use a voice other than system default
#VOICE="Allison"

#Output sound formats.
#More info on output formats can be found in "afconvert -hf". "say" seems to use the same formats.

#Highest quality for Taranis:
FORMAT="I16@32000"

#Lower quality for other OpenTX radios:
#FORMAT="ulaw@8000"


#Separator character in CSV. Some spreadsheet apps use semicolon instead, can be changed here.
IFS=,

VOICE_PARAM=""
if [[ -n "$VOICE" ]]; then VOICE_PARAM="--voice=\"$VOICE\""; fi

while read OUTFILE SAYING
do
	if [[ -z "$OUTFILE" ]]; then continue; fi
	if [[ -z "$SAYING" ]]; then continue; fi
	DEST="$OUTDIR/$OUTFILE"
	
	echo "\"$SAYING\" => $DEST"

	#Ensure output directory exists for each file if it is in a subdirectory
	mkdir -p $(dirname $DEST)

	/usr/bin/say $VOICE_PARAM --output-file="$DEST" \
	             --file-format=WAVE --data-format=$FORMAT --channels=1 \
	             "\"$SAYING\""
done

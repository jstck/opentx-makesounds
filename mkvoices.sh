#!/bin/bash

#Output directory for finished sound files
OUTDIR=$(dirname $0)/SOUNDS/en

#Use a voice other than system default
#VOICE="Allison"

#Only make files where the destination doesn't already exist
UPDATEONLY=true

#Sound output format to sox

#High-quality for Taranis. "say" seems to just output 22kHz/16bits, so there is little point converting to anything above that
#(and voice usually doesn't go much above 4-5kHz anyway). In parenthesis (array) because bash.
#FORMAT=(--bits 16 --channels 1 --encoding signed-integer --rate 22050)

#32kHz is what is shipped default, encode as such.
FORMAT=(--bits 16 --channels 1 --encoding signed-integer --rate 32k)

#Lower quality for other radios. A-law or u-law companding is mostly a matter of religious bias.
#U-law should have greater dynamic range though.
#FORMAT=(--bits 8 --channels 1 --encoding u-law --rate 8k)

#sox "effects" to trim silence and normalize sound level
EFFECTS=(silence 1 0.1 1% gain -n -1)

#Separator character in CSV. Some spreadsheet apps use semicolon instead, can be changed here.
IFS=,

#Location of binaries. Especially sox may be more or less wherever.
SAYCMD=/usr/bin/say
SOXCMD=/usr/local/bin/sox

VOICE_PARAM=""
if [[ -n "$VOICE" ]]; then VOICE_PARAM="--voice=\"$VOICE\""; fi

while read OUTFILE SAYING
do
	if [[ -z "$OUTFILE" ]]; then continue; fi
	if [[ -z "$SAYING" ]]; then continue; fi
	DEST="$OUTDIR/$OUTFILE"

	#Skip and warn if filename is too long (>10 chars, excluding suffix)
	BASE=$(basename ${OUTFILE%.*})
	if [[ ${#BASE} -gt 10 ]]
	then
		echo "Filename '$OUTFILE' is too long, skipping." >&2
		continue
	fi

        if [[ $UPDATEONLY && -e $DEST ]]; then continue; fi
	
	echo "\"$SAYING\" => $DEST"

	#Ensure output directory exists for each file if it is in a subdirectory
	mkdir -p $(dirname $DEST)

	#Make a tempfile with .aiff appended, since say will do that automatically otherwise
	TMPFILE=$(mktemp -ut makesounds).aiff

	$SAYCMD $VOICE_PARAM --output-file="$TMPFILE" \"$SAYING\"
	$SOXCMD -q "$TMPFILE" ${FORMAT[@]} "$DEST" ${EFFECTS[@]}

	rm $TMPFILE
	
done

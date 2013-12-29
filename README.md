opentx-makesounds
=================

Generate sounds for OpenTX using MacOS text-to-speech.

Licensed under GNU General Public License (GPL) version 2.

The bash script mkvoices.sh will generate sound files using text-to-speech using the data file sounds.csv.

Simple usage:
./mksounds.sh < sounds_en.csv

The csv file has two columns, the first is output filename and the second is the text to say. It uses Mac OS built in text-to-speech command "say". It is recommended that you download one of the "high-quality" voices available in newer releases. More info on this here:
http://www.macobserver.com/tmo/article/how-to-install-and-use-high-quality-system-voices-in-os-x

This has only been tested on MacOS 10.9 (Mavericks), but it should work with anything after 10.6 at least.

Requires sox (http://sox.sourceforge.net/) for audio format conversion, easily installed via Homebrew (http://brew.sh/):
brew install sox

Even if you don't care for the normalizing and silence-trimming, the WAV files output by say (or afconvert) for some reason will not play properly in the Taranis.

Output directory, output format, CSV separator and voice can all be adjusted in the script.
#!/bin/bash

function STDERR() { cat - 1>&2; }


function BLACK()	 { echo -ne "\x1B[30m"; cat -; echo -ne "\x1B[39m"; }
function RED() { echo -ne "\x1B[31m"; cat -; echo -ne "\x1B[39m"; }
function GREEN()	 { echo -ne "\x1B[32m"; cat -; echo -ne "\x1B[39m"; }
function YELLOW() { echo -ne "\x1B[33m"; cat -; echo -ne "\x1B[39m"; }
function BLUE() { echo -ne "\x1B[34m"; cat -; echo -ne "\x1B[39m"; }
function MAGENTA() { echo -ne "\x1B[35m"; cat -; echo -ne "\x1B[39m"; }
function CYAN()	{ echo -ne "\x1B[36m"; cat -; echo -ne "\x1B[39m"; }
function GRAY() { echo -ne "\x1B[37m"; cat -; echo -ne "\x1B[39m"; }
function DARK_GRAY()	 { echo -ne "\x1B[90m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_RED()	 { echo -ne "\x1B[91m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_GREEN() { echo -ne "\x1B[92m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_YELLOW() { echo -ne "\x1B[93m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_BLUE() { echo -ne "\x1B[94m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_MAGENTA()	 { echo -ne "\x1B[95m"; cat -; echo -ne "\x1B[39m"; }
function LIGHT_CYAN() { echo -ne "\x1B[96m"; cat -; echo -ne "\x1B[39m"; }
function WHITE()	 { echo -ne "\x1B[97m"; cat -; echo -ne "\x1B[39m"; }



# Generate an empty log
CURR_DIR=$(dirname $0);
FILE="${CURR_DIR}/install.log";



if [ -z $LIB_LIST ] || [ -z $BINARY_LIST ] || [ -z $CMD_LIST ]; then
	LIB_LIST=( "lib/esm-js.loader.mjs" );
	BINARY_LIST=( "bin/rpath" "bin/njs" "bin/incognito" "bin/summon" "bin/lrun" );
	CMD_LIST=( "rpath" "njs" "incognito" "summon" "lrun" );
fi

if [ -z $INSTALL_DIR ] || [ -z $BIN_DIR ]; then
	if [ $# -le 0 ]; then echo "Command installation dir is not specified! Using \`/usr/bin\`"; fi;
	INSTALL_DIR=$(pwd);
	BIN_DIR=/usr/bin;
fi




echo "Installing commands..." | tee -a $FILE | GREEN | STDERR;
for SCRIPT in "${CMD_LIST[@]}"; do
	SRC_PATH="$INSTALL_DIR/bin/$SCRIPT";
	DST_PATH="$BIN_DIR/$SCRIPT";

	echo -n "$DST_PATH... " | tee -a $FILE | DARK_GRAY | STDERR;
	if [ ! -e "$DST_PATH" ]; then
		echo "linking!" | tee -a $FILE | DARK_GRAY | STDERR;
		ln -s "$SRC_PATH" "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
	else
		echo "file exists! Skipping!" | tee -a $FILE | DARK_GRAY | STDERR;
	fi
done
echo "" | tee -a $FILE | STDERR;

exit 0;
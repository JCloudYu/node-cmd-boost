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



LIB_LIST=( "lib/esm-js.loader.mjs" );
BINARY_LIST=( "bin/rpath" "bin/njs" "bin/incognito" "bin/summon" "bin/lrun" );
CMD_LIST=( "rpath" "njs" "incognito" "summon" "lrun" );



# Check whether the script is run using root
if [ "$EUID" -ne 0 ]; then
	echo "This script must be run by root!" | STDERR;
	exit 1;
fi


# Generate an empty log
CURR_DIR=$(dirname $0);
FILE="${CURR_DIR}/install.log";
echo -n "" > $FILE



# Check whether NodeJS is installed and its version is greater than or equal to v11.0.0
NODE_PATH=$(which node);
if [ $? -ne 0 ]; then
	echo "NodeJS executable is not found!!!" | tee -a $FILE | LIGHT_RED | STDERR;
	exit 1;
fi

NODE_VERSION=$($NODE_PATH -v)
NODE_VERSION=${NODE_VERSION:1}
NODE_VERSION_COMP=( ${NODE_VERSION//\./ } )
if [ ${NODE_VERSION_COMP[0]} -lt 11 ]; then 
	echo "boost-cmd lib requires NodeJS version 10.0.0 or greater!" | tee -a $FILE | LIGHT_RED | STDERR;
	exit 1;
fi



echo -n "Platform NodeJS version: " | tee -a $FILE | GREEN | STDERR;
echo "$NODE_VERSION" | tee -a $FILE | YELLOW | STDERR;



export INSTALL_DIR=/usr/lib/boost-cmd
export BIN_DIR=/usr/bin


echo -n "Creating lib at path " | tee -a $FILE | GREEN | STDERR;
echo -n "\`$INSTALL_DIR\`" | tee -a $FILE | YELLOW | STDERR;
echo " ..." | tee -a $FILE | GREEN | STDERR;
if [ ! -e "$INSTALL_DIR" ]; then
	mkdir -p "$INSTALL_DIR" | tee -a $FILE | DARK_GRAY | STDERR;
fi

if [ ! -e "$INSTALL_DIR/bin" ]; then
	mkdir -p "$INSTALL_DIR/bin" | tee -a $FILE | DARK_GRAY | STDERR;
fi

if [ ! -e "$INSTALL_DIR/lib" ]; then
	mkdir -p "$INSTALL_DIR/lib" | tee -a $FILE | DARK_GRAY | STDERR;
fi



echo "Copying environmental resources..." | tee -a $FILE | GREEN | STDERR;
echo "Copying binaries..." | tee -a $FILE | GREEN | STDERR;
for SCRIPT in "${BINARY_LIST[@]}"; do
	SRC_PATH="$CURR_DIR/$SCRIPT";
	DST_PATH="$INSTALL_DIR/$SCRIPT";

	echo "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
	cp -f "$SRC_PATH" "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
	chmod 755 "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
done
echo "" | tee -a $FILE | STDERR;

echo "Copying libraries..." | tee -a $FILE | GREEN | STDERR;
for SCRIPT in "${LIB_LIST[@]}"; do
	SRC_PATH="$CURR_DIR/$SCRIPT";
	DST_PATH="$INSTALL_DIR/$SCRIPT";

	echo "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
	cp -f "$SRC_PATH" "$DST_PATH" | tee -a $FILE | DARK_GRAY | STDERR;
done
echo "" | tee -a $FILE | STDERR;



# Link libraries
$CURR_DIR/link.sh



echo "Installation is done!" | tee -a $FILE | GREEN | STDERR;
exit 0;
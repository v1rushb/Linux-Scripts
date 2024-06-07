#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: vimc <filename>.cpp [setup_file]"
    exit 1
fi

FILENAME=$1

DEFAULT_SETUP_FILE=~/cp/setups/setup.cpp

if [ $# -eq 2 ]; then
    SETUP_FILE=$2
else
    SETUP_FILE=$DEFAULT_SETUP_FILE
fi

if [[ $FILENAME != *.cpp ]]; then
    echo "Error: $FILENAME is not a .cpp file."
    exit 1
fi

if [ ! -f $SETUP_FILE ]; then
    echo "Error: $SETUP_FILE does not exist."
    exit 1
fi

if [ ! -f $FILENAME ]; then
    cat $SETUP_FILE > $FILENAME
fi

vim $FILENAME


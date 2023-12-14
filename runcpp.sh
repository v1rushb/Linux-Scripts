#!/bin/bash

WORKSPACE=$PWD
filename_without_extension=${1%.*}

g++ "$filename_without_extension.cpp" -o "$WORKSPACE/$filename_without_extension"

if [ $? -eq 0 ]; then
    echo "Compilation successful, running $filename_without_extension"
    "$WORKSPACE/$filename_without_extension"
else
    echo "Compilation failed."
fi

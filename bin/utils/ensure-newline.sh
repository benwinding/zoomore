#!/usr/bin/env bash

FILENAME="$(pwd)/$1"
echo "Ensuring there's a newline at the end of the file"
echo "- file: $FILENAME"
ed -s "$FILENAME" <<< w

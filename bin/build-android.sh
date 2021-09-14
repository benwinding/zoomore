#!/usr/bin/env bash

BIN_DIR=$(dirname $0) && cd $BIN_DIR && cd ..
rm -rf ./build/app
flutter build apk
flutter build appbundle --release

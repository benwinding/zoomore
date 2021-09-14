#!/usr/bin/env bash

BIN_DIR=$(dirname $0) && cd $BIN_DIR && cd ..
rm -rf ./build/ios
flutter build ipa --release

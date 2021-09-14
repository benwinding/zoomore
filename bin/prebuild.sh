#!/usr/bin/env bash

BIN_DIR=$(dirname $0) && cd $BIN_DIR && cd ..
flutter clean
flutter pub get
flutter pub pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
bin/ensure-newline.sh "$BIN_DIR/../ios/Runner.xcodeproj/project.pbxproj"
./bin/version-bump.sh

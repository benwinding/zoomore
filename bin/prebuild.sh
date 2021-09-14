#!/usr/bin/env bash

BIN_DIR=$(dirname $0) && cd $BIN_DIR && cd ..
flutter clean
flutter pub get
flutter pub pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
cd $BIN_DIR
./utils/ensure-newline.sh "../ios/Runner.xcodeproj/project.pbxproj"
./utils/version-bump.sh

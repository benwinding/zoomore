#!/bin/sh

flutter clean
flutter pub get
flutter pub pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
bin/ensure-newline.sh ./ios/Runner.xcodeproj/project.pbxproj
./bin/version-bump.sh

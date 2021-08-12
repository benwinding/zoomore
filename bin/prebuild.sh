 #!/bin/sh

flutter clean
flutter pub get
flutter pub pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
./version-bump.sh
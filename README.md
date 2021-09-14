# Zoomore

Zoomore is an app to turn static images into dynamic gifs!

## Tech

- Flutter

## Run Local

1. `./bin/flutter-prebuild.sh` _Only run once to generate some assets_
2. Either run Android or IOS
    1. `flutter run android`
    3. `flutter run ios`

## Android - Deployment

1. `./bin/flutter-prebuild.sh`
2. Make sure the `android/key.properties` exists 
    - (See `android/key.properties.EXAMPLE` for an example)
    - Must have `keystore` file, a private key file needed to sign app
2. `flutter build appbundle`
3. go to [https://play.google.com/console/](https://play.google.com/console/)

### Release to Internal Testers

1. go to "Internal Testing"
2. Add new release
3. Make sure testers are added
![](https://i.imgur.com/l3VPLWu.png)


## iOS - Deployment

1. `./bin/flutter-prebuild.sh`
2. Make sure the `keys are added to XCode` 
2. `flutter build ipa` this generates the `build/ios/archive/Runner.xcarchive` project
3. Open `build/ios/archive/Runner.xcarchive` in XCode, then distribute app to appstore
![](https://i.imgur.com/yaInGq9.png)
4. Goto [https://appstoreconnect.apple.com/apps](https://appstoreconnect.apple.com/apps) to view Apps

### iOS - Images

- iPhone 6.5" Display = iPhone 12 Pro Max
- iPhone 5.5" Display = iPhone 8 Plus, iPhone 7 Plus
- iPad Pro (3rd Gen) 12.9" Display = iPad Pro (5th Gen)
- iPad Pro (2nd Gen) 12.9" Display = iPad Pro (5th Gen)

More sizes here: https://stackoverflow.com/a/25759231/2419584

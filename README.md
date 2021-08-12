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
2. Make sure the `android/key.properties` exists 
    - (See `android/key.properties.EXAMPLE` for an example)
    - Must have `keystore` file, a private key file needed to sign app
2. `flutter build appbundle`
3. go to [https://play.google.com/console/](https://play.google.com/console/)


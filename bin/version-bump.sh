#!/bin/bash
set -e

if [ -n "$(git status --porcelain)" ]; then
  echo "-------------------------------";
  echo "!! Aborting VersionBump !!";
  echo "Please commit the changes first";
  echo "-------------------------------";
  exit 1
fi

BIN_DIR=$(dirname $0)
PUBSPEC_PATH="$BIN_DIR/../pubspec.yaml"
echo "Using pubspec file: $PUBSPEC_PATH"
# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' $PUBSPEC_PATH

# Commit and tag this change.
version=`grep 'version: ' $PUBSPEC_PATH | sed 's/version: //'`
git commit -m "Bump version to $version" $PUBSPEC_PATH
git tag $version

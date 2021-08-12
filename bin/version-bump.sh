#!/bin/bash
set -e

if [ -n "$(git status --porcelain)" ]; then
  echo "-------------------------------";
  echo "Please commit the changes first";
  echo "-------------------------------";
  exit 1
fi

PUBSPEC_PATH='../pubspec.yaml'
# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' $PUBSPEC_PATH

# Commit and tag this change.
version=`grep 'version: ' $PUBSPEC_PATH | sed 's/version: //'`
git commit -m "Bump version to $version" $PUBSPEC_PATH
git tag $version

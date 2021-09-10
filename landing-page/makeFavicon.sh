#!/bin/bash

IMG_SRC="../assets/zoomore-icon-512x512.png"
OUTPUT_DIR="./public/icons"

convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 "$IMG_SRC" "$OUTPUT_DIR/output-16x16.ico"
convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 "$IMG_SRC" "$OUTPUT_DIR/output-32x32.ico"
convert "$OUTPUT_DIR/output-16x16.ico" "$OUTPUT_DIR/output-32x32.ico" "$OUTPUT_DIR/favicon.ico"
convert -resize x152 "$IMG_SRC" "$OUTPUT_DIR/apple-touch-icon-152x152.png"
convert -resize x120 "$IMG_SRC" "$OUTPUT_DIR/apple-touch-icon-120x120.png"
convert -resize x76  "$IMG_SRC" "$OUTPUT_DIR/apple-touch-icon-76x76.png"
convert -resize x60  "$IMG_SRC" "$OUTPUT_DIR/apple-touch-icon-60x60.png"

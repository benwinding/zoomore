import 'dart:async';

import 'package:flutter/material.dart';

class ZoomStore  with ChangeNotifier {
  final List<Matrix4> _frames = [];
  Image _image;
  Image _imageFull;
  double _aspectRatio = 1;

  Image get image => this._image;
  Image get imageFull => this._imageFull;
  double get aspectRatio => this._aspectRatio;
  int get frameCount => this._frames.length;
  int get maxFrames => 100;

  Matrix4 getFrame(int frameIndex) {
    if (frameIndex >= this.frameCount) {
      return Matrix4.identity();
    }
    return this._frames[frameIndex];
  }
  void clearFrames() {
    this._frames.clear();
    notifyListeners();
  }
  void addFrame(Matrix4 clonedMatrix) {
    this._frames.add(clonedMatrix);
    notifyListeners();
  }

  // Setters
  void setImage(Image img) async {
    this._image = img;
    notifyListeners();
    final i = await _getImageInfo(img);
    this._aspectRatio = i.image.width / i.image.height;
    notifyListeners();
  }

  void setImageFull(Image img) async {
    this._imageFull = img;
    notifyListeners();
    if (img == null) {
      return;
    }
    final i = await _getImageInfo(img);
    this._aspectRatio = i.image.width / i.image.height;
    notifyListeners();
  }
}

Future<ImageInfo> _getImageInfo(Image img) async {
  if (img == null) {
    return null;
  }
  final c = new Completer<ImageInfo>();
  img.image
    .resolve(new ImageConfiguration())        
    .addListener(new ImageStreamListener((ImageInfo i, bool _) {
      c.complete(i);
    }));
  return c.future;    
}

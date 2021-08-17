import 'package:flutter/material.dart';
import 'dart:async';

import 'zoom.store.dart';

class _ZoomRecorderModelState {
  Image image;
  Image imageFull;
  double aspectRatio = 1;
  int frameCount = 100;
  int maxFrames = 100;
}

class ZoomRecorderModel with ChangeNotifier {
  int _currentIndex = 0;
  Timer _operation;
  final Matrix4 _matrix = Matrix4.identity();

  // Getters
  Image get image => this._store.image;
  Image get imageFull => this._store.imageFull;
  double get imageRatio => this._store.aspectRatio;
  int get framesCount => this._store.frameCount;
  int get maxFrames => this._store.maxFrames;

  double get playerIndex => this._currentIndex.toDouble();
  bool get isPlaying => this._operation != null && this._operation.isActive;

  ZoomStore _store;

  ZoomRecorderModel(final this._store) {
    this._store.addListener(() {
      notifyListeners();
    });
  }

  Matrix4 getCurrentFrame() {
    // var playFrame = this._store.getFrame(_currentIndex);
    // this._matrix.setFrom(playFrame);
    return this._matrix;
  }

  // Setters
  void setImage(Image img) async {
    this._store.setImage(img);
    this.playerStopGotoStart();
    this.resetFrames();
    notifyListeners();
  }

  void setImageFull(Image img) async {
    this._store.setImageFull(img);
    this.playerStopGotoStart();
    this.resetFrames();
    notifyListeners();
  }

  void resetMatrix() {
    this._matrix.setIdentity();
    notifyListeners();
  }

  void updateMatrixFromGuesture(Matrix4 matrixInput) {
    this._matrix.setFrom(matrixInput);
    notifyListeners();
  }

  void resetFrames() {
    this._store.clearFrames();
    notifyListeners();
  }

  void _resetFrameIndex() {
    _currentIndex = 0;
    notifyListeners();
  }

  void playerRecord() {
    resetFrames();
    this._currentIndex = 0;
    playerStop();
    const oneSec = const Duration(milliseconds: 50);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      this._store.addFrame(this._matrix.clone());
      this._currentIndex = this.framesCount;
      notifyListeners();
      if (this.framesCount >= this.maxFrames) {
        this.playerStop();
      }
    });
    notifyListeners();
  }

  void playerStop() {
    if (_operation != null) {
      _operation.cancel();
    }
    notifyListeners();
  }

  void playerStopGotoStart() {
    this.playerStop();
    this._resetFrameIndex();
  }
}

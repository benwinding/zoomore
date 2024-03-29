import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/proxy_box.dart';
import 'dart:async';

import 'zoom.store.dart';

class ZoomPlayerModel with ChangeNotifier {
  final Matrix4 _matrix = Matrix4.identity();

  int _currentIndex = 0;
  Timer _operation;
  bool _isSaving = false;

  // Getters
  Image get image => this._store.image;
  Image get imageFull => this._store.imageFull;
  double get imageRatio => this._store.aspectRatio;
  int get framesCount => this._store.frameCount;
  int get maxFrames => this._store.maxFrames;

  double get playerIndex => this._currentIndex.toDouble();
  bool get isPlaying => this._operation != null && this._operation.isActive;
  bool get isSaving => this._isSaving;

  ZoomStore _store;

  ZoomPlayerModel(final this._store) {
    this._store.addListener(() {
      notifyListeners();
    });
  }

  Matrix4 getCurrentFrame() {
    var playFrame = this._store.getFrame(_currentIndex);
    this._matrix.setFrom(playFrame);
    return this._matrix;
  }

  void setSlider(int newSlider) {
    this._currentIndex = newSlider.toInt();
    var playFrame = this._store.getFrame(_currentIndex);
    this._matrix.setFrom(playFrame);
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

  void _resetFrameIndex() {
    _currentIndex = 0;
    notifyListeners();
  }

  void playerPlay() {
    this._currentIndex = 0;
    playerStopGotoStart();
    const oneSec = const Duration(milliseconds: 50);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      this._currentIndex++;
      if (this._currentIndex >= this.framesCount) {
        this._currentIndex = this.framesCount;
        this.playerStop();
      }
      notifyListeners();
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

  GlobalKey _globalKey;
  GlobalKey getZoomGlobalKey() {
    return this._globalKey;
  }

  void setZoomGlobalKey(GlobalKey g) {
    this._globalKey = g;
  }

  getFrame(int i) {
    return this._store.getFrame(i);
  }

  void setSaving(bool isSaving) {
    this._isSaving = isSaving;
    notifyListeners();
  }
}

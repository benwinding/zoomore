import 'package:flutter/material.dart';

import 'dart:async';

class ZoomPlayerModel with ChangeNotifier {
  Image _image;
  Image _imageFull;
  setImage(Image img) {
    this._image = img;
    notifyListeners();
  }
  setImageFull(Image img) {
    this._imageFull = img;
    notifyListeners();
  }
  get image => this._image;
  get imageFull => this._imageFull;

  // Slider
  void setSlider(double newSlider) {
    this._currentIndex = newSlider;
    var playFrame = _frames[_currentIndex.toInt()];
    setMatrix(playFrame);
  }

  // Current Frame
  Matrix4 _matrix = Matrix4.identity();
  get matrix => this._matrix;

  resetMatrix() {
    this._matrix.setIdentity();
    notifyListeners();
  }

  void setMatrix(Matrix4 matrixInput) {
    this._matrix.setFrom(matrixInput);
    notifyListeners();
  }

  List<Matrix4> _frames = [];
  int get framesCount => _frames.length;

  void addFrame(Matrix4 m) {
    this._frames.add(m.clone());
    notifyListeners();
  }

  void resetFrames() {
    this._frames.clear();
    notifyListeners();
  }

  // Playback
  double _currentIndex = 0;
  double get playerIndex => _currentIndex;
  Timer _operation;

  bool get isPlaying => this._operation != null && this._operation.isActive;

  void _nextFrameIndex() {
    _currentIndex += 1;
    if (_currentIndex >= framesCount - 1) {
      _currentIndex = 0;
    }
    notifyListeners();
  }

  void _resetFrameIndex() {
    _currentIndex = 0;
    notifyListeners();
  }

  void playerStart() {
    playerStop();
    const oneSec = const Duration(milliseconds: 50);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      this._nextFrameIndex();
      var playFrame = _frames[_currentIndex.toInt()];
      setMatrix(playFrame);
    });
    notifyListeners();
  }

  void playerRecord() {
    resetFrames();
    this._currentIndex = 0;
    playerStop();
    const oneSec = const Duration(milliseconds: 50);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      addFrame(matrix);
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

  Matrix4 getFrame(int i) {
    return this._frames[i];
  }
}

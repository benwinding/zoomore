import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ZoomPlayerModel with ChangeNotifier, DiagnosticableTreeMixin {
  // Slider
  void setSlider(double newSlider) {
    this._currentIndex = newSlider;
    var playFrame = _frames[_currentIndex.toInt()];
    setMatrix(playFrame);
  }

  // Current Frame
  Matrix4 _matrix = Matrix4.identity();
  get matrix => this._matrix;

  reset() {
    this._matrix.setIdentity();
    notifyListeners();
  }

  void setMatrix(Matrix4 matrixInput) {
    this._matrix.setFrom(matrixInput);
    notifyListeners();
  }

  List<Matrix4> _frames = new List();
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

  void playerStart() {
    playerStop();
    const oneSec = const Duration(milliseconds: 20);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      _currentIndex += 1;
      if (_currentIndex >= framesCount - 1) {
        _currentIndex = 0;
      }
      var playFrame = _frames[_currentIndex.toInt()];
      setMatrix(playFrame);
    });
  }

  void playerRecord() {
    resetFrames();
    this._currentIndex = 0;
    playerStop();
    const oneSec = const Duration(milliseconds: 20);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      addFrame(matrix);
    });
  }

  void playerStop() {
    if (_operation != null) {
      _operation.cancel();
    }
  }
}

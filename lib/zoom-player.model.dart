import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

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

  void _nextFrame() {
    _currentIndex += 1;
    if (_currentIndex >= framesCount - 1) {
      _currentIndex = 0;
    }
    var playFrame = _frames[_currentIndex.toInt()];
    setMatrix(playFrame);
  }

  void playerStart() {
    playerStop();
    const oneSec = const Duration(milliseconds: 20);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      this._nextFrame();
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
    if (_operationSave != null) {
      _operationSave.cancel();
    }
  }

  Timer _operationSave;
  void playerSave(ScreenshotController screenshotController) {
    this._currentIndex = 0;
    playerStop();
    final imgsArr = List<File>();
    const oneSec = const Duration(milliseconds: 20);
    _operationSave = new Timer.periodic(oneSec, (Timer t) {
      setMatrix(matrix);
      if (this._currentIndex == 0) {
        this._operationSave.cancel();
        this.exportGif(imgsArr);
        return;
      }
      screenshotController.capture().then((img) {
        imgsArr.add(img);
      });
    });
  }

  Future<File> exportGif(List<File> imgsArr) {
    for (var img in imgsArr) {}
    return file;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';

import 'package:image/image.dart' as img;

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

  void _nextFrameIndex() {
    _currentIndex += 1;
    if (_currentIndex >= framesCount - 1) {
      _currentIndex = 0;
    }
  }

  void playerStart() {
    playerStop();
    const oneSec = const Duration(milliseconds: 20);
    _operation = new Timer.periodic(oneSec, (Timer t) {
      this._nextFrameIndex();
      var playFrame = _frames[_currentIndex.toInt()];
      setMatrix(playFrame);
    });
  }

  void playerStartFlitered() {
    playerStop();
    // KalmanFilter makeK() {
    //   return new KalmanFilter(R: 0.06, Q: 0.04, A: 1.12);
    // }

    // var growthFilter = makeK();
    // final oneSec = const Duration(milliseconds: 20);
    // final List<double> last4 = [];
    // _operation = new Timer.periodic(oneSec, (Timer t) {
    //   if (_currentIndex < 1) {
    //     growthFilter = makeK();
    //   }
    //   this._nextFrameIndex();
    //   final index = _currentIndex.toInt();
    //   final playFrame = _frames[index];
    //   final scale = playFrame.getMaxScaleOnAxis();
    //   last4.add(scale);
    //   if (last4.length > 3) {
    //     last4.remove(last4[0]);
    //   }
    //   final scaleFiltered = last4.reduce((a, c) => a + c) / last4.length;
    //   final playFrameCopy = playFrame.clone();
    //   playFrameCopy.scale(scaleFiltered);
    //   setMatrix(playFrameCopy);
    // });
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

  Future<File> exportGif(List<File> imgsArr) async {
    final encoder = img.GifEncoder(
      delay: 80,
    );
    imgsArr.forEach((imgItem) {
      final bytes = imgItem.readAsBytesSync();
      final image = img.decodePng(bytes);
      encoder.addFrame(image);
    });
    encoder.repeat = 0;
    final blobBytes = encoder.finish();
    final gifFile = MemoryFileSystem().file('test.dart')
      ..writeAsBytesSync(blobBytes);
    return gifFile;
  }
}

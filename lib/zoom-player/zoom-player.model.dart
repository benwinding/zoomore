import 'package:flutter/material.dart';
import 'dart:async';

class ZoomPlayerModel with ChangeNotifier {
  Matrix4 _matrix = Matrix4.identity();
  List<Matrix4> _frames = [];

  Image _image;
  Image _imageFull;
  int _currentIndex = 0;
  Timer _operation;
  double imageRatio = 1;

  // Getters
  Image get image => this._image;
  Image get imageFull => this._imageFull;
  Matrix4 get matrix => this._matrix;
  double get playerIndex => _currentIndex.toDouble();
  bool get isPlaying => this._operation != null && this._operation.isActive;
  int get framesCount => this._frames.length;
  int get maxFrames => 100;

  // Setters
  void setImage(Image img) async {
    this._image = img;
    notifyListeners();
    final i = await getImageInfo(img);
    imageRatio = i.image.width / i.image.height;
    notifyListeners();
  }

  void setImageFull(Image img) {
    this._imageFull = img;
    notifyListeners();
  }

  void setSlider(int newSlider) {
    this._currentIndex = newSlider.toInt();
    var playFrame = _frames[_currentIndex];
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

  void resetFrames() {
    this._frames.clear();
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
      this._frames.add(matrix.clone());
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

  Matrix4 getFrame(int i) {
    return this._frames[i];
  }
}

Future<ImageInfo> getImageInfo(Image img) async {
  final c = new Completer<ImageInfo>();
  img.image
    .resolve(new ImageConfiguration())        
    .addListener(new ImageStreamListener((ImageInfo i, bool _) {
      c.complete(i);
    }));
  return c.future;    
}

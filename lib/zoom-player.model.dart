import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:esys_flutter_share/esys_flutter_share.dart';

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
    if (_operationSave != null) {
      _operationSave.cancel();
    }
    notifyListeners();
  }

  Timer _operationSave;
  bool get isSaving =>
      this._operationSave != null && this._operationSave.isActive;

  void playerSave(RenderRepaintBoundary boundary) async {
    playerStop();
    Future<File> takeScreenshot() async {
      final bytes = await this._getImageBytes(boundary);
      final memoryFilePath = 'img-' + new Random().toString();
      final gifFile = MemoryFileSystem().file(memoryFilePath);
      await gifFile.writeAsBytes(bytes);
      return gifFile;
    }

    this._resetFrameIndex();
    final List<File> files = [];
    final count = this._frames.length;
    for (var i = 0; i < count; i++) {
      var playFrame = _frames[_currentIndex.toInt()];
      setMatrix(playFrame);
      this._nextFrameIndex();
      final f = await takeScreenshot();
      files.add(f);
    }
    try {
      final imgDirPath = await saveImagesTemp(files);
      final vidPath = await saveVideoTemp(imgDirPath);
      await sharedVideoPath(vidPath);
    } catch (e) {
      print(e);
    }
  }

  Future<List<int>> _getImageBytes(RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  Future<String> saveImagesTemp(List<File> imgsArr) async {
    final temp = (await getTemporaryDirectory());
    final dir = await temp.createTemp('images');
    final List<Future> futures = [];

    saveFile(File f, int i) async {
      final bytes = await f.readAsBytes();
      final imgCount = i.toString().padLeft(4, '0');
      final savePath = dir.path + '/img_' + imgCount + '.png';
      await File(savePath).writeAsBytes(bytes);
    }

    for (var i = 0; i < imgsArr.length; i++) {
      final f = imgsArr[i];
      futures.add(saveFile(f, i));
    }
    await Future.wait(futures);
    print('saved ' + imgsArr.length.toString() + ' images...');
    print('imageDir ' + dir.path);
    return dir.path;
  }

  Future<String> saveVideoTemp(String imgDirPath) async {
    final temp = await getTemporaryDirectory();
    final outPath = temp.path + '/video.mp4';
    if (await File(outPath).exists()) {
      await File(outPath).delete();
    }
    final imagesPath = imgDirPath + '/img_%04d.png';
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    final arguments = [
      "-r",
      "10",
      "-f",
      "image2",
      "-i",
      imagesPath,
      "-crf",
      "25",
      outPath
    ];
    await _flutterFFmpeg.executeWithArguments(arguments);
    await Directory(imgDirPath).delete(recursive: true);
    return outPath;
  }

  sharedVideoPath(String vidPath) async {
    final vidBytes = await File(vidPath).readAsBytes();
    await Share.file('Save image', 'video.mp4', vidBytes, 'video/mp4');
  }

  saveBytes(List<int> bytes) async {
    print('exporting: ' + bytes.length.toString() + ' bytes');
    Share.text('my text title',
        'This is my text to share with other applications.', 'image/gif');
    await Share.file('esys image', 'esys.gif', bytes, 'image/gif',
        text: 'My optional text.');
  }

  Future<File> exportGif(List<File> imgsArr) async {
    final blobBytes = await _makeGifBlobBytes(imgsArr);
    final gifFile = MemoryFileSystem().file('test.dart')
      ..writeAsBytesSync(blobBytes);
    return gifFile;
  }

  Future<List<int>> _makeGifBlobBytes(List<File> imgsArr) async {
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
    return blobBytes;
  }

  Image _image;
  get image => _image;

  setImage(Image image) {
    this._image = image;
    notifyListeners();
  }
}

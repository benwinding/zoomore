import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file/memory.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'package:image/image.dart' as img;
import 'package:zoomore/zoom-player/zoom-player.model.dart';

class ExportProvider with ChangeNotifier {
  Future<void> playerSave(RenderRepaintBoundary boundary, BuildContext c) async {
    try {
      final closeDialog = showProgressDialog(c, 'Saving Zoom', 'Please dont close the app!');
      final files = await _createImageFiles(boundary);
      final imgDirPath = await saveImagesTemp(files);
      final vidPath = await saveVideoTemp(imgDirPath);
      await saveVideoToGallery(vidPath);
      await showDialogAutoClose(c, 'Success', 'Saved Zoom to Gallery!', 1000);
      await closeDialog();
    } catch (e) {
      print(e);
    }
  }

  Future<void> playerShare(RenderRepaintBoundary boundary, BuildContext c) async {
    try {
      final c1 = showProgressDialog(c, 'Capturing Zoom', 'Please dont close the app!');
      final files = await _createImageFiles(boundary);
      final imgDirPath = await saveImagesTemp(files);
      final vidPath = await saveVideoTemp(imgDirPath);
      await sharedVideoPath(vidPath);
      await c1();
    } catch (e) {
      print(e);
    }
  }

  void enterSaveMode() {
    GetIt.I.get<ZoomPlayerModel>().setSaving(false);
  }

  void leaveSaveMode() {
    GetIt.I.get<ZoomPlayerModel>().setSaving(true);
  }

  Future<List<File>> _createImageFiles(RenderRepaintBoundary boundary) async {
    final rnd = new math.Random();
    Future<File> takeScreenshot() async {
      final bytes = await this._getImageBytes(boundary);
      final memoryFilePath = 'img-' + rnd.nextInt(9999999).toString();
      final gifFile = MemoryFileSystem().file(memoryFilePath);
      await gifFile.writeAsBytes(bytes);
      return gifFile;
    }

    final m = GetIt.I.get<ZoomPlayerModel>();
    m.playerStopGotoStart();
    final List<File> files = [];
    final count = m.framesCount;
    for (var i = 0; i < count; i++) {
      m.setSlider(i);
      final f = await takeScreenshot();
      files.add(f);
    }
    return files;
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
      // "-crf", 
      // "25",
      // ^ DOESN'T WORK ON IOS
      outPath
    ];
    print('FFMPEG ARGS:' + arguments.join(' | '));
    await _flutterFFmpeg.executeWithArguments(arguments);
    await Directory(imgDirPath).delete(recursive: true);
    return outPath;
  }

  sharedVideoPath(String vidPath) async {
    final vidBytes = await File(vidPath).readAsBytes();
    await Share.file('Save image', 'video.mp4', vidBytes, 'video/mp4');
  }

  saveVideoToGallery(String vidPath) async {
    print('saving to file: ' + vidPath);
    final result = await ImageGallerySaver.saveFile(vidPath);
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
}

showProgressDialog(BuildContext context, String title, String description) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  onClose() async {
    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(Duration(milliseconds: 100));
  }

  return onClose;
}

showDialogAutoClose(BuildContext context, String title, String description, int closeDelayMs) async {
  final closeCb = showProgressDialog(context, title, description);
  await Future.delayed(Duration(milliseconds: closeDelayMs));
  await closeCb();
}
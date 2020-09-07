// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zoomore/zoom-player.model.dart';

void main() {
  test('Model saves images', () async {
    var model = ZoomPlayerModel();
    var gifFile = await model.exportGif([
      File('./test_imgs/test.gif-frames/frame_00.png'),
      File('./test_imgs/test.gif-frames/frame_01.png'),
      File('./test_imgs/test.gif-frames/frame_02.png'),
      File('./test_imgs/test.gif-frames/frame_03.png'),
      File('./test_imgs/test.gif-frames/frame_04.png'),
      File('./test_imgs/test.gif-frames/frame_05.png'),
    ]);
  });
}

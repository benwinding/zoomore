import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zoomore/zoom-player.model.dart';

void main() {
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
  test('Model saves images', () async {
    try {
      final model = ZoomPlayerModel();
      final dir = './test/test_imgs/test.gif-frames/';
      final gifFile = await model.exportGif([
        File(dir + 'frame_0.png'),
        File(dir + 'frame_1.png'),
        File(dir + 'frame_2.png'),
        File(dir + 'frame_3.png'),
        File(dir + 'frame_4.png'),
        File(dir + 'frame_5.png'),
        File(dir + 'frame_6.png'),
        File(dir + 'frame_7.png'),
        File(dir + 'frame_8.png'),
        File(dir + 'frame_9.png')
      ]);
      final bytes = gifFile.readAsBytesSync();
      final outFile = File('./test/output.gif');
      if (outFile.existsSync()) {
        outFile.deleteSync();
      }
      outFile.writeAsBytesSync(bytes);
    } catch (e) {
      print(e);
    }
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/image-grid/image-grid.dart';
import 'package:zoomore/layouts/BlankScreen.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/screens/screen.abstract.dart';
import 'package:zoomore/screens/screens.model.dart';

class ImageScreenButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<ScreensModel>();
    return ButtonsBottom(
        prev: ButtonState(hide: true),
        next: ButtonState(onTap: () {
          s.nextScreen();
        }));
  }
}

class BlankButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<ScreensModel>();
    return ButtonsBottom(prev: ButtonState(onTap: () {
      s.prevScreen();
    }), next: ButtonState(onTap: () {
      s.nextScreen();
    }));
  }
}

class ImageScreen implements ZScreen {
  @override
  Widget buttons = ImageScreenButtons();

  @override
  Widget component = ImagesGrid(onTapImage: () async {});

  @override
  bool valid = true;
}

class ZoomScreen implements ZScreen {
  @override
  Widget buttons = BlankButtons();

  @override
  Widget component = BlankScreen(color: Colors.amber);
  // Widget component = ZoomPlayer();

  @override
  bool valid;
}

class EmptyColorScreen implements ZScreen {
  @override
  Widget buttons = BlankButtons();

  @override
  Widget component = BlankScreen(color: Colors.red);

  @override
  bool valid;
}

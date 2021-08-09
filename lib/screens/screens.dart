import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:zoomore/image-grid/image-grid.dart';
import 'package:zoomore/layouts/BlankScreen.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/screens/screen.abstract.dart';
import 'package:zoomore/screens/screens.model.dart';
import 'package:zoomore/zoom-player/zoom-player.dart';

class ImageScreenButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<ScreensModel>();
    return ButtonsBottom(
        prev: ButtonState(hide: true),
        next: ButtonState(onTap: () {
          s.nextScreen();
        }),
        hintText: 'Select image');
  }
}

class BlankButtons extends StatelessWidget {
  String hintText;

  BlankButtons(this.hintText) {}

  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<ScreensModel>();
    return ButtonsBottom(
      prev: ButtonState(onTap: () {
        s.prevScreen();
      }),
      next: ButtonState(onTap: () {
        s.nextScreen();
      }),
      hintText: this.hintText,
    );
  }
}

class ImageScreen implements ZScreen {
  @override
  Widget buttons = ImageScreenButtons();

  @override
  Widget component = ImagesGrid();

  @override
  bool valid = true;
}

class ZoomScreen implements ZScreen {
  @override
  Widget buttons = BlankButtons('Pinch and Zoom!');

  @override
  Widget component = ZoomPage();

  @override
  bool valid;
}

class EmptyColorScreen implements ZScreen {
  @override
  Widget buttons = BlankButtons('Share!');

  @override
  Widget component = BlankScreen(color: Colors.red);

  @override
  bool valid;
}

class ZoomPage extends StatefulWidget {
  @override
  _ZoomPageState createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.shade200,
        child: Center(
          child: ZoomPlayer(height: 400),
        ));
  }
}

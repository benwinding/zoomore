import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/zoom-player/zoom-player.dart';

import 'base/page.provider.dart';
import 'base/page.interface.dart';

class ZoomPage implements PageInterface {
  @override
  Widget buttons = BlankButtons();

  @override
  Widget component = ZoomPageComponent();

  @override
  bool valid;
}

class BlankButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();
    return ButtonsBottom(
      prev: ButtonState(onTap: () {
        s.prevScreen();
      }),
      next: ButtonState(onTap: () {
        s.nextScreen();
      }),
      hintText: 'Pinch and Zoom!',
    );
  }
}

class ZoomPageComponent extends StatefulWidget {
  @override
  _ZoomPageState createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.shade200,
        child: Center(
          child: ZoomPlayer(height: 400),
        ));
  }
}
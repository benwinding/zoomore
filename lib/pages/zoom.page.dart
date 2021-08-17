import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/zoom-player/zoom-recorder.dart';

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
        s.gotoScreen(0);
      }),
      next: ButtonState(onTap: () {
        s.gotoScreen(2);
      }),
      hintText: 'Pinch and Zoom!',
    );
  }
}

class ZoomPageComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.shade200,
        child: Center(
          child: ZoomRecorder(),
        ));
  }
}

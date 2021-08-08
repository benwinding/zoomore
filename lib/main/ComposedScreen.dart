import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/screens/screens.model.dart';

import '../image-grid/image-grid-model.dart';
import '../zoom-player/zoom-player.model.dart';

import '../layouts/TransitionContainer.dart';

class ComposedScreen extends StatefulWidget {
  @override
  _ComposedScreenState createState() => _ComposedScreenState();
}

class _ComposedScreenState extends State<ComposedScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int index = 0;

  _ComposedScreenState() {
    this._controller = new AnimationController(vsync: this);
    GetIt.I.get<ScreensModel>().addListener(this.onScreenChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    GetIt.I.get<ScreensModel>().removeListener(this.onScreenChange);
  }

  void onScreenChange() {
    setState(() {
      index = GetIt.I.get<ScreensModel>().currentScreenIndex;
    });
  }

  static Future<void> getImage(BuildContext context) async {
    final imgFull =
        await context.read<ImageGridModel>().fetchCurrentImageFull();
    context.read<ZoomPlayerModel>().setImageFull(imgFull);
  }

  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<ScreensModel>();

    final body = TransitionContainer(
      index: index,
      children: s.screenComponents,
      curveIn: Curves.easeInExpo,
      curveOut: Curves.easeOutExpo,
      durationMs: 700,
    );

    return Scaffold(
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: s.currentScreenButtons,
        ));
  }
}

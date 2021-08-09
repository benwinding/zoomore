import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../pages/page.provider.dart';
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
    GetIt.I.get<PagesProvider>().addListener(this.onScreenChange);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    GetIt.I.get<PagesProvider>().removeListener(this.onScreenChange);
  }

  void onScreenChange() {
    setState(() {
      index = GetIt.I.get<PagesProvider>().currentScreenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();

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

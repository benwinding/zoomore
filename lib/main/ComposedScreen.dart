import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/screens/screens.model.dart';
import '../screens/screens.dart';

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

  _ComposedScreenState() {
    this._controller = new AnimationController(vsync: this);
    GetIt.I
        .get<ScreensModel>()
        .initScreens(() => [ImageScreen(), ZoomScreen(), EmptyColorScreen()]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static Future<void> getImage(BuildContext context) async {
    final imgFull =
        await context.read<ImageGridModel>().fetchCurrentImageFull();
    context.read<ZoomPlayerModel>().setImageFull(imgFull);
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    // final BlankPage = (ui.Color c, String key) {
    //   return BlankScreen(color: c, width: width, height: height, key: Key(key));
    // };

    // Future<void> onTapImage() async {
    //   final imgThumb = context.read<ImageGridModel>().selectedImage;
    //   context.read<ZoomPlayerModel>().setImage(imgThumb);
    //   setState(() {
    //     _index = 1;
    //   });
    // }

    final s = GetIt.I.get<ScreensModel>();

    final body = TransitionContainer(
      index: s.currentScreenIndex,
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

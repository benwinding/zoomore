import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/zoom-player/zoom-player.dart';

import '../image-grid/image-grid-model.dart';
import '../image-grid/image-grid.dart';

import '../zoom-player/zoom-player.model.dart';

import 'BlankScreen.dart';
import '../layouts/TransitionContainer.dart';
import 'ButtonsBottom.dart';

import 'dart:ui' as ui;

import '../layouts/LayoutTopBottom.dart';

class ComposedScreen extends StatefulWidget {
  @override
  _ComposedScreenState createState() => _ComposedScreenState();
}

class _ComposedScreenState extends State<ComposedScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int _indexMax = 0;

  AnimationController _controller;

  _ComposedScreenState() {
    this._controller = new AnimationController(vsync: this);
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final BlankPage = (ui.Color c, String key) {
      return BlankScreen(color: c, width: width, height: height, key: Key(key));
    };

    Future<void> onTapImage() async {
      final imgThumb = context.read<ImageGridModel>().selectedImage;
      context.read<ZoomPlayerModel>().setImage(imgThumb);
      setState(() {
        _index = 1;
      });
    }

    final hasImage = context.watch<ZoomPlayerModel>().image != null;
    final body = TransitionContainer(
      index: _index,
      setMaxCount: (count) => this.setState(() {
        _indexMax = count;
      }),
      children: [
        ImagesGrid(onTapImage: onTapImage),
        ZoomPlayer(),
        BlankPage(Colors.red, '1'),
        BlankPage(Colors.blue, '2'),
      ],
      curveIn: Curves.easeInExpo,
      curveOut: Curves.easeOutExpo,
      durationMs: 700,
    );

    return Scaffold(
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: BottomButtons(
            index: _index,
            indexMax: _indexMax,
            disabledNext: true,
            disabledPrev: true,
            onPrev: () => this.setState(() {
              _index > 0 ? _index-- : _index = 0;
            }),
            onNext: () => this.setState(() {
              _index <= _indexMax ? _index++ : _index = _indexMax - 1;
            }),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../image-grid/image-grid-model.dart';
import '../image-grid/image-grid.dart';

import '../zoom-player/zoom-player.model.dart';
import '../zoom-player/zoom-player.dart';

import 'BlankScreen.dart';
import './TransitionContainer.dart';

class ComposedScreen extends StatefulWidget {
  @override
  _ComposedScreenState createState() => _ComposedScreenState();
}

class _ComposedScreenState extends State<ComposedScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  AnimationController _controller;

  _ComposedScreenState() {
    this._controller = new AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: TransitionContainer(index: _index, children: [
          ImagesGrid(onTapImage: () async {
            final imgThumb = context.read<ImageGridModel>().selectedImage;
            context.read<ZoomPlayerModel>().setImage(imgThumb);
            setState(() {
              _index = 1;
            });
            await Future.delayed(Duration(seconds: 1));
            final imgFull =
                await context.read<ImageGridModel>().fetchCurrentImageFull();
            context.read<ZoomPlayerModel>().setImageFull(imgFull);
          }),
          ZoomPlayer(),
          BlankScreen(
              color: Colors.red,
              width: width,
              height: height,
              key: Key('1_red')),
          BlankScreen(
              color: Colors.green,
              width: width,
              height: height,
              key: Key('2_green')),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _index == 0
                  ? SizedBox(height: 5, width: 5)
                  : FloatingActionButton(
                      child: Icon(Icons.navigate_before),
                      onPressed: () async {
                        setState(() {
                          _index != 0 ? _index-- : _index = 0;
                        });
                      },
                    ),
              Text(_index.toString()),
              FloatingActionButton(
                child: Icon(Icons.navigate_next),
                onPressed: () async {
                  setState(() {
                    _index != 2 ? _index++ : _index = 2;
                  });
                },
              )
            ],
          ),
        ));
  }
}

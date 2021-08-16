import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'zoom-player.model.dart';
import 'zoomable-widget.dart';
import 'zoom-controls.dart';

class ZoomPlayer extends StatefulWidget {
  @override
  _ZoomPlayerState createState() => _ZoomPlayerState();
}

class _ZoomPlayerState extends State<ZoomPlayer> {
  final GlobalKey globalKey = GlobalKey();
  final double controlsHeight = 100;

  double viewerHeight = 400;

  double playerIndex;
  double framesCount;

  bool isPlaying;
  bool isSaving;
  Matrix4 matrix;
  Image image;
  Image imageFull;

  int maxFrames = 100;
  double screenWidth = 400;
  double screenHeight = 400;
  bool screenInitialized = false;

  _ZoomPlayerState() {
    GetIt.I.get<ZoomPlayerModel>().addListener(this.onModelChanged);
  }

  @override
  void initState() {
    super.initState();
    this.onModelChanged();
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I.get<ZoomPlayerModel>().removeListener(this.onModelChanged);
  }

  void onModelChanged() {
    setState(() {
      final m = GetIt.I.get<ZoomPlayerModel>();
      playerIndex = m.playerIndex;
      isPlaying = m.isPlaying;
      matrix = m.matrix;
      framesCount = m.framesCount.toDouble();
      maxFrames = m.maxFrames;
      image = m.image;
      imageFull = m.imageFull;
      viewerHeight = calculateViewerHeight(
        ratio: m.imageRatio,
        controlsHeight: this.controlsHeight,
        screenWidth: this.screenWidth,
        maxHeight: this.screenHeight - 100,
      );
    });

    print(framesCount);
  }

  calculateViewerHeight(
      {double ratio,
      double screenWidth,
      double controlsHeight,
      double maxHeight}) {
    final minHeight = screenWidth / 2;
    final calHeight = (screenWidth / ratio) + controlsHeight;
    if (calHeight > maxHeight) {
      return maxHeight;
    }
    if (calHeight < minHeight) {
      return minHeight;
    }
    return calHeight;
  }

  calculateScreenSize(BuildContext c) {
    if (this.screenInitialized) {
      return;
    }
    setState(() {
      this.screenWidth = MediaQuery.of(c).size.width;
      this.screenHeight = MediaQuery.of(c).size.height;
      this.screenInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.calculateScreenSize(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
            children: [
              buildZoomArea(context),
              ZoomControls(
                playerIndex: this.framesCount,
                framesCount: this.maxFrames,
                controlsHeight: this.controlsHeight,
                isPlaying: this.isPlaying,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildZoomArea(BuildContext context) {
    // final imageFull = imageFull;
    double height = this.viewerHeight;
    final imageThumb = image;

    final screenButton = Container(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () {
              GetIt.I.get<ZoomPlayerModel>().resetMatrix();
            },
            child: Icon(Icons.close_fullscreen_sharp)));
    return RepaintBoundary(
      key: globalKey,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            color: Colors.black87,
            child: ZoomableWidget(
                onChange: (m) =>
                    GetIt.I.get<ZoomPlayerModel>().updateMatrixFromGuesture(m),
                matrix: matrix,
                key: Key('zoomy'),
                child: Wrap(
                  children: [
                    Container(
                      height: height - this.controlsHeight,
                      child: Wrap(
                        children: [
                          Stack(children: [
                            // AnimatedOpacity(
                            //   opacity: imageFull == null ? 1.0 : 0.0,
                            //   duration: Duration(milliseconds: 500),
                            //   child: imageThumb,
                            // ),
                            // AnimatedOpacity(
                            //   opacity: imageFull == null ? 0.0 : 1.0,
                            //   duration: Duration(milliseconds: 500),
                            //   child: imageFull == null ? Container : imageFull,
                            // ),

                            // imageFull,
                            // imageThumb,

                            AnimatedOpacity(
                              opacity: imageFull == null ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: imageThumb,
                            ),
                            imageFull == null ? Container() : imageFull,
                          ])
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          screenButton,
        ],
      ),
    );
  }
}

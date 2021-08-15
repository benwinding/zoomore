import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import './zoom-player.model.dart';
import './zoomable-widget.dart';

class ZoomPlayer extends StatefulWidget {
  @override
  _ZoomPlayerState createState() => _ZoomPlayerState();
}

class _ZoomPlayerState extends State<ZoomPlayer> {
  final GlobalKey globalKey = GlobalKey();
  final double controlsHeight = 150;

  double screenHeight = 600;
  double screenWidth = 400;
  double viewerHeight = 400;

  double playerIndex;
  double framesCount;

  bool isPlaying;
  bool isSaving;
  Matrix4 matrix;
  Image image;
  Image imageFull;

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
      image = m.image;
      imageFull = m.imageFull;
      this.viewerHeight = (this.screenWidth / m.imageRatio) + this.controlsHeight - 20;
      print('new viewer height=' + this.viewerHeight.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [buildZoomArea(context), buildControls(context)],
          )
        ],
      ),
    );
  }

  Widget buildControls(BuildContext context) {
    final m = GetIt.I.get<ZoomPlayerModel>();

    makebutton(
        {IconData icon,
        Function onPressed,
        bool hide = false,
        bool disabled = false}) {
      return hide
          ? SizedBox(width: 55, height: 55)
          : ElevatedButton(
              onPressed: () {
                onPressed();
              },
              child: Icon(icon));
    }

    makeSlider() {
      makeTextItem({String text, double left = 0, double right = 0}) {
        return Container(
          child: Text(text,
              style: TextStyle(color: Colors.blue.shade600, fontSize: 10)),
          padding: EdgeInsets.only(left: left, right: right, top: 35),
          margin: EdgeInsets.only(top: 0),
        );
      }

      return Stack(children: [
        Slider(
          value: playerIndex,
          label: playerIndex.toStringAsFixed(0),
          min: 0,
          max: framesCount,
          divisions: 100,
          onChanged: (value) {
            m.setSlider(value);
          },
        ),
        Row(
          children: [
            makeTextItem(text: '0', left: 20),
            Expanded(child: Container()),
            makeTextItem(text: framesCount.toInt().toString(), right: 20),
          ],
        )
      ]);
    }

    return Container(
        color: Colors.lightBlue.shade100,
        height: this.controlsHeight,
        child: Column(children: [
          makeSlider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(alignment: MainAxisAlignment.center, children: [
              makebutton(
                  icon: Icons.fiber_manual_record, onPressed: m.playerRecord),
              makebutton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (m.isPlaying) {
                      m.playerStop();
                    } else {
                      m.playerStart();
                    }
                  }),
              makebutton(
                  icon: Icons.close_fullscreen_sharp, onPressed: m.resetMatrix),
            ]),
          ),
          // Row(children: [
          //   Text(playerIndex.toInt().toString() + ' '),
          //   Text(framesCount.toInt().toString() + ' Frames'),
          //   isSaving ? Text('Saving....') : Text('')
          // ])
        ]));
  }

  Widget buildZoomArea(BuildContext context) {
    // final imageFull = imageFull;
    double height = this.viewerHeight;
    final imageThumb = image;
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        color: Colors.amber,
        child: ZoomableWidget(
            onChange: (m) => GetIt.I.get<ZoomPlayerModel>().updateMatrixFromGuesture(m),
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
                        imageFull == null ? Container() : imageFull
                      ])
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

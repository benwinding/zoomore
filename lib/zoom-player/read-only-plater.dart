import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import './zoom-player.model.dart';
import './zoomable-widget.dart';

class ZoomPlayerReadOnly extends StatefulWidget {
  @override
  _ZoomPlayerReadOnlyState createState() => _ZoomPlayerReadOnlyState();

  final double height;

  ZoomPlayerReadOnly({this.height});
}

class _ZoomPlayerReadOnlyState extends State<ZoomPlayerReadOnly> {
  final GlobalKey globalKey = GlobalKey();
  final double controlsHeight = 150;

  double playerIndex;
  double framesCount;

  bool isPlaying;
  bool isSaving;
  Matrix4 matrix;
  Image image;
  Image imageFull;

  _ZoomPlayerReadOnlyState() {
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
              makebutton(icon: Icons.skip_previous, onPressed: m.playerStopGotoStart),
              makebutton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (m.isPlaying) {
                      m.playerStop();
                    } else {
                      m.playerStart();
                    }
                  }),
            ]),
          ),
        ]));
  }

  Widget buildZoomArea(BuildContext context) {
    // final imageFull = imageFull;
    double height = this.widget.height;
    final imageThumb = image;
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        color: Colors.amber,
        child: ZoomableWidget(
            onChange: (m) => GetIt.I.get<ZoomPlayerModel>().setMatrix(m),
            matrix: matrix,
            key: Key('zoomy'),
            child: Wrap(
              children: [
                Container(
                  height: height - this.controlsHeight,
                  child: Wrap(
                    children: [
                      Stack(children: [
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

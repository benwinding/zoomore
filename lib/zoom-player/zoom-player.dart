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
      isSaving = m.isSaving;
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

    return Container(
        color: Colors.lightBlue.shade100,
        height: this.controlsHeight,
        child: Column(children: [
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
                  icon: Icons.close_fullscreen_sharp, onPressed: m.reset),
              makebutton(
                  icon: Icons.save_alt,
                  onPressed: () async {
                    RenderRepaintBoundary boundary =
                        globalKey.currentContext.findRenderObject();
                    m.playerSave(boundary);
                    final snackBar = SnackBar(
                      content: Text('Saved to gallery!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
              makebutton(
                  icon: Icons.share,
                  onPressed: () {
                    RenderRepaintBoundary boundary =
                        globalKey.currentContext.findRenderObject();
                    m.playerShare(boundary);
                  }),
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
    double height = MediaQuery.of(context).size.height;
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

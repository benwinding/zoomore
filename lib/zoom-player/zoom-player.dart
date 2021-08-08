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
    final m = GetIt.I.get<ZoomPlayerModel>();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              buildZoomArea(context),
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
                child:
                    ButtonBar(alignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: () {
                        m.playerRecord();
                      },
                      child: Icon(Icons.fiber_manual_record)),
                  ElevatedButton(
                      onPressed: () {
                        if (m.isPlaying) {
                          m.playerStop();
                        } else {
                          m.playerStart();
                        }
                      },
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                  ElevatedButton(
                      onPressed: () {
                        m.reset();
                      },
                      child: Icon(Icons.close_fullscreen_sharp)),
                  ElevatedButton(
                      onPressed: () async {
                        RenderRepaintBoundary boundary =
                            globalKey.currentContext.findRenderObject();
                        m.playerSave(boundary);
                        final snackBar = SnackBar(
                          content: Text('Saved to gallery!'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Icon(Icons.save_alt)),
                  ElevatedButton(
                      onPressed: () {
                        RenderRepaintBoundary boundary =
                            globalKey.currentContext.findRenderObject();
                        m.playerShare(boundary);
                      },
                      child: Icon(Icons.share)),
                ]),
              ),
              Wrap(children: [
                Text(playerIndex.toInt().toString() + ' '),
                Text(framesCount.toInt().toString() + ' Frames'),
                isSaving ? Text('Saving....') : Text('')
              ])
            ],
          )
        ],
      ),
    );
  }

  Widget buildZoomArea(BuildContext context) {
    // final imageFull = imageFull;
    final imageThumb = image;
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        color: Color.fromRGBO(
          222,
          222,
          222,
          1,
        ),
        child: ZoomableWidget(
            onChange: (m) => GetIt.I.get<ZoomPlayerModel>().setMatrix(m),
            matrix: matrix,
            key: Key('zoomy'),
            child: Wrap(
              children: [
                Container(
                  width: 400,
                  height: 600,
                  color: Color.fromRGBO(
                    0,
                    0,
                    0,
                    1,
                  ),
                  child: Stack(children: [
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
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}

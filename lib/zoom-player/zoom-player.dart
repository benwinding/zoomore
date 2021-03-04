import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './zoom-player.model.dart';
import './zoomable-widget.dart';

class ZoomPlayer extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              buildZoomArea(context),
              Slider(
                value: context.watch<ZoomPlayerModel>().playerIndex,
                label: context
                    .watch<ZoomPlayerModel>()
                    .playerIndex
                    .toStringAsFixed(0),
                min: 0,
                max: context.watch<ZoomPlayerModel>().framesCount.toDouble(),
                divisions: 100,
                onChanged: (value) {
                  context.read<ZoomPlayerModel>().setSlider(value);
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                    ButtonBar(alignment: MainAxisAlignment.center, children: [
                  RaisedButton(
                      onPressed: () {
                        context.read<ZoomPlayerModel>().playerRecord();
                      },
                      child: Icon(Icons.fiber_manual_record)),
                  RaisedButton(
                      onPressed: () {
                        final m = context.read<ZoomPlayerModel>();
                        if (m.isPlaying) {
                          m.playerStop();
                        } else {
                          m.playerStart();
                        }
                      },
                      child: Icon(context.watch<ZoomPlayerModel>().isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                  RaisedButton(
                      onPressed: () {
                        context.read<ZoomPlayerModel>().reset();
                      },
                      child: Icon(Icons.close_fullscreen_sharp)),
                  RaisedButton(
                      onPressed: () async {
                        RenderRepaintBoundary boundary =
                            globalKey.currentContext.findRenderObject();
                        await context
                            .read<ZoomPlayerModel>()
                            .playerSave(boundary);
                        final snackBar = SnackBar(
                          content: Text('Saved to gallery!'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Icon(Icons.save_alt)),
                  RaisedButton(
                      onPressed: () {
                        RenderRepaintBoundary boundary =
                            globalKey.currentContext.findRenderObject();
                        context.read<ZoomPlayerModel>().playerShare(boundary);
                      },
                      child: Icon(Icons.share)),
                ]),
              ),
              Wrap(children: [
                Text(context
                        .watch<ZoomPlayerModel>()
                        .playerIndex
                        .toInt()
                        .toString() +
                    ' '),
                Text(context
                        .watch<ZoomPlayerModel>()
                        .framesCount
                        .toInt()
                        .toString() +
                    ' Frames'),
                context.watch<ZoomPlayerModel>().isSaving
                    ? Text('Saving....')
                    : Text('')
              ])
            ],
          )
        ],
      ),
    );
  }

  Widget buildZoomArea(BuildContext context) {
    final imageFull = context.watch<ZoomPlayerModel>().imageFull;
    final imageThumb = context.watch<ZoomPlayerModel>().image;
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
          onChange: (m) => context.read<ZoomPlayerModel>().setMatrix(m),
          matrix: context.watch<ZoomPlayerModel>().matrix,
          key: Key('zoomy'),
          child: Container(
            width: 400,
            height: 450,
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
              imageFull == null ? Container : imageFull
            ]),
          ),
        ),
      ),
    );
  }
}

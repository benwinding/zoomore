import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zoomore/zoom-player.model.dart';
import 'components/zoomable-widget.dart';
import 'package:image_picker/image_picker.dart';

class ZoomPlayer extends StatelessWidget {
  final picker = ImagePicker();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(children: [
            Screenshot(
              controller: screenshotController,
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
                    child: context.watch<ZoomPlayerModel>().image,
                  ),
                ),
              ),
            ),
            Slider(
              value: context.watch<ZoomPlayerModel>().playerIndex,
              label: context.watch<ZoomPlayerModel>().playerIndex.toString(),
              min: 0,
              max: context.watch<ZoomPlayerModel>().framesCount.toDouble(),
              divisions: 100,
              onChanged: (value) {
                context.read<ZoomPlayerModel>().setSlider(value);
              },
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    onPressed: () {
                      context.read<ZoomPlayerModel>().playerRecord();
                    },
                    child: Icon(Icons.fiber_manual_record)),
                RaisedButton(
                    onPressed: () {
                      context.read<ZoomPlayerModel>().playerStart();
                    },
                    child: Icon(Icons.play_circle_outline)),
                RaisedButton(
                    onPressed: () {
                      context.read<ZoomPlayerModel>().playerStartFlitered();
                    },
                    child: Icon(Icons.play_circle_filled)),
                RaisedButton(
                    onPressed: () {
                      context.read<ZoomPlayerModel>().playerStop();
                    },
                    child: Icon(Icons.stop)),
                // RaisedButton(
                //     onPressed: () {
                //       context
                //           .read<ZoomPlayerModel>()
                //           .playerSave(this.screenshotController);
                //     },
                //     child: Icon(Icons.save_alt)),
              ],
            ),
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
                ' Frames')
          ])
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:zoomore/zoom-player.model.dart';
import 'components/zoomable-widget.dart';
import 'package:image_picker/image_picker.dart';

class ZoomPlayer extends StatefulWidget {
  @override
  _ZoomPlayerState createState() => _ZoomPlayerState();
}

class _ZoomPlayerState extends State<ZoomPlayer> {
  final picker = ImagePicker();
  File _image;

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(children: [
            Container(
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
                  height: 550,
                  color: Color.fromRGBO(
                    0,
                    0,
                    0,
                    1,
                  ),
                  child: _image != null
                      ? Image.file(_image)
                      : Image.asset('assets/large-image.jpg'),
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
                    child: Icon(Icons.play_arrow)),
                RaisedButton(
                    onPressed: () {
                      context.read<ZoomPlayerModel>().playerStop();
                    },
                    child: Icon(Icons.stop)),
                RaisedButton(
                    onPressed: () {
                      this.getImage();
                    },
                    child: Icon(Icons.image))
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

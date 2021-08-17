import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  final double playerIndex;
  final int framesCount;
  final double controlsHeight;
  final bool isPlaying;
  final bool isPlayOnly;
  final Function onPlayerStop;
  final Function onPlayerRecord;

  const ZoomControls(
      {Key key,
      this.playerIndex,
      this.framesCount,
      this.controlsHeight,
      this.isPlaying,
      @required this.onPlayerStop,
      @required this.onPlayerRecord,
      this.isPlayOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          value: this.playerIndex,
          label: this.playerIndex.toStringAsFixed(0),
          min: 0,
          max: this.framesCount.toDouble(),
          divisions: 100,
          onChanged: (value) {
            // m.setSlider(value.toInt());
          },
        ),
        Row(
          children: [
            makeTextItem(text: '0', left: 20),
            Expanded(child: Container()),
            makeTextItem(text: this.framesCount.toInt().toString(), right: 20),
          ],
        )
      ]);
    }

    return Container(
        color: Colors.lightBlue.shade50,
        height: this.controlsHeight,
        child: Wrap(alignment: WrapAlignment.center, children: [
          Container(height: 30, child: Wrap(children: [makeSlider()])),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ButtonBar(alignment: MainAxisAlignment.center, children: [
              makebutton(
                  icon: isPlaying
                      ? Icons.pause
                      : Icons.fiber_manual_record_rounded,
                  onPressed: () {
                    if (isPlaying) {
                      onPlayerStop();
                    } else {
                      onPlayerRecord();
                    }
                  }),
            ]),
          ),
        ]));
  }
}

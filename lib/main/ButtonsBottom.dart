import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final int index;
  final int indexMax;
  final Function onNext;
  final Function onPrev;

  BottomButtons({
    Key key,
    @required this.index,
    @required this.indexMax,
    @required this.onNext,
    @required this.onPrev,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        index == 0
            ? SizedBox(height: 5, width: 5)
            : FloatingActionButton(
                child: Icon(Icons.navigate_before),
                onPressed: () async {
                  onPrev();
                },
              ),
        Text(index.toString()),
        index == indexMax - 1
            ? SizedBox(height: 5, width: 5)
            : FloatingActionButton(
                child: Icon(Icons.navigate_next),
                onPressed: () async {
                  onNext();
                },
              )
      ],
    );
  }
}

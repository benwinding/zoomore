import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final int index;
  final int indexMax;
  final Function onNext;
  final Function onPrev;
  bool disabledNext = false;
  bool disabledPrev = false;

  BottomButtons({
    Key key,
    bool disabledNext,
    bool disabledPrev,
    @required this.index,
    @required this.indexMax,
    @required this.onNext,
    @required this.onPrev,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    butt(IconData icon, Function onPressed, bool hide, bool disabled) {
      return hide
          ? SizedBox(width: 55, height: 55)
          : FloatingActionButton(
              child: Icon(icon),
              onPressed: disabled ? null : onPressed,
              backgroundColor: disabled ? Colors.grey : null,
            );
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          butt(Icons.navigate_before, onPrev, index == 0, disabledPrev),
          Container(
            child: Text(
              'Select an image!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: Colors.grey.shade700,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.fromLTRB(0,0,0,12),
          ),
          butt(
              Icons.navigate_next, onNext, index == indexMax - 1, disabledNext),
        ]);
  }
}

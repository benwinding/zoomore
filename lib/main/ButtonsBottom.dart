import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonState {
  bool hide;
  bool disabled;
  Function onTap;

  ButtonState({this.hide = false, this.disabled = false, this.onTap});
}

class ButtonsBottom extends StatelessWidget {
  final ButtonState prev;
  final ButtonState next;
  final String hintText;

  ButtonsBottom(
      {Key key, @required this.next, @required this.prev, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    makebutton(IconData icon, Function onPressed, bool hide, bool disabled) {
      return hide
          ? SizedBox(width: 55, height: 55)
          : FloatingActionButton(
              child: Icon(icon),
              onPressed: disabled ? null : onPressed,
              backgroundColor: disabled ? Colors.grey : null,
            );
    }

    final buttonPrev =
        makebutton(Icons.navigate_before, prev.onTap, prev.hide, prev.disabled);
    final buttonNext =
        makebutton(Icons.navigate_next, next.onTap, next.hide, next.disabled);

    final hintText = this.hintText != null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade700.withAlpha(100),
              border: Border.all(
                color: Colors.transparent,
                width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(100))
            ),
            child: Text(
              this.hintText,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
          )
        : Container();

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buttonPrev,
          hintText,
          buttonNext,
        ]);
  }
}

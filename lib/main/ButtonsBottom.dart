import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonState {
  bool hide;
  bool disabled;
  IconData icon;
  Function onTap;

  ButtonState(
      {this.hide = false, this.disabled = false, this.onTap, this.icon});

  void setDefaultIcon(IconData icon) {
    if (this.icon == null) {
      this.icon = icon;
    }
  }
}

class ButtonsBottom extends StatelessWidget {
  final ButtonState prev;
  final ButtonState next;
  final String hintText;

  ButtonsBottom(
      {Key key, @required this.next, @required this.prev, this.hintText})
      : super(key: key) {
    this.prev.setDefaultIcon(Icons.navigate_before);
    this.next.setDefaultIcon(Icons.navigate_next);
  }

  makebutton(ButtonState s) {
    return s.hide
        ? SizedBox(width: 55, height: 55)
        : FloatingActionButton(
            child: Icon(s.icon),
            onPressed: s.disabled ? null : s.onTap,
            backgroundColor: s.disabled ? Colors.grey : null,
          );
  }

  @override
  Widget build(BuildContext context) {
    final buttonPrev = makebutton(prev);
    final buttonNext = makebutton(next);

    final hintText = this.hintText != null
        ? Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade700.withAlpha(100),
                border: Border.all(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(100))),
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

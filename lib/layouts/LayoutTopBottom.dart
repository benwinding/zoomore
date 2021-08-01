import 'package:flutter/material.dart';

class LayoutTopBottom extends StatelessWidget {
  final Widget footer;
  final Widget content;
  final double footerHeight;

  LayoutTopBottom(
      {@required final this.content,
      @required final this.footer,
      this.footerHeight: 100});

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
            child: content,
          ),
          new Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              width: 1.7976931348623157e+308,
              height: footerHeight,
              child: footer)
        ]);
  }
}

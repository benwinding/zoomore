import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const BlankScreen({Key key, this.color, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: this.color),
    );
  }
}

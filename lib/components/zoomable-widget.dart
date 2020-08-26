import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../zoom-model.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;

  const ZoomableWidget({Key key, this.child}) : super(key: key);
  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        var matrixCurrent = context.read<ZoomModel>().matrix;
        var matrix = MatrixGestureDetector.compose(matrixCurrent, tm, sm, rm);
        context.read<ZoomModel>().setMatrix(matrix);
      },
      child: Transform(
        transform: context.watch<ZoomModel>().matrix,
        child: widget.child,
      ),
    );
  }
}

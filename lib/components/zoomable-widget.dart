import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import 'zoomable-widget-model.dart';

class ZoomableWidget extends StatelessWidget {
  final Widget child;

  const ZoomableWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        var matrixCurrent = context.read<ZoomableWidgetModel>().matrix;
        var matrix = MatrixGestureDetector.compose(matrixCurrent, tm, sm, rm);
        context.read<ZoomableWidgetModel>().setMatrix(matrix);
      },
      child: Transform(
        transform: context.watch<ZoomableWidgetModel>().matrix,
        child: child,
      ),
    );
  }
}

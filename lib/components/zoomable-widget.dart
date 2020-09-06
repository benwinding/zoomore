import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class ZoomableWidget extends StatelessWidget {
  final Widget child;
  final Function(Matrix4 m) onChange;
  final Matrix4 matrix;

  const ZoomableWidget({Key key, this.child, this.onChange, this.matrix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        var matrixCurrent = this.matrix;
        var matrix = MatrixGestureDetector.compose(matrixCurrent, tm, sm, rm);
        this.onChange(matrix);
      },
      child: Transform(
        transform: this.matrix,
        child: child,
      ),
    );
  }
}

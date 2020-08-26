import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ZoomModel with ChangeNotifier, DiagnosticableTreeMixin {
  Matrix4 _matrix = Matrix4.identity();

  /// An unmodifiable view of the items in the cart.
  get matrix => this._matrix;

  reset() {
    this._matrix.setIdentity();
    notifyListeners();
  }

  void setMatrix(Matrix4 matrixInput) {
    this._matrix.setFrom(matrixInput);
    notifyListeners();
  }
}

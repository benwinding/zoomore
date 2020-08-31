import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MainModel with ChangeNotifier, DiagnosticableTreeMixin {
  double _slider = 0;
  double get slider => this._slider;

  String get label => this._slider.toStringAsFixed(1);

  void setSlider(double newSlider) {
    this._slider = newSlider;
    notifyListeners();
  }
}

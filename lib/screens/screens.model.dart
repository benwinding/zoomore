import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'screen.abstract.dart';

class ScreensModel with ChangeNotifier, DiagnosticableTreeMixin {
    int _screenIndex = 0;
    List<ZScreen> _screens = [];

    List<Widget> get screenComponents => this._screens.map((s) => s.component).toList();
    int get maxScreenIndex => _screens.length - 1;

    int get currentScreenIndex => this._screenIndex;
    Widget get currentScreenButtons => _screens[this._screenIndex].buttons;

    void initScreens(List<ZScreen> Function() screens) {
      this._screens = screens();
      notifyListeners();
    }
    void gotoScreen(int idx) {
      this._screenIndex = idx;
      print('going to screen = ' + idx.toString());
      notifyListeners();
    }
    void nextScreen() {      
      this.currentScreenIndex < this.maxScreenIndex ? this._screenIndex++ : this._screenIndex = this.maxScreenIndex;
      notifyListeners();
    }
    void prevScreen() {
      this.currentScreenIndex > 0 ? this._screenIndex-- : this._screenIndex = 0;
      notifyListeners();
    }
}
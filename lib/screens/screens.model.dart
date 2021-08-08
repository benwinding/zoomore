import 'package:flutter/material.dart';

import 'screen.abstract.dart';

class ScreensModel with ChangeNotifier {
  int _screenIndex = 0;
  List<ZScreen> _screens = [];

  ScreensModel(List<ZScreen> screens) {
    this._screens = screens;
    notifyListeners();
  }

  List<Widget> get screenComponents =>
      this._screens.map((s) => s.component).toList();
  int get maxScreenIndex => _screens.length - 1;

  int get currentScreenIndex => this._screenIndex;
  Widget get currentScreenButtons => _screens[this._screenIndex].buttons;

  void gotoScreen(int idx) {
    if (idx < 0) {
      this._screenIndex = 0;
    } else if (idx > this.maxScreenIndex) {
      this._screenIndex = this.maxScreenIndex;
    } else {
      this._screenIndex = idx;
    }
    print('going to screen = ' + this._screenIndex.toString());
    notifyListeners();
  }

  void nextScreen() {
    print('going to next screen');
    this.gotoScreen(this._screenIndex + 1);
  }

  void prevScreen() {
    print('going to prev screen');
    this.gotoScreen(this._screenIndex - 1);
  }
}

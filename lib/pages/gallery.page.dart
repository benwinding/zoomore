import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/image-grid/image-grid.dart';
import 'package:zoomore/main/ButtonsBottom.dart';

import 'page.interface.dart';
import 'page.provider.dart';

class GalleryPage implements PageInterface {
  @override
  Widget buttons = GalleryPageButtons();

  @override
  Widget component = ImagesGrid();

  @override
  bool valid;
}

class GalleryPageButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();
    return ButtonsBottom(
        prev: ButtonState(hide: true),
        next: ButtonState(onTap: () {
          s.nextScreen();
        }),
        hintText: 'Select image');
  }
}

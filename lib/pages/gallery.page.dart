import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/image-grid/image-grid-model.dart';
import 'package:zoomore/image-grid/image-grid.dart';
import 'package:zoomore/main/ButtonsBottom.dart';

import 'base/page.interface.dart';
import 'base/page.provider.dart';

class GalleryPage implements PageInterface {
  @override
  Widget buttons = GalleryPageButtons();

  @override
  Widget component = ImagesGrid();

  @override
  bool valid;
}

class GalleryPageButtons extends StatefulWidget {
  @override
  _GalleryPageButtonsState createState() => _GalleryPageButtonsState();
}

class _GalleryPageButtonsState extends State<GalleryPageButtons> {
  bool hasSelectedImage = false;

  @override
  void initState() {
    super.initState();
    GetIt.I.get<ImageGridModel>().addListener(this.onGridChanged);
    this.onGridChanged();
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I.get<ImageGridModel>().removeListener(this.onGridChanged);
  }

  void onGridChanged() {
    setState(() {
      this.hasSelectedImage = GetIt.I.get<ImageGridModel>().hasSelectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();
    // print('rendering');
    return ButtonsBottom(
        prev: ButtonState(hide: true),
        next: ButtonState(
            disabled: !this.hasSelectedImage,
            onTap: () {
              s.nextScreen();
            }),
        hintText: 'Select image');
  }
}

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import './image-grid-model.dart';

class ImagesGrid extends StatefulWidget {
  final Future<void> Function() onTapImage;

  ImagesGrid({this.onTapImage});

  @override
  _ImagesGridState createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  int itemCount = 0;

  _ImagesGridState() {
    GetIt.I.get<ImageGridModel>().addListener(this.onModelChange);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I.get<ImageGridModel>().removeListener(this.onModelChange);
  }  

  void onModelChange() {
    setState(() {
      final m = GetIt.I.get<ImageGridModel>();
      itemCount = m.imageCount;
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
        color: Colors.lightGreen.shade100,
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: itemCount,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(1), child: makeImage(context, index));
          },
        ),
      ),
    );
  }

  makeImage(BuildContext c, int index) {
    return GestureDetector(
      child: Container(
          child: GetIt.I.get<ImageGridModel>().images[index].image,
          color: Colors.black,
          padding: GetIt.I.get<ImageGridModel>().selectedIndex == index
              ? EdgeInsets.all(7)
              : null),
      onTap: () async {
        GetIt.I.get<ImageGridModel>().setIndex(index);
        this.widget.onTapImage();
      },
    );
  }
}

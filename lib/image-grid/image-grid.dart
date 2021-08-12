import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import './image-grid-model.dart';
import 'permission-wrapper.dart';

class ImagesGrid extends StatefulWidget {
  @override
  _ImagesGridState createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  int itemCount = 0;
  int selectedIndex = 0;
  List<ImageSelection> images;
  final perms = new PermissionWrapper();

  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    GetIt.I.get<ImageGridModel>().addListener(this.onModelChange);
    this.onClickGetPhotoAccess(null);
    this.onModelChange();
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I.get<ImageGridModel>().removeListener(this.onModelChange);
  }

  void onModelChange() {
    setState(() {
      final m = GetIt.I.get<ImageGridModel>();
      print('model changed image_count=' + m.images.length.toString());
      itemCount = m.imageCount;
      images = m.images;
      selectedIndex = m.selectedIndex;
    });
  }

  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Center(
          child: ElevatedButton(
          onPressed: () => this.onClickGetPhotoAccess(context),
        child: Text('Access Photos'),
      ));
    }

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
          child: images[index].image,
          color: Colors.black,
          padding: selectedIndex == index ? EdgeInsets.all(7) : null),
      onTap: () async {
        GetIt.I.get<ImageGridModel>().setIndex(index);
      },
    );
  }

  onClickGetPhotoAccess(BuildContext c) async {
    final m = GetIt.I.get<ImageGridModel>();
    final hasPermission = await perms.askPermissions(c);
    this.setState(() {
      this.hasPermission = hasPermission;
    });
    if (hasPermission) {
      await m.loadImageList();
    }
  }
}

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

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

  int _pageOffset = 0;
  int _pageSize = 10;

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
      // print('model changed image_count=' + m.images.length.toString());
      itemCount = m.imageCount;
      images = m.images;
      selectedIndex = m.selectedIndex;
    });
  }

  final _lock = Mutex();
  Future<void> grabNextPage() async {
    await _lock.acquire();
    await GetIt.I.get<ImageGridModel>().fetchImages(_pageOffset, _pageSize);
    _pageOffset += _pageSize;
    _lock.release();
  }

  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Center(
          child: ElevatedButton(
          onPressed: () => this.onClickGetPhotoAccess(context),
        child: Text('Access Photos'),
      ));
    }

    final a = GestureDetector(
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

    final b = NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          if (metrics.pixels == 0) {
            // print('At top');
          } else {
            grabNextFewPages(4);
            // print('At bottom');
          }
        }
        return true;
      },
      child: a,
    );

    return b;
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
    final hasPermission = await perms.askPermissions(c);
    this.setState(() {
      this.hasPermission = hasPermission;
    });
    if (hasPermission) {
      await grabNextFewPages(5);
    }
  }

  grabNextFewPages(int pagesToGrab) async {
    for (var i = 0; i < pagesToGrab; i++) {
      await grabNextPage();
    }
  }  
}

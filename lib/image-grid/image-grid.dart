import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import './image-grid-model.dart';
import 'permission-facade.dart';

class ImagesGrid extends StatefulWidget {
  @override
  _ImagesGridState createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  int itemCount = 0;
  int selectedIndex = 0;
  final perms = new PermissionFacade();

  bool hasPermission = false;

  static const _pageSize = 20;
  final PagingController<int, ImageSelection> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    final m = GetIt.I.get<ImageGridModel>();
    m.addListener(this.onModelChange);
    this.onClickGetPhotoAccess(null);
    this.onModelChange();
    _pagingController.addPageRequestListener((pageKey) {
      _onPageRequest(pageKey, _pageSize);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    GetIt.I.get<ImageGridModel>().removeListener(this.onModelChange);
    super.dispose();
  }

  void _onPageRequest(int pageOffset, int pageSize) async {
    try {
      final newItems =
          await GetIt.I.get<ImageGridModel>().fetchImages(pageOffset, pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageOffset + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void onModelChange() {
    setState(() {
      final m = GetIt.I.get<ImageGridModel>();
      // print('model changed image_count=' + m.images.length.toString());
      itemCount = m.imageCount;
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

    return PagedListView<int, ImageSelection>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<ImageSelection>(
        itemBuilder: (context, item, index) => makeImage(context, item, index),
      ),
    );

    // return GestureDetector(
    //   child: new Container(
    //     color: Colors.lightGreen.shade100,
    //     alignment: Alignment.center,
    //     child: GridView.builder(
    //       itemCount: itemCount,
    //       gridDelegate:
    //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //       itemBuilder: (BuildContext context, int index) {
    //         return Container(
    //             padding: EdgeInsets.all(1), child: makeImage(context, index));
    //       },
    //     ),
    //   ),
    // );
  }

  makeImage(BuildContext c, ImageSelection item, int index) {
    return GestureDetector(
      child: Container(
          child: item.image,
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

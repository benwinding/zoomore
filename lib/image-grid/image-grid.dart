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
  int selectedIndex = 0;
  final perms = new PermissionFacade();

  bool hasPermission = false;

  static const _pageSize = 5;
  PagingController<int, ImageSelection> _pagingController;

  @override
  void initState() {
    print('[initState] imagegrid');
    final m = GetIt.I.get<ImageGridModel>();
    m.addListener(this.onModelChange);
    this.onClickGetPhotoAccess(null);
    this.onModelChange();
    _pagingController = PagingController(firstPageKey: m.getPageOffset());
    _pagingController.itemList = m.getImages();
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
      print('[_onPageRequest] isLastPage=' + isLastPage.toString());
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

    return PagedGridView<int, ImageSelection>(
      pagingController: _pagingController,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      builderDelegate: PagedChildBuilderDelegate<ImageSelection>(
        itemBuilder: (context, item, index) => makeImage(context, item, index),
      ),
    );
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
    final hasPermission = await perms.askPermissions(c);
    this.setState(() {
      this.hasPermission = hasPermission;
    });
    if (hasPermission) {
      this._onPageRequest(0, _pageSize);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

class ImageGridModel with ChangeNotifier {
  List<ImageSelection> _images = [];
  Map<int, List<ImageSelection>> _thumCache = Map();

  Image fullImage;
  int _index = 0;
  int _pageOffset = 0;
  final Function onClickedImageTwice;

  MediaCollection _collection;

  ImageGridModel({@required this.onClickedImageTwice});

  bool get hasSelectedImage => this.selectedImage != null;
  int get selectedIndex => this._index;
  int get imageCount => this._images.length;
  List<ImageSelection> getImages() {
    return [..._images];
  }
  int getPageOffset() {
    return _pageOffset;
  }

  Image get selectedImage {
    if (this.selectedIndex >= this._images.length) {
      return null;
    }
    return this._images[this.selectedIndex].image;
  }

  Future<Image> _fetchCurrentImageFull() async {
    if (this._images.length < 1) {
      return null;
    }
    final mediaCurrent = this._images[this.selectedIndex].rawMedia;
    final file = await mediaCurrent.getFile();
    return Image.file(file);
  }

  void setIndex(int index) {
    if (index == this._index) {
      this.onClickedImageTwice();
    }
    this._index = index;
    this._fetchCurrentImageFull().then((img) {
      this.fullImage = img;
      notifyListeners();
    });
    notifyListeners();
  }

  List<ImageSelection> _fetchAskCache(int pageOffset, int pageSize) {
    if (_thumCache.containsKey(pageOffset)) {
      return _thumCache[pageOffset];
    }
    return null;
  }

  void _updateCache(int pageOffset, List<ImageSelection> newThumbs) {
    _thumCache[pageOffset] = newThumbs;
    this._images.addAll(newThumbs);
  }

  Future<List<ImageSelection>> fetchImages(int pageOffset, int pageSize) async {
    print('fetchImages page=' + pageOffset.toString());
    this._pageOffset = pageOffset;
    final cacheResult = _fetchAskCache(pageOffset, pageSize);
    if (cacheResult != null) {
      return cacheResult;
    }
    if (this._collection == null) {
      final List<MediaCollection> collections = await MediaGallery.listMediaCollections(
        mediaTypes: [MediaType.image, MediaType.video],
      );
      this._collection = collections[0];
    }
    final imageCount = pageSize;
    final imagePage = await this._collection.getMedias(
        mediaType: MediaType.image,
        take: imageCount,
        skip: pageOffset);
    final count = imagePage.items.length;
    print('found ' + count.toString() + ' files');

    Future<ImageSelection> getSingleThumb(Media item) {
      return item.getThumbnail(height: 180, width: 180).then((bytes) {
        final image = Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.maxFinite,
        );
        final imageItem = ImageSelection(image, item);
        return imageItem;
      });
    }
    final res = await Future.wait(imagePage.items.map((i) => getSingleThumb(i)));
    this._updateCache(pageOffset, res);
    return res;
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;
  bool selected;

  ImageSelection(this.image, this.rawMedia);
}

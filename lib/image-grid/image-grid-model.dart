import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

class ImageGridModel with ChangeNotifier {
  int _selectedIndex = 0;
  final _store = new GalleryStore();
  Image _fullImage;

  final Function onClickedImageTwice;
  ImageGridModel({@required this.onClickedImageTwice}) {
    _store.addListener(() => notifyListeners());
  }

  List<ImageSelection> get images => this._store.getImageList();
  bool get hasSelectedImage => this.selectedImage != null;
  int get selectedIndex => this._selectedIndex;
  int get imageCount => this._store.getImageCount();

  Image get selectedImage {
    return _store.getImageThumb(this.selectedIndex);
  }
  Image get selectedFullImage {
    return _fullImage;
  }

  void setIndex(int index) {
    if (index == this._selectedIndex) {
      this.onClickedImageTwice();
    }
    this._selectedIndex = index;
    notifyListeners();
    this._store.getImageFull(index).then((img) {
      this._fullImage = img;
      notifyListeners();
    });
  }

  Future<void> fetchImages(int pageOffset, int pageSize) async {
    final imgs = await this._store.fetchImages(pageOffset, pageSize);    
    notifyListeners();
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;

  ImageSelection(this.image, this.rawMedia);
}

class GalleryStore with ChangeNotifier {
  List<ImageSelection> _images = [];
  bool _hasMoreImages = true;
  MediaCollection _collection;
  Map<String, bool> _imagesLoaded = Map();

  Future<List<ImageSelection>> fetchImages(int pageOffset, int pageSize) async {
    // print('fetchImages pageOffset=' +
    //     pageOffset.toString() +
    //     ', _hasMoreImages=' +
    //     _hasMoreImages.toString());
    if (this._isInCache(pageOffset, pageSize)) {
      return this._fetchFromCache(pageOffset, pageSize);
    }
    if (this._collection == null) {
      final List<MediaCollection> collections =
          await MediaGallery.listMediaCollections(
        mediaTypes: [MediaType.image, MediaType.video],
      );
      this._collection = collections[0];
    }
    final images =
        await fetchFromGallery(this._collection, pageOffset, pageSize);
    images.map((e) => this._imagesLoaded[e.rawMedia.id] = true);
    this._images.addAll(images);
    this._hasMoreImages = this._images.length < pageSize;
    notifyListeners();
    return images;
  }

  getImageCount() {
    return this._images.length;
  }

  getImageList() {
    return this._images;
  }

  Image getImageThumb(int selectedIndex) {
    if (selectedIndex >= this._images.length) {
      return null;
    }
    final mediaCurrent = this._images[selectedIndex].image;
    return mediaCurrent;
  }

  Future<Image> getImageFull(int selectedIndex) async {
    if (selectedIndex >= this._images.length) {
      return null;
    }
    final mediaCurrent = this._images[selectedIndex].rawMedia;
    final file = await mediaCurrent.getFile();
    return Image.file(file);
  }

  bool _isInCache(int pageOffset, int pageSize) {
    final isCached = _images.length >= pageOffset + pageSize;
    return isCached;
  }

  List<ImageSelection> _fetchFromCache(int pageOffset, int pageSize) {
    return this._images.sublist(pageOffset, pageOffset + pageSize);
  }
}

Future<List<ImageSelection>> fetchFromGallery(
    MediaCollection col, int pageOffset, int pageSize) async {
  final imagePage = await col.getMedias(
      mediaType: MediaType.image, take: pageSize, skip: pageOffset);
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

  final res = await Future.wait(imagePage.items.map(getSingleThumb));
  return res;
}

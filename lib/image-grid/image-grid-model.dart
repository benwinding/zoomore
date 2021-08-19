import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

class ImageGridModel with ChangeNotifier {
  List<ImageSelection> _images = [];
  Map<String, bool> _imagesLoaded = Map();

  Image fullImage;
  int _index = 0;
  int _skipCount = 0;
  final Function onClickedImageTwice;

  bool _hasMoreImages = true;
  MediaCollection _collection;

  ImageGridModel({@required this.onClickedImageTwice});

  List<ImageSelection> get images => this._images;

  bool get hasSelectedImage => this.selectedImage != null;
  int get selectedIndex => this._index;
  int get imageCount => this._images.length;

  Image get selectedImage {
    if (this._images.length < 1) {
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

  Future<void> loadImageList() async {
    if (!this._hasMoreImages) {
      return;
    }
    if (this._collection == null) {
      final List<MediaCollection> collections =
          await MediaGallery.listMediaCollections(
        mediaTypes: [MediaType.image, MediaType.video],
      );
      this._collection = collections[0];
    }
    final imageCount = 6;
    final imagePage = await this._collection.getMedias(
        mediaType: MediaType.image,
        take: imageCount + 1,
        skip: this._skipCount);
    this._skipCount += imageCount;
    final count = imagePage.items.length;
    this._hasMoreImages = count > imageCount;
    print('found ' + count.toString() + ' files');
    for (var i = 0; i < count; i++) {
      final item = imagePage.items[i];
      if (this._imagesLoaded.containsKey(item.id)) {
        continue;
      }
      this._imagesLoaded[item.id] = true;
      item.getThumbnail(height: 180, width: 180).then((bytes) {
        final image = Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.maxFinite,
        );
        final imageItem = ImageSelection(image, item);
        _images.add(imageItem);
        notifyListeners();
      });
    }
  }

  Future<List<ImageSelection>> fetchImages(int pageOffset, int pageSize) async {
    if (!this._hasMoreImages) {
      return [];
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
        take: imageCount + 1,
        skip: this._skipCount);
    this._skipCount += imageCount;
    final count = imagePage.items.length;
    this._hasMoreImages = count > imageCount;
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
    return res;
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;
  bool selected;

  ImageSelection(this.image, this.rawMedia);
}

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

class ImageGridModel with ChangeNotifier {
  List<ImageSelection> _images = [];

  int _index = 0;
  final Function onClickedImageTwice;

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

  Future<Image> fetchCurrentImageFull() async {
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
    notifyListeners();
  }

  Future<void> loadImageList() async {
    final List<MediaCollection> collections =
        await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );
    final imagePage = await collections[0].getMedias(
      mediaType: MediaType.image,
      take: 50,
    );
    final count = imagePage.items.length;
    print('found ' + count.toString() + ' files');
    for (var i = 0; i < count; i++) {
      final item = imagePage.items[i];
      item.getThumbnail(height: 180, width: 180).then((bytes) {
        final image = Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.maxFinite,
        );
        final imageItem = ImageSelection(image, item);
        _images.insert(i, imageItem);
        notifyListeners();
      });
    }
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;
  bool selected;

  ImageSelection(this.image, this.rawMedia);
}

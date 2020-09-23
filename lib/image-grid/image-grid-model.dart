import 'package:media_gallery/media_gallery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ImageGridModel with ChangeNotifier, DiagnosticableTreeMixin {
  List<ImageSelection> _images = new List();

  Image _image;
  int _index;

  ImageGridModel() {
    this._loadImageList();
  }

  List<ImageSelection> get images => this._images;
  Image get selectedImage => this._image;
  int get selectedIndex => this._index;

  void setIndex(int index) {
    this._index = index;
    notifyListeners();
  }

  Future<void> _loadImageList() async {
    final List<MediaCollection> collections =
        await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );
    final imagePage = await collections[0].getMedias(
      mediaType: MediaType.image,
      take: 50,
    );
    for (var i = 0; i < imagePage.items.length; i++) {
      final item = imagePage.items[i];
      item.getThumbnail(height: 180, width: 180).then((bytes) {
        final image = Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.maxFinite,
        );
        final imageItem = ImageSelection(image);
        _images.insert(i, imageItem);
      });
    }
  }
}

class ImageSelection {
  final Image image;
  bool selected;

  ImageSelection(this.image);
}

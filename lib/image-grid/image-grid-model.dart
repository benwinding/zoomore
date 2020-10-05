import 'package:media_gallery/media_gallery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGridModel with ChangeNotifier, DiagnosticableTreeMixin {
  List<ImageSelection> _images = new List();

  int _index;

  ImageGridModel() {
    this._loadImageList();
  }

  List<ImageSelection> get images => this._images;
  Image get selectedImage => this._images[this.selectedIndex].image;
  int get selectedIndex => this._index;

  Future<Image> fetchCurrentImageFull() async {
    final mediaCurrent = this._images[this.selectedIndex].rawMedia;
    final file = await mediaCurrent.getFile();
    return Image.file(file);
  }

  void setIndex(int index) {
    this._index = index;
    notifyListeners();
  }

  _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
      Permission.mediaLibrary,
    ].request();

    if (statuses[0].isPermanentlyDenied ||
        statuses[1].isPermanentlyDenied ||
        statuses[2].isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _loadImageList() async {
    await this._checkPermissions();
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

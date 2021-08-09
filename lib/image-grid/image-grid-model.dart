import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGridModel with ChangeNotifier {
  List<ImageSelection> _images = [];

  bool hasPermission = false;
  bool hasPermissionsDenied = false;

  int _index = 0;
  final Function onClickedImageTwice;

  ImageGridModel({@required this.onClickedImageTwice}) {
    this._loadImageList();
  }

  List<ImageSelection> get images => this._images;
  Image get selectedImage {
    if (this._images.length < 1) {
      return null;
    }
    return this._images[this.selectedIndex].image;
  }

  bool get hasSelectedImage => this.selectedImage != null;
  int get selectedIndex => this._index;
  int get imageCount => this._images.length;

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

  _checkPermissions() async {
    final statuses = await Future.wait([
      Permission.storage.isGranted,
      Permission.photos.isGranted,
    ]);

    this.hasPermission = statuses[0] && statuses[1];
    print('fetched permissions... hasPermission=' + hasPermission.toString());
    notifyListeners();

    if (!hasPermission) {
      this._checkIfPermanentlyDenied();
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

  void _checkIfPermanentlyDenied() async {
    print('checking if permanently denied');
    final statuses = await Future.wait([
      Permission.storage.isPermanentlyDenied,
      Permission.photos.isPermanentlyDenied,
    ]);
    this.hasPermissionsDenied = statuses[0] || statuses[1];
    print('permanently denied = ' + this.hasPermissionsDenied.toString());
    notifyListeners();
  }

  void askPermissions() async {
    print('asking permissions');
    this._checkIfPermanentlyDenied();
    if (this.hasPermissionsDenied) {
      return;
    }
    final perms = await Future.wait([
      Permission.storage.request(),
      Permission.photos.request(),
    ]);
    if (perms[0].isDenied) {
      await Permission.storage.shouldShowRequestRationale;
    }
    if (perms[1].isDenied) {
      await Permission.photos.shouldShowRequestRationale;
    }
    await Future.wait([
      Permission.storage.request(),
      Permission.photos.request(),
    ]).then((res) {
      if (res[0].isGranted && res[1].isGranted) {
        return;
      }
      openAppSettings();
    });
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;
  bool selected;

  ImageSelection(this.image, this.rawMedia);
}

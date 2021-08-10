import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGridModel with ChangeNotifier {
  List<ImageSelection> _images = [];

  bool hasPermission = false;
  bool hasPermissionsDenied = false;
  final perms = new Perms();

  int _index = 0;
  final Function onClickedImageTwice;

  ImageGridModel({@required this.onClickedImageTwice}) {
    this._loadImageList();
  }

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

  _checkPermissions() async {
    this.hasPermission = await perms.checkIsGranted();
    print('fetched permissions... hasPermission=' + hasPermission.toString());
    notifyListeners();

    if (!hasPermission) {
      await this._checkIfPermanentlyDenied();
    }
  }

  _checkIfPermanentlyDenied() async {
    this.hasPermissionsDenied = await perms.checkIsPermenantlyDenied();
    notifyListeners();
  }

  askPermissions() async {
    await this.perms.askPermissions();
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

class Perms {
  Future<bool> checkIsPermenantlyDenied() async {
    final perms = await this.requestPermissions();
    final permenantlyDenied =
        perms[0].isPermanentlyDenied || perms[1].isPermanentlyDenied;
    return permenantlyDenied;
  }

  Future<bool> checkIsGranted() async {
    final perms = await this.requestPermissions();
    final isGranted = perms[0].isGranted && perms[1].isGranted;
    return isGranted;
  }

  Future<List<PermissionStatus>> requestPermissions() async {
    return Future.wait([
      Permission.storage.request(),
      Permission.photos.request(),
    ]);
  }

  askPermissions() async {
    print('asking permissions');
    final perms = await this.requestPermissions();
    if (perms[0].isDenied) {
      await Permission.storage.shouldShowRequestRationale;
    }
    if (perms[1].isDenied) {
      await Permission.photos.shouldShowRequestRationale;
    }
    final permsAfter = await this.requestPermissions();
    final isBothGranted = permsAfter[0].isGranted && permsAfter[1].isGranted;
    if (isBothGranted) {
      openAppSettings();
    }
  }
}

class ImageSelection {
  final Image image;
  final Media rawMedia;
  bool selected;

  ImageSelection(this.image, this.rawMedia);
}

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

class ImagesGrid extends StatefulWidget {
  final OnTapImage onTapImage;

  const ImagesGrid({Key key, this.onTapImage}) : super(key: key);

  @override
  _ImagesGridState createState() => _ImagesGridState(this.onTapImage);
}

typedef OnTapImage = void Function(Image b);

class _ImagesGridState extends State<ImagesGrid> {
  MediaPage _imagePage;
  final OnTapImage onTapImage;

  _ImagesGridState(this.onTapImage);

  @override
  void initState() {
    super.initState();
    loadImageList();
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
    setState(() {
      this._imagePage = imagePage;
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        child: GridView.builder(
            itemCount: 50,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.all(1),
                  child: FutureBuilder(
                    future: this.getThumbIndex(index),
                    builder: (context, snapshot) {
                      final Image data = snapshot.data;
                      return GestureDetector(
                        child: data,
                        onTap: () => this.onTapImage(data),
                      );
                    },
                  ));
            }),
      ),
    );
  }

  Future<Image> getThumbIndex(int index) async {
    if (this._imagePage == null || this._imagePage.items.length - 1 < index) {
      return null;
    }
    return this
        ._imagePage
        .items[index]
        .getThumbnail(height: 180, width: 180)
        .then((bytes) async {
      final bytesRotated = await bytes2Image(bytes);
      final imgFile = Image.memory(
        bytesRotated,
        fit: BoxFit.cover,
        width: double.maxFinite,
      );
      return imgFile;
    });
  }
}

Future<List<int>> bytes2Image(List<int> imageBytes) async {
  return imageBytes;
  // final originalImage = img.decodeImage(imageBytes);
  // if (!originalImage.exif.hasOrientation) {
  //   return img.encodeJpg(originalImage);
  // }
  // return img.encodeJpg(originalImage);
  // final exifData = await readExifFromBytes(imageBytes);
  // img.Image fixedImage;
  // if (exifData['Image Orientation'].printable.contains('Horizontal')) {
  //   fixedImage = img.copyRotate(originalImage, 90);
  // } else if (exifData['Image Orientation'].printable.contains('180')) {
  //   fixedImage = img.copyRotate(originalImage, -90);
  // } else if (exifData['Image Orientation'].printable.contains('CCW')) {
  //   fixedImage = img.copyRotate(originalImage, 180);
  // } else {
  //   fixedImage = img.copyRotate(originalImage, 0);
  // }
  // final bytesEncoded = img.encodeJpg(fixedImage);
  // return bytesEncoded;
}

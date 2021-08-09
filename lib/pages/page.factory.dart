import 'package:zoomore/pages/page.interface.dart';

import 'share.page.dart';
import 'gallery.page.dart';
import 'zoom.page.dart';

List<PageInterface> makePages() {
  final List<PageInterface> screens = [GalleryPage(), ZoomPage(), SharePage()];
  return screens;
}
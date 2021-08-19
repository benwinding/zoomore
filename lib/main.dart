import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/zoom-player/zoom-player.model.dart';

import 'export/export.provider.dart';
import 'zoom-player/zoom-recorder.model.dart';
import 'zoom-player/zoom.store.dart';
import 'image-grid/image-grid-model.dart';
import 'main/ComposedScreen.dart';
import 'pages/allpage.factory.dart';
import 'pages/base/page.provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final screens = makePages();
  final zoomStore = new ZoomStore();

  void onClickedImageTwice() {
    GetIt.I.get<PagesProvider>().gotoScreen(1);
    final m = GetIt.I.get<ZoomRecorderModel>();
    m.playerStopGotoStart();
    m.resetMatrix();
    final m2 = GetIt.I.get<ZoomPlayerModel>();
    m2.playerStopGotoStart();
    m2.resetMatrix();
    zoomStore.clearFrames();
  }

  GetIt.I.registerSingleton(new PagesProvider(screens));
  GetIt.I.registerSingleton(new ImageGridModel(onClickedImageTwice: onClickedImageTwice));
  GetIt.I.registerSingleton(zoomStore);
  GetIt.I.registerSingleton(new ZoomRecorderModel(zoomStore));
  GetIt.I.registerSingleton(new ZoomPlayerModel(zoomStore));
  GetIt.I.registerSingleton(new ExportProvider(zoomStore));

  GetIt.I.get<ImageGridModel>().addListener(() {
    final m = GetIt.I.get<ImageGridModel>();
    zoomStore.setImage(m.selectedImage);
    zoomStore.setImageFull(m.selectedFullImage);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Container(
            padding: EdgeInsets.all(0),
            color: Colors.blueGrey,
            child: ComposedScreen()));
  }
}

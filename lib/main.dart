import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/zoom-player/export.provider.dart';

import 'zoom-player/zoom-player.model.dart';
import 'image-grid/image-grid-model.dart';
import 'main/ComposedScreen.dart';
import 'pages/page.factory.dart';
import 'pages/page.provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final screens = makePages();

  void onClickedImageTwice() {
    GetIt.I.get<PagesProvider>().gotoScreen(1);
    final m = GetIt.I.get<ZoomPlayerModel>();
    m.playerStopGotoStart();
    m.resetMatrix();
    m.resetFrames();
  }

  GetIt.I.registerSingleton(new PagesProvider(screens));
  GetIt.I.registerSingleton(new ImageGridModel(onClickedImageTwice: onClickedImageTwice));
  final zoomModel = new ZoomPlayerModel();
  GetIt.I.registerSingleton(zoomModel);
  GetIt.I.registerSingleton(new ExportProvider(zoomModel));

  GetIt.I.get<ImageGridModel>().addListener(() {
    final image = GetIt.I.get<ImageGridModel>().selectedImage;
    GetIt.I.get<ZoomPlayerModel>().setImage(image);
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

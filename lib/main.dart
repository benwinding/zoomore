import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/screens/screens.dart';
import 'package:zoomore/screens/screens.model.dart';

import './zoom-player/zoom-player.model.dart';
import './image-grid/image-grid-model.dart';

import './main/ComposedScreen.dart';
import './screens/screens.dart';
import 'package:get_it/get_it.dart';

void main() {
  final screens = [ImageScreen(), ZoomScreen(), EmptyColorScreen()];
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton(new ScreensModel(screens));
  GetIt.I.registerSingleton(new ImageGridModel());
  // GetIt.I.registerSingleton(new ZoomPlayerModel());
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => ImageGridModel()),
        ChangeNotifierProvider(create: (_) => ZoomPlayerModel()),
        // ChangeNotifierProvider(create: (_) => ScreensModel()),
      ],
      child: MyApp(),
    ),
  );
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
            padding: EdgeInsets.all(5.0),
            color: Colors.blueGrey,
            child: ComposedScreen()));
  }
}

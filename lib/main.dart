import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/pages/home.dart';
import 'package:zoomore/zoom-player.model.dart';
import 'image-grid/image-grid-model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageGridModel()),
        ChangeNotifierProvider(create: (_) => ZoomPlayerModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

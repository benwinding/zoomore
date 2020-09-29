import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/zoom-player.model.dart';
import 'image-grid/image-grid-model.dart';
import 'image-grid/image-grid.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoomore'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              color: Colors.blueGrey,
              height: 150,
              child: context.watch<ImageGridModel>().selectedIndex != null
                  ? Wrap(
                      children: [context.watch<ImageGridModel>().selectedImage],
                    )
                  : Center(
                      child: Text(
                        'Select an image',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
          Expanded(
            child: ImagesGrid(),
          ),
        ],
      ),
    );
  }
}

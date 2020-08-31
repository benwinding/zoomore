import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main-model.dart';
import 'zoom-container.dart';
import 'components/zoomable-widget-model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ZoomableWidgetModel()),
        ChangeNotifierProvider(create: (_) => MainModel()),
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(children: [
              ZoomContainer(),
              Slider(
                value: context.watch<MainModel>().slider,
                label: context.watch<MainModel>().label,
                min: -1,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  context.read<MainModel>().setSlider(value);
                  print(context.read<MainModel>().slider);
                },
              )
            ])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ZoomableWidgetModel>().reset(),
        tooltip: 'Reset',
        child: Icon(Icons.restore_page),
      ),
    );
  }
}

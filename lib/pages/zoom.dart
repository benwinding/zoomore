import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../zoom-player.dart';

class MyZoomPage extends StatelessWidget {
  const MyZoomPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoomore'),
      ),
      body: ZoomPlayer(),
    );
  }
}

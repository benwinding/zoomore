import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/pages/page.provider.dart';
import 'package:zoomore/zoom-player/read-only-plater.dart';
import 'page.interface.dart';

class SharePage implements PageInterface {
  @override
  Widget buttons = BlankButtons();

  @override
  Widget component = SharePageComponent();

  @override
  bool valid;
}

class BlankButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();
    return ButtonsBottom(
      prev: ButtonState(onTap: () {
        s.prevScreen();
      }),
      next: ButtonState(onTap: () {
        s.nextScreen();
      }),
      hintText: 'Share!',
    );
  }
}

class SharePageComponent extends StatefulWidget {
  @override
  _SharePageComponentState createState() => _SharePageComponentState();
}

class _SharePageComponentState extends State<SharePageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.shade200,
        child: Center(
          child: ZoomPlayerReadOnly(height: 400),
        ));
  }
}

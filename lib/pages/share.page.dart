import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:zoomore/export/export.provider.dart';
import 'package:zoomore/main/ButtonsBottom.dart';
import 'package:zoomore/zoom-player/zoom-player.dart';
import 'package:zoomore/zoom-player/zoom-player.model.dart';
import 'base/page.provider.dart';
import 'base/page.interface.dart';

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
        s.gotoScreen(1);
      }),
      next: ButtonState(
        icon: Icons.share,
        onTap: () {
          final globalKey = GetIt.I.get<ZoomPlayerModel>().getZoomGlobalKey();
          RenderRepaintBoundary paintB = globalKey.currentContext.findRenderObject();
          GetIt.I.get<ExportProvider>().playerSave(paintB);
        }
      ),
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
          child: ZoomPlayer(),
        ));
  }
}

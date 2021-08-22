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
  Widget buttons = ShareButtons();

  @override
  Widget component = SharePageComponent();

  @override
  bool valid;
}

// This is the type used by the popup menu below.
enum SharePageEnum { saveVideo, shareVideo }

class ShareButtonOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PopupMenuItem<SharePageEnum> makeItem({SharePageEnum value, IconData icon, String text}) {
        return PopupMenuItem<SharePageEnum>(
          value: value,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            Text(text)
          ]),
        );
    }


    return PopupMenuButton<SharePageEnum>(
      child: Icon(Icons.share),
      onSelected: (SharePageEnum result) async {
        final globalKey = GetIt.I.get<ZoomPlayerModel>().getZoomGlobalKey();
        RenderRepaintBoundary paintB =
            globalKey.currentContext.findRenderObject();

        switch (result) {
          case SharePageEnum.saveVideo:
            await GetIt.I.get<ExportProvider>().playerSave(paintB);
            break;
          case SharePageEnum.shareVideo:
          default:
            await GetIt.I.get<ExportProvider>().playerShare(paintB);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SharePageEnum>>[
        makeItem(value: SharePageEnum.saveVideo, icon: Icons.download, text: 'Export Video'),
        makeItem(value: SharePageEnum.shareVideo, icon: Icons.share, text: 'Share Video'),
      ],
    );
  }
}

class ShareButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = GetIt.I.get<PagesProvider>();
    return ButtonsBottom(
      prev: ButtonState(onTap: () {
        s.gotoScreen(1);
      }),
      next: ButtonState(child: ShareButtonOptions(), onTap: () {}),
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

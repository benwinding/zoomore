import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomore/pages/zoom.dart';
import 'package:zoomore/zoom-player.model.dart';
import '../image-grid/image-grid-model.dart';
import '../image-grid/image-grid.dart';

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
        children: [
          Container(
              color: Colors.blueGrey,
              height: 150,
              child: context.watch<ImageGridModel>().selectedIndex != null
                  ? Stack(
                      children: [
                        Wrap(
                          children: [
                            context.watch<ImageGridModel>().selectedImage
                          ],
                        ),
                        Center(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            onPressed: () async {
                              // Add your onPressed code here!
                              final image =
                                  await context.read<ImageGridModel>().fetchCurrentImageFull();
                              context.read<ZoomPlayerModel>().setImage(image);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyZoomPage()));
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Confirm'),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                            color: Colors.green,
                          ),
                        )
                      ],
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

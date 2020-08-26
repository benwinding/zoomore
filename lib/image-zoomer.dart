// import 'dart:io';

import 'package:flutter/material.dart';
import 'zoomable-widget.dart';

class ImageZoomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZoomableWidget(
      child: Container(
        width: 400,
        height: 740,
        color: Color.fromRGBO(
          0,
          0,
          0,
          1,
        ),
        child: Image.asset('assets/large-image.jpg'),
      ),
    );
  }
}

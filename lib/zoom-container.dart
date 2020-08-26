import 'package:flutter/material.dart';
import 'components/zoomable-widget.dart';

class ZoomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZoomableWidget(
      key: Key('widgy'),
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

import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class TransitionContainer extends StatefulWidget {
  final int index;
  final int durationMs;
  final List<Widget> children;
  final Curve curveIn;
  final Curve curveOut;

  TransitionContainer({
    Key key,
    @required this.index,
    @required this.children,
    @required this.curveIn,
    @required this.curveOut,
    @required this.durationMs
  }) : super(key: key) {
    // print('TransitionContainer() ' + this.index.toString() + ' maxCount:' + this.children.length.toString());
  }

  @override
  _TransitionContainerState createState() => _TransitionContainerState();
}

/// This is the private State class that goes with TransitionContainer.
class _TransitionContainerState extends State<TransitionContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation0;
  Animation<Offset> _offsetAnimation1;

  Widget p0;
  Widget p1;

  @override
  void didUpdateWidget(TransitionContainer oldWidget) {
    bool hasChanged = oldWidget.index != widget.index;
    // print('didUpdate oldIndex=' +
    //     oldWidget.index.toString() +
    //     ', newIndex=' +
    //     widget.index.toString() +
    //     '');
    if (hasChanged) {
      bool movingForward = widget.index > oldWidget.index;

      if (movingForward) {
        this.setWidgets(oldWidget.index, widget.index);
        _controller.value = _controller.lowerBound;
        _controller.forward();
        _setBounceForward();
      } else {
        this.setWidgets(widget.index, oldWidget.index);
        _setBounceBackward();
        _controller.value = _controller.upperBound;
        _controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setBounceForward() {
    _offsetAnimation0 = Tween<Offset>(
      begin: Offset(0, 0.0),
      end: Offset(-1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curveOut,
    ));
    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(1, 0.0),
      end: Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curveOut,
    ));
  }

  void _setBounceBackward() {
    _offsetAnimation0 = Tween<Offset>(
      begin: Offset(0, 0.0),
      end: Offset(-1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curveIn,
    ));
    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(1, 0.0),
      end: Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curveIn,
    ));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.durationMs),
      vsync: this,
    );
    this.setWidgets(this.widget.index, this.widget.index + 1);
    this._setBounceForward();
  }

  setWidgets(int index0, int index1) {
    this.p0 = this.widget.children[index0];
    this.p1 = this.widget.children[index1];
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SlideTransition(
        position: _offsetAnimation0,
        child: p0,
      ),
      SlideTransition(
        position: _offsetAnimation1,
        child: p1,
      ),
    ]);
  }
}

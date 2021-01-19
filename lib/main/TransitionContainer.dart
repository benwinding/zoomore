import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class TransitionContainer extends StatefulWidget {
  final int index;
  final List<Widget> children;

  TransitionContainer({
    Key key,
    @required this.index,
    @required this.children,
  }) : super(key: key) {
    print('TransitionContainer() ' + this.index.toString());
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
    print('didUpdate oldIndex=' +
        oldWidget.index.toString() +
        ', newIndex=' +
        widget.index.toString() +
        // ', movingForward=' +
        // movingForward.toString()
        '');
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
      curve: Curves.bounceOut,
    ));
    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(1, 0.0),
      end: Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
  }

  void _setBounceBackward() {
    _offsetAnimation0 = Tween<Offset>(
      begin: Offset(0, 0.0),
      end: Offset(-1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    ));
    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(1, 0.0),
      end: Offset(0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    ));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
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

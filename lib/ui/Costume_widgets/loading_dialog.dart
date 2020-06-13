import 'package:flutter/material.dart';


///this is normal [circular progres indicator] instde continer 
///that made looks like dialog
class LoadingDialog extends StatelessWidget {
  const LoadingDialog();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: CircularProgressIndicator(backgroundColor: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Loading..'),
            ),
          ],
        ),
      ),
    );
  }
}


///if [inAsyncCall] is true then it will overlay a circular progres indicator
///or the on you choose on top of the widget
class ModalProgress extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget costumeIndicator;
  final Offset offset;
  final bool dismissible;
  final Widget child;

  ModalProgress({
    Key key,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.costumeIndicator,
    this.offset,
    this.dismissible = false,
    @required this.child,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator =
          Center(child: costumeIndicator ?? const CircularProgressIndicator());
    } else {
      layOutProgressIndicator = Positioned(
        child: costumeIndicator ?? const CircularProgressIndicator(),
        left: offset.dx,
        top: offset.dy,
      );
    }

    return Stack(
      children: [
        child,
        Opacity(
          child: ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator,
      ],
    );
  }
}

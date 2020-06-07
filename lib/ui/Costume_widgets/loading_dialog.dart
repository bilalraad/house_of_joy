import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(backgroundColor: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Loading..'),
            ),
          ],
        ),
      ),
    );
  }
}

// showAlertDialog(BuildContext context) {
//   AlertDialog alert = AlertDialog(
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(50),
//         side: BorderSide(color: Colors.transparent)),
//     elevation: 0,
//     contentPadding: EdgeInsets.all(0),
//     backgroundColor: Colors.white.withOpacity(1),
//     content: LoadingDialog(),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(15),
//         child: alert,
//       );
//     },
//   );
// }

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
    if (offset == null)
      layOutProgressIndicator =
          Center(child: costumeIndicator ?? CircularProgressIndicator());
    else {
      layOutProgressIndicator = Positioned(
        child: costumeIndicator ?? CircularProgressIndicator(),
        left: offset.dx,
        top: offset.dy,
      );
    }

    return new Stack(
      children: [
        child,
        new Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator,
      ],
    );
  }
}

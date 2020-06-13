import 'dart:async';

import 'package:flutter/material.dart';


///you can used it to show error or messege as small popup messege on the bottom
Future<void> showOverlay({
  @required BuildContext context,
  @required String text,
}) async {
  final overlayState = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50.0,
      right: MediaQuery.of(context).size.width * 0.25,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Material(
        color: Colors.white.withOpacity(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.withOpacity(0.6),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  await Future.delayed(const Duration(seconds: 2));

  overlayEntry.remove();
}

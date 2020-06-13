import 'package:flutter/material.dart';

///this function will make special transition animation
///if you want to chamge the effect then set the [curve] to watever u want
Route createRoute(Widget route, {Cubic curve = Curves.ease}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = const Offset(0.0, 1.0);
      final end = Offset.zero;
      final curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

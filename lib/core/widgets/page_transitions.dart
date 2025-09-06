import 'package:flutter/material.dart';

class PageTransitions {
  static Route<T> fadeTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<T> slideUpTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Route<T> bottomNavTransition<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 250),
    bool slideFromRight = true,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = slideFromRight
            ? const Offset(0.3, 0.0)
            : const Offset(-0.3, 0.0);
        const end = Offset.zero;

        const slideCurve = Curves.easeOutCubic;
        const fadeCurve = Curves.easeInOut;

        var slideAnimation = animation.drive(
          Tween(begin: begin, end: end).chain(CurveTween(curve: slideCurve)),
        );

        var fadeAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: fadeCurve)),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }
}

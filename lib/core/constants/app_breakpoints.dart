import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1440;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;

  static int getGridCrossAxisCount(double width) {
    if (width < 400) return 1;
    if (width < mobile) return 2;
    if (width < tablet) return 3;
    if (width < desktop) return 4;
    return 5;
  }

  static double getCardAspectRatio(double width) {
    if (width < mobile) return 0.7;
    if (width < tablet) return 0.65;
    return 0.6;
  }

  static EdgeInsets getScreenPadding(double width) {
    if (width < mobile) return const EdgeInsets.all(16);
    if (width < tablet) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }
}

import 'package:flutter/material.dart';
import 'package:serasa_challenge/core/constants/app_breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  T getValue(double width) {
    if (AppBreakpoints.isDesktop(width) && desktop != null) {
      return desktop!;
    }
    if (AppBreakpoints.isTablet(width) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ResponsiveWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints) {
        final responsivePadding =
            padding ?? AppBreakpoints.getScreenPadding(constraints.maxWidth);

        return SafeArea(
          child: Padding(padding: responsivePadding, child: child),
        );
      },
    );
  }
}

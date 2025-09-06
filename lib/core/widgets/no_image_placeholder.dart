import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_images.dart';

class NoImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;

  const NoImagePlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.iconSize = 32,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImages.noImageIcon,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            iconColor ?? Theme.of(context).primaryColor.withValues(alpha: 0.5),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

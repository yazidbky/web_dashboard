import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';

Widget buildIcon(
  String iconAsset,
  double height,
  double width, {
  Color? color,
  BoxFit? fit,
  double? scale,
}) {
  if (iconAsset.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(
      iconAsset,
      width: SizeConfig.scaleWidth(width),
      height: SizeConfig.scaleWidth(height),
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      fit: fit ?? BoxFit.contain,
    );
  } else {
    return Image.asset(
      iconAsset,
      scale: scale,
      width: SizeConfig.scaleWidth(width),
      height: SizeConfig.scaleWidth(height),
      color: color,
    );
  }
}
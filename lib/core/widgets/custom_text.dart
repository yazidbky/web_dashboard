import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final List<Shadow>? shadows;
  final bool? softWrap;
  final TextOverflow? textOverflow;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Locale? locale;
  final TextScaler? textScaler;

  // Automatic responsive scaling
  final bool autoResponsive;
  final double? responsiveMultiplier;
  final double? minFontSize;
  final double? maxFontSize;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.shadows,
    this.softWrap,
    this.textOverflow,
    this.style,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.locale,
    this.textScaler,
    // Automatic responsive properties
    this.autoResponsive = true,
    this.responsiveMultiplier,
    this.minFontSize,
    this.maxFontSize,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Get automatic responsive values
    final finalFontSize = _getAutomaticFontSize();
    final finalFontWeight = _getAutomaticFontWeight();
    final finalHeight = _getAutomaticHeight();
    final finalLetterSpacing = _getAutomaticLetterSpacing();

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: textOverflow ?? overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      locale: locale,
      textScaler: textScaler,
      style: style ??
          _buildTextStyle(
            finalFontSize: finalFontSize,
            finalFontWeight: finalFontWeight,
            finalHeight: finalHeight,
            finalLetterSpacing: finalLetterSpacing,
            context: context,
          ),
    );
  }

  TextStyle _buildTextStyle({
    required double finalFontSize,
    required FontWeight finalFontWeight,
    required double? finalHeight,
    required double? finalLetterSpacing,
    required BuildContext context,
  }) {
    // Try to use GoogleFonts, but catch any errors and fallback to default style
    try {
      return GoogleFonts.poppins(
        fontSize: finalFontSize,
        fontWeight: finalFontWeight,
        height: finalHeight,
        letterSpacing: finalLetterSpacing,
        wordSpacing: wordSpacing,
        color: color ?? AppColors.primary,
      ).copyWith(
        decoration: decoration,
        textBaseline: textBaseline,
        shadows: shadows,
        overflow: TextOverflow.visible,
      );
    } catch (e) {
      // Fallback to default text style if GoogleFonts fails (offline, etc.)
      return Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color ?? AppColors.primary,
            fontSize: finalFontSize,
            fontWeight: finalFontWeight,
            height: finalHeight,
            decoration: decoration,
            letterSpacing: finalLetterSpacing,
            wordSpacing: wordSpacing,
            textBaseline: textBaseline,
            shadows: shadows,
            overflow: TextOverflow.visible,
            fontFamily: 'Poppins', // Still try Poppins if available locally
          ) ??
          TextStyle(
            color: color ?? AppColors.primary,
            fontSize: finalFontSize,
            fontWeight: finalFontWeight,
            height: finalHeight,
            decoration: decoration,
            letterSpacing: finalLetterSpacing,
            wordSpacing: wordSpacing,
            textBaseline: textBaseline,
            shadows: shadows,
            overflow: TextOverflow.visible,
            fontFamily: 'Poppins',
          );
    }
  }

  double _getAutomaticFontSize() {
    if (!autoResponsive) {
      return SizeConfig.scaleText(fontSize ?? 14);
    }

    // Base font size with automatic responsive scaling
    double baseFontSize = fontSize ?? 14;

    // Apply automatic responsive scaling based on device type
    double responsiveFontSize = SizeConfig.getResponsiveFontSize(
      mobile: baseFontSize,
      tablet: baseFontSize * (responsiveMultiplier ?? 1.1),
      desktop: baseFontSize * (responsiveMultiplier ?? 1.2),
    );

    // Apply additional scaling for better readability
    responsiveFontSize = SizeConfig.scaleText(responsiveFontSize);

    // Apply min/max constraints if provided
    if (minFontSize != null && responsiveFontSize < minFontSize!) {
      responsiveFontSize = minFontSize!;
    }
    if (maxFontSize != null && responsiveFontSize > maxFontSize!) {
      responsiveFontSize = maxFontSize!;
    }

    return responsiveFontSize;
  }

  FontWeight _getAutomaticFontWeight() {
    if (!autoResponsive) {
      return fontWeight ?? FontWeight.w400;
    }

    // Automatic font weight based on device type
    return SizeConfig.responsive(
      mobile: fontWeight ?? FontWeight.w400,
      tablet: fontWeight ?? FontWeight.w500,
      desktop: fontWeight ?? FontWeight.w600,
    );
  }

  double? _getAutomaticHeight() {
    if (!autoResponsive) {
      return height;
    }

    // Automatic line height based on device type
    if (height != null) {
      return SizeConfig.responsive(
        mobile: height!,
        tablet: height! * 1.05,
        desktop: height! * 1.1,
      );
    }

    // Default responsive line heights
    return SizeConfig.responsive(mobile: 1.2, tablet: 1.3, desktop: 1.4);
  }

  double? _getAutomaticLetterSpacing() {
    if (!autoResponsive) {
      return letterSpacing;
    }

    // Automatic letter spacing based on device type
    if (letterSpacing != null) {
      return SizeConfig.responsive(
        mobile: letterSpacing!,
        tablet: letterSpacing! * 1.1,
        desktop: letterSpacing! * 1.2,
      );
    }

    // Default responsive letter spacing
    return SizeConfig.responsive(mobile: 0.0, tablet: 0.2, desktop: 0.4);
  }
}
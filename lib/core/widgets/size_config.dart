import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Responsive SizeConfig for Flutter apps.
/// - Percentage-based helpers (width/height/min/max)
/// - Safe text scaling with bounds
/// - SafePlatform detection without importing dart:io (works on web)
/// - Breakpoint utilities (mobile/tablet/desktop)
///
/// Usage:
/// 1. Call `SizeConfig.init(context);` early (e.g. in MaterialApp.builder)
/// 2. Use helpers like `SizeConfig.scaleWidth(50)`, `SizeConfig.scaleText(16)`
/// 3. Re-call `SizeConfig.init(context)` if you depend on orientation changes
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0; // 1% width
  static double blockHeight = 0; // 1% height
  static double _textScaleFactor = 1.0;
  static bool _initialized = false;

  // Breakpoints (customizable)
  static const double _mobileBreakpoint = 600.0;
  static const double _tabletBreakpoint = 1024.0;
  static const double _desktopBreakpoint = 1440.0;

  // Text-scaling limits
  static const double _maxTextScaleFactor = 1.5;
  static const double _defaultTextScaleCap = 1.2;

  /// Initialize or re-initialize SizeConfig with current BuildContext.
  /// Safe to call on every build if needed (cheap operations only).
  static void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    _mediaQueryData = mq;

    screenWidth = mq.size.width;
    screenHeight = mq.size.height;
    blockWidth = screenWidth / 100.0;
    blockHeight = screenHeight / 100.0;
    _textScaleFactor = mq.textScaleFactor.clamp(0.8, _maxTextScaleFactor);

    _initialized = true;
  }

  static void _ensureInitialized() {
    if (!_initialized || _mediaQueryData == null) {
      throw Exception(
        'SizeConfig is not initialized. Call SizeConfig.init(context) before using it.');
    }
  }

  /// Percentage of screen width (0-100)
  static double scaleWidth(double percentWidth) {
    _ensureInitialized();
    return screenWidth * (percentWidth / 100.0);
  }

  /// Percentage of screen height (0-100)
  static double scaleHeight(double percentHeight) {
    _ensureInitialized();
    return screenHeight * (percentHeight / 100.0);
  }

  /// Percentage of the smallest screen side (orientation-independent)
  static double scaleMin(double percent) {
    _ensureInitialized();
    final minDimension = math.min(screenWidth, screenHeight);
    return minDimension * (percent / 100.0);
  }

  /// Percentage of the largest screen side (orientation-independent)
  static double scaleMax(double percent) {
    _ensureInitialized();
    final maxDimension = math.max(screenWidth, screenHeight);
    return maxDimension * (percent / 100.0);
  }

  /// Scale text size with accessibility consideration and caps to avoid extreme sizes.
  /// Input: base font size in logical pixels (e.g. 14, 16, 20)
  static double scaleText(double fontSize, {double? cap}) {
    _ensureInitialized();
    final effectiveCap = cap ?? _defaultTextScaleCap;
    final finalScale = math.min(_textScaleFactor, effectiveCap);
    return fontSize * finalScale;
  }

  /// Conservative text scaling (safer for body texts)
  static double scaleTextConservative(double fontSize) {
    return scaleText(fontSize, cap: 1.15);
  }

  /// Text scaling with custom bounds (minScale and maxScale are applied to device textScaleFactor)
  static double scaleTextWithBounds(double fontSize, {double minScale = 0.9, double maxScale = _maxTextScaleFactor}) {
    _ensureInitialized();
    final bounded = math.min(math.max(_textScaleFactor, minScale), maxScale);
    return fontSize * bounded;
  }

  /// Responsive value based on breakpoints.
  /// - mobile: < _tabletBreakpoint
  /// - tablet: >= _tabletBreakpoint and < _desktopBreakpoint
  /// - desktop: >= _desktopBreakpoint
  static T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    _ensureInitialized();
    if (screenWidth >= _desktopBreakpoint && desktop != null) return desktop;
    if (screenWidth >= _tabletBreakpoint && tablet != null) return tablet;
    return mobile;
  }

  /// Advanced responsive with largeDesktop
  static T responsiveAdvanced<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
    double largeDesktopBreakpoint = 1600.0,
  }) {
    _ensureInitialized();
    if (screenWidth >= largeDesktopBreakpoint && largeDesktop != null) return largeDesktop;
    if (screenWidth >= _desktopBreakpoint && desktop != null) return desktop;
    if (screenWidth >= _tabletBreakpoint && tablet != null) return tablet;
    return mobile;
  }

  static bool get isLandscape {
    _ensureInitialized();
    return screenWidth > screenHeight;
  }

  static bool get isPortrait {
    _ensureInitialized();
    return screenHeight >= screenWidth;
  }

  static EdgeInsets get safeAreaInsets {
    _ensureInitialized();
    return _mediaQueryData!.padding;
  }

  static EdgeInsets get viewInsets {
    _ensureInitialized();
    return _mediaQueryData!.viewInsets;
  }

  static double get safeAreaTop {
    _ensureInitialized();
    return _mediaQueryData!.padding.top;
  }

  static double get safeAreaBottom {
    _ensureInitialized();
    return _mediaQueryData!.padding.bottom;
  }

  static double get keyboardHeight {
    _ensureInitialized();
    return viewInsets.bottom;
  }

  static bool get isKeyboardVisible {
    _ensureInitialized();
    return keyboardHeight > 0;
  }

  /// Device type checks without dart:io
  static bool get isWeb => kIsWeb;

  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isMobile {
    _ensureInitialized();
    return screenWidth < _mobileBreakpoint;
  }

  static bool get isTablet {
    _ensureInitialized();
    return screenWidth >= _mobileBreakpoint && screenWidth < _tabletBreakpoint;
  }

  static bool get isDesktop {
    _ensureInitialized();
    return screenWidth >= _tabletBreakpoint;
  }

  /// Safe available dimensions excluding keyboard and safe areas
  static double get availableHeight {
    _ensureInitialized();
    return screenHeight - keyboardHeight;
  }

  static double get availableWidth {
    _ensureInitialized();
    final padding = safeAreaInsets;
    return screenWidth - padding.left - padding.right;
  }

  static double get availableHeightWithSafeArea {
    _ensureInitialized();
    final p = safeAreaInsets;
    return screenHeight - p.top - p.bottom - keyboardHeight;
  }

  /// Padding helpers. Use small percentage values for padding to avoid very large paddings.
  /// Example: horizontalPadding(2) => 2% of screen width
  static EdgeInsets scalePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    _ensureInitialized();
    return EdgeInsets.only(
      top: scaleHeight(top ?? vertical ?? all ?? 0),
      right: scaleWidth(right ?? horizontal ?? all ?? 0),
      bottom: scaleHeight(bottom ?? vertical ?? all ?? 0),
      left: scaleWidth(left ?? horizontal ?? all ?? 0),
    );
  }

  static EdgeInsets horizontalPadding(double percent) {
    _ensureInitialized();
    return EdgeInsets.symmetric(horizontal: scaleWidth(percent));
  }

  static EdgeInsets verticalPadding(double percent) {
    _ensureInitialized();
    return EdgeInsets.symmetric(vertical: scaleHeight(percent));
  }

  static EdgeInsets symmetricPadding({required double horizontal, required double vertical}) {
    _ensureInitialized();
    return EdgeInsets.symmetric(horizontal: scaleWidth(horizontal), vertical: scaleHeight(vertical));
  }

  static EdgeInsets allPadding(double percent) {
    _ensureInitialized();
    return EdgeInsets.all(scaleMin(percent));
  }

  /// Minimum touch target (>= 44 logical pixels)
  static double get minTouchTarget {
    _ensureInitialized();
    return math.max(scaleMin(12), 44);
  }

  /// Responsive font size helper
  static double getResponsiveFontSize({required double mobile, double? tablet, double? desktop}) {
    _ensureInitialized();
    final baseSize = responsive<double>(
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
    return scaleText(baseSize);
  }

  /// Responsive spacing using smallest dimension
  static double getResponsiveSpacing({required double mobile, double? tablet, double? desktop}) {
    _ensureInitialized();
    return responsive<double>(
      mobile: scaleMin(mobile),
      tablet: scaleMin(tablet ?? mobile * 1.2),
      desktop: scaleMin(desktop ?? mobile * 1.4),
    );
  }

  static double scaleRadius(double percent) {
    _ensureInitialized();
    return scaleMin(percent);
  }

  static double getResponsiveBorderRadius({required double mobile, double? tablet, double? desktop}) {
    _ensureInitialized();
    return responsive<double>(
      mobile: scaleMin(mobile),
      tablet: scaleMin(tablet ?? mobile * 1.1),
      desktop: scaleMin(desktop ?? mobile * 1.2),
    );
  }

  static double get devicePixelRatio {
    _ensureInitialized();
    return _mediaQueryData!.devicePixelRatio;
  }

  static String get screenSizeCategory {
    _ensureInitialized();
    if (isMobile) return 'mobile';
    if (isTablet) return 'tablet';
    return 'desktop';
  }

  static double get aspectRatio {
    _ensureInitialized();
    return screenWidth / screenHeight;
  }

  static bool get hasNotch {
    _ensureInitialized();
    return safeAreaInsets.top > 24 || safeAreaInsets.bottom > 0;
  }

  static Map<String, dynamic> get debugInfo {
    _ensureInitialized();
    return {
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'blockWidth': blockWidth,
      'blockHeight': blockHeight,
      'devicePixelRatio': devicePixelRatio,
      'textScaleFactor': _textScaleFactor,
      'aspectRatio': aspectRatio.toStringAsFixed(2),
      'isLandscape': isLandscape,
      'isPortrait': isPortrait,
      'isMobile': isMobile,
      'isTablet': isTablet,
      'isDesktop': isDesktop,
      'isAndroid': isAndroid,
      'isIOS': isIOS,
      'isWeb': isWeb,
      'hasNotch': hasNotch,
      'keyboardHeight': keyboardHeight,
      'isKeyboardVisible': isKeyboardVisible,
      'availableWidth': availableWidth.toStringAsFixed(1),
      'availableHeight': availableHeight.toStringAsFixed(1),
      'safeAreaInsets': {
        'top': safeAreaInsets.top,
        'right': safeAreaInsets.right,
        'bottom': safeAreaInsets.bottom,
        'left': safeAreaInsets.left,
      },
    };
  }

  static void printDebug() {
    _ensureInitialized();
    print('=== SizeConfig Debug Info ===');
    debugInfo.forEach((k, v) => print('$k: $v'));
    print('============================');
  }
}

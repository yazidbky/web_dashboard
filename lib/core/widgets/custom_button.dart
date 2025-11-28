import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';

/// Enhanced CustomButton with better performance, accessibility, and UX
/// 
/// Features:
/// - Fixed sizing (no percentage-based calculations)
/// - Multiple button styles (elevated, outlined, text, icon)
/// - Gradient support
/// - Loading state
/// - Ripple effects
/// - Better disabled state
/// - Icon support (prefix/suffix)
/// - Full width option
/// - Better accessibility
class CustomButton extends StatefulWidget {
  // Core properties
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? text;
  final Widget? child;
  
  // Icons
  final String? icon;
  final String? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final double? iconSize;
  
  // Dimensions
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  // Style
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double? borderRadius;
  final double? borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double? elevation;
  
  // Text style
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  
  // Button types
  final ButtonType type;
  
  // States
  final bool isLoading;
  final bool isDisabled;
  final bool expand;
  final bool shrinkWrap;
  
  // Layout
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  
  // Loading indicator
  final Widget? loadingWidget;
  final Color? loadingColor;
  final double? loadingSize;
  
  // Animations
  final Duration? animationDuration;
  
  const CustomButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.text,
    this.child,
    
    // Icons
    this.icon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.iconSize = 20,
    
    // Dimensions
    this.width,
    this.height = 50,
    this.padding,
    this.margin,
    
    // Style
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.gradient,
    this.boxShadow,
    this.elevation,
    
    // Text style
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing,
    
    // Button types
    this.type = ButtonType.elevated,
    
    // States
    this.isLoading = false,
    this.isDisabled = false,
    this.expand = false,
    this.shrinkWrap = false,
    
    // Layout
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    
    // Loading
    this.loadingWidget,
    this.loadingColor,
    this.loadingSize = 20,
    
    // Animations
    this.animationDuration = const Duration(milliseconds: 200),
  }) : assert(
          text != null || child != null || icon != null,
          'Must provide either text, child, or icon',
        );

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEffectivelyDisabled) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEffectivelyDisabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!_isEffectivelyDisabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  bool get _isEffectivelyDisabled => 
      widget.isDisabled || widget.isLoading || widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButtonByType();

    // Apply margin if provided
    if (widget.margin != null) {
      button = Padding(padding: widget.margin!, child: button);
    }

    // Apply scale animation for press effect
    if (!_isEffectivelyDisabled && widget.type == ButtonType.elevated) {
      button = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: button,
        ),
      );
    }

    return button;
  }

  Widget _buildButtonByType() {
    switch (widget.type) {
      case ButtonType.elevated:
        return _buildElevatedButton();
      case ButtonType.outlined:
        return _buildOutlinedButton();
      case ButtonType.text:
        return _buildTextButton();
      case ButtonType.icon:
        return _buildIconButton();
    }
  }

  Widget _buildElevatedButton() {
    final effectiveBackgroundColor = _isEffectivelyDisabled
        ? (widget.disabledBackgroundColor ?? Colors.grey.shade300)
        : (widget.backgroundColor ?? AppColors.primary);

    return SizedBox(
      width: widget.expand ? double.infinity : widget.width,
      height: widget.height,
      child: widget.gradient != null && !_isEffectivelyDisabled
          ? _buildGradientButton()
          : ElevatedButton(
              onPressed: _isEffectivelyDisabled ? null : widget.onPressed,
              onLongPress: _isEffectivelyDisabled ? null : widget.onLongPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: widget.textColor ?? Colors.white,
                disabledBackgroundColor: widget.disabledBackgroundColor,
                disabledForegroundColor: widget.disabledTextColor,
                elevation: widget.elevation ?? 0,
                padding: widget.padding ?? const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                  side: widget.borderColor != null
                      ? BorderSide(
                          color: widget.borderColor!,
                          width: widget.borderWidth ?? 1.5,
                        )
                      : BorderSide.none,
                ),
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: widget.expand ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: widget.boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEffectivelyDisabled ? null : widget.onPressed,
          onLongPress: _isEffectivelyDisabled ? null : widget.onLongPress,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            alignment: Alignment.center,
            child: _buildButtonContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: widget.expand ? double.infinity : widget.width,
      height: widget.height,
      child: OutlinedButton(
        onPressed: _isEffectivelyDisabled ? null : widget.onPressed,
        onLongPress: _isEffectivelyDisabled ? null : widget.onLongPress,
        style: OutlinedButton.styleFrom(
          foregroundColor: widget.textColor ?? AppColors.primary,
          disabledForegroundColor: widget.disabledTextColor ?? Colors.grey,
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          side: BorderSide(
            color: _isEffectivelyDisabled
                ? Colors.grey.shade300
                : (widget.borderColor ?? AppColors.primary),
            width: widget.borderWidth ?? 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildTextButton() {
    return SizedBox(
      width: widget.expand ? double.infinity : widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: _isEffectivelyDisabled ? null : widget.onPressed,
        onLongPress: _isEffectivelyDisabled ? null : widget.onLongPress,
        style: TextButton.styleFrom(
          foregroundColor: widget.textColor ?? AppColors.primary,
          disabledForegroundColor: widget.disabledTextColor ?? Colors.grey,
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildIconButton() {
    final effectiveSize = widget.height ?? 48;
    
    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: widget.type == ButtonType.icon && widget.borderColor != null
          ? OutlinedButton(
              onPressed: _isEffectivelyDisabled ? null : widget.onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(
                  color: widget.borderColor!,
                  width: widget.borderWidth ?? 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                ),
              ),
              child: _buildIconContent(),
            )
          : IconButton(
              onPressed: _isEffectivelyDisabled ? null : widget.onPressed,
              icon: _buildIconContent(),
              iconSize: widget.iconSize,
              color: widget.textColor,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                ),
              ),
            ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return _buildLoadingIndicator();
    }

    if (widget.child != null) {
      return widget.child!;
    }

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.shrinkWrap ? MainAxisSize.min : widget.mainAxisSize,
      children: [
        // Prefix icon/widget
        if (widget.prefixWidget != null) ...[
          widget.prefixWidget!,
          const SizedBox(width: 8),
        ] else if (widget.icon != null) ...[
          buildIcon(widget.icon!, widget.iconSize!, widget.iconSize!),
          if (widget.text != null) const SizedBox(width: 8),
        ],

        // Text content
        if (widget.text != null)
          Flexible(
            fit: widget.shrinkWrap ? FlexFit.loose : FlexFit.tight,
            child: Text(
              widget.text!,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              style: TextStyle(
                inherit: false,  // ✅ FIX: Prevents TextStyle interpolation error
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                letterSpacing: widget.letterSpacing,
                color: _getTextColor(),
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),

        // Suffix icon/widget
        if (widget.suffixWidget != null) ...[
          const SizedBox(width: 8),
          widget.suffixWidget!,
        ] else if (widget.suffixIcon != null) ...[
          if (widget.text != null) const SizedBox(width: 8),
          buildIcon(widget.suffixIcon!, widget.iconSize!, widget.iconSize!),
        ],
      ],
    );
  }

  Widget _buildIconContent() {
    if (widget.isLoading) {
      return _buildLoadingIndicator();
    }

    if (widget.icon != null) {
      return buildIcon(widget.icon!, widget.iconSize!, widget.iconSize!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingIndicator() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return SizedBox(
      width: widget.loadingSize,
      height: widget.loadingSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.loadingColor ?? _getLoadingColor(),
        ),
      ),
    );
  }

  Color _getTextColor() {
    if (_isEffectivelyDisabled) {
      return widget.disabledTextColor ?? Colors.grey;
    }
    
    switch (widget.type) {
      case ButtonType.elevated:
        return widget.textColor ?? Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
        return widget.textColor ?? AppColors.primary;
      case ButtonType.icon:
        return widget.textColor ?? AppColors.primary;
    }
  }

  Color _getLoadingColor() {
    switch (widget.type) {
      case ButtonType.elevated:
        return widget.textColor ?? Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
      case ButtonType.icon:
        return widget.textColor ?? AppColors.primary;
    }
  }
}

/// Button type enumeration
enum ButtonType {
  elevated,
  outlined,
  text,
  icon,
}
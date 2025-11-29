import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

/// Enhanced CustomTextField with better performance, accessibility, and UX
/// 
/// Features:
/// - Smart responsive sizing (uses fixed pixels, not percentages)
/// - Better error handling and validation
/// - Accessibility support
/// - Input formatters support
/// - Smooth animations
/// - Better icon handling
/// - Auto-validation modes
class CustomTextField extends StatefulWidget {
  // Content
  final String? hintText;
  final String? label;
  final String? helperText;
  final TextEditingController? controller;
  final String? initialValue;
  
  // Validation
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  
  // Input configuration
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool readOnly;
  final bool? enabled;
  
  // Icons
  final String? prefixIcon;
  final String? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? obscureIcon;
  final String? visibleIcon;
  final bool showObscureToggle;
  
  // Styling
  final Color? fillColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? labelColor;
  final Color focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? errorBorderColor;
  final double borderRadius;
  final double? fontSize;
  final double? hintFontSize;
  final FontWeight? fontWeight;
  final FontWeight? hintFontWeight;
  final double borderWidth;
  final double focusedBorderWidth;
  
  // Behavior
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final bool showCounter;
  
  // Size constraints
  final double? height;
  final double? width;
  final EdgeInsets? contentPadding;
  
  const CustomTextField({
    super.key,
    // Content
    this.hintText,
    this.label,
    this.helperText,
    this.controller,
    this.initialValue,
    
    // Validation
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    
    // Input configuration
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.readOnly = false,
    this.enabled = true,
    
    // Icons
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.obscureIcon,
    this.visibleIcon,
    this.showObscureToggle = true,
    
    // Styling
    this.fillColor,
    this.textColor,
    this.hintTextColor,
    this.labelColor,
    this.focusedBorderColor = AppColors.primary,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.borderRadius = 12.0,
    this.fontSize,
    this.hintFontSize,
    this.fontWeight,
    this.hintFontWeight,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    
    // Behavior
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onSuffixTap,
    this.onEditingComplete,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.showCounter = false,
    
    // Size constraints
    this.height,
    this.width,
    this.contentPadding,
  }) : assert(
          controller == null || initialValue == null,
          'Cannot provide both controller and initialValue',
        );

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> 
    with SingleTickerProviderStateMixin {
  late bool _isObscured;
  late FocusNode _focusNode;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    // Animation for smooth transitions
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleObscureText() {
    if (!mounted) return;
    setState(() => _isObscured = !_isObscured);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.enabled == false;
    
    // Effective values
    int? effectiveMaxLines = widget.maxLines;
    int? effectiveMinLines = widget.minLines;
    if (_isObscured) {
      effectiveMaxLines = 1;
      effectiveMinLines = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional label above field
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: widget.labelColor ?? AppColors.grey700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Text field
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            
            // Input configuration
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            maxLines: effectiveMaxLines,
            minLines: effectiveMinLines,
            obscureText: _isObscured,
            obscuringCharacter: '•',
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            textAlign: widget.textAlign,
            
            // Validation
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            
            // Callbacks
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            
            // Styling
            style: TextStyle(
              fontSize: widget.fontSize ?? 16,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
              color: isDisabled 
                  ? AppColors.grey500 
                  : widget.textColor ?? AppColors.grey900,
            ),
            
            decoration: InputDecoration(
              // Content padding - FIXED: Using reasonable pixel values
              isDense: true,
              contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              
              // Hint text
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                fontSize: widget.hintFontSize ?? 16,
                color: widget.hintTextColor ?? AppColors.grey500,
                fontWeight: widget.hintFontWeight ?? FontWeight.w400,
              ),
              
              // Helper text
              helperText: widget.helperText,
              helperStyle: TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
              
              // Counter
              counterText: widget.showCounter ? null : '',
              
              // Icons
              prefixIcon: _buildPrefixIcon(),
              suffixIcon: _buildSuffixIcon(),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              
              // Fill color
              filled: true,
              fillColor: isDisabled 
                  ? AppColors.grey100 
                  : widget.fillColor ?? AppColors.grey50,
              
              // Borders - FIXED: Using fixed border radius
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? Colors.transparent,
                  width: widget.borderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? Colors.transparent,
                  width: widget.borderWidth,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor,
                  width: widget.focusedBorderWidth,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.errorBorderColor ?? AppColors.error,
                  width: widget.borderWidth,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.errorBorderColor ?? AppColors.error,
                  width: widget.focusedBorderWidth,
                ),
              ),
              
              // Error styling
              errorStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              errorMaxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
  final isDisabled = widget.enabled == false;
  
  // Custom suffix widget takes priority
  if (widget.suffixWidget != null) {
    return widget.suffixWidget;
  }
  
  // Obscure text toggle (password visibility)
  // Only show if obscureText is true AND showObscureToggle is true
  if (widget.obscureText && widget.showObscureToggle) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: isDisabled ? AppColors.grey400 : AppColors.grey600,
          size: 20,
        ),
        onPressed: isDisabled ? null : _toggleObscureText,
        padding: EdgeInsets.zero,
        splashRadius: 20,
        tooltip: _isObscured ? 'Show password' : 'Hide password',
      ),
    );
  }
  
  // Regular suffix icon
  if (widget.suffixIcon != null) {
    final icon = _buildIconFromPath(
      widget.suffixIcon!,
      color: isDisabled ? AppColors.grey400 : AppColors.grey600,
    );
    
    if (widget.onSuffixTap != null && !isDisabled) {
      return IconButton(
        icon: icon,
        onPressed: widget.onSuffixTap,
        padding: EdgeInsets.zero,
        splashRadius: 20,
      );
    }
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: icon,
    );
  }
  
  return null;
}

// Helper method to handle both SVG and PNG icons
Widget _buildIconFromPath(String iconPath, {required Color color}) {
  if (iconPath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(
      iconPath,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  } else {
    // Handle PNG/JPG icons
    return Image.asset(
      iconPath,
      width: 20,
      height: 20,
      color: color,
    );
  }
}

// Also update the _buildPrefixIcon method similarly:
Widget? _buildPrefixIcon() {
  if (widget.prefixWidget != null) {
    return widget.prefixWidget;
  }
  
  if (widget.prefixIcon != null) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: _buildIconFromPath(
        widget.prefixIcon!,
        color: widget.enabled == false 
            ? AppColors.grey400 
            : (_isFocused ? widget.focusedBorderColor : AppColors.grey600),
      ),
    );
  }
  
  return null;
}
  
  
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*

// 1. BASIC USAGE
CustomTextField(
  hintText: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
)

// 2. WITH VALIDATION
CustomTextField(
  label: 'Email Address',
  hintText: 'example@email.com',
  prefixIcon: AppAssets.emailIcon,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  },
)

// 3. PASSWORD FIELD
CustomTextField(
  label: 'Password',
  hintText: 'Enter your password',
  obscureText: true,
  obscureIcon: AppAssets.hide,
  visibleIcon: AppAssets.show,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  },
)

// 4. WITH CONTROLLER
final emailController = TextEditingController();

CustomTextField(
  controller: emailController,
  hintText: 'Email',
  prefixIcon: AppAssets.emailIcon,
  onChanged: (value) {
    print('Email: $value');
  },
)

// 5. CUSTOM STYLING
CustomTextField(
  hintText: 'Search...',
  fillColor: Colors.white,
  borderRadius: 25,
  focusedBorderColor: Colors.blue,
  enabledBorderColor: Colors.grey.shade300,
  borderWidth: 1.5,
  prefixIcon: AppAssets.searchIcon,
  suffixIcon: AppAssets.filterIcon,
  onSuffixTap: () {
    // Open filters
  },
)

// 6. MULTILINE TEXT FIELD
CustomTextField(
  label: 'Description',
  hintText: 'Enter description...',
  maxLines: 5,
  minLines: 3,
  textAlign: TextAlign.start,
)

// 7. WITH INPUT FORMATTERS
CustomTextField(
  label: 'Phone Number',
  hintText: '(123) 456-7890',
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
)

// 8. DISABLED FIELD
CustomTextField(
  hintText: 'Read only field',
  initialValue: 'Cannot edit this',
  enabled: false,
)

// 9. WITH HELPER TEXT
CustomTextField(
  label: 'Username',
  hintText: 'Choose a username',
  helperText: 'Username must be unique',
  maxLength: 20,
  showCounter: true,
)

// 10. COMPLETE LOGIN FORM EXAMPLE
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter your email',
            prefixIcon: AppAssets.emailIcon,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            prefixIcon: AppAssets.lockIcon,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      // Handle login
    }
  }
}

*/
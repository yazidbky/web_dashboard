import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';

void showAppSnackBar({
  required BuildContext context,
  required String message,
  required IconData icon,
  required Color backgroundColor,
  Color textColor = Colors.white,
  VoidCallback? onAction,
  String? actionLabel,
  Color? iconBackgroundColor,
  required SnackBarBehavior behavior,
  double elevation = 8,
  double borderRadius = 18,
  EdgeInsetsGeometry? margin,
  Duration duration = const Duration(seconds: 3),
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  const snackbarMaxWidth = 400.0;
  const topMargin = 16.0;
  
  // Calculate horizontal margins to center the snackbar
  final horizontalMargin = screenWidth > snackbarMaxWidth
      ? (screenWidth - snackbarMaxWidth) / 2
      : 16.0;
  
  final defaultMargin = margin ?? EdgeInsets.only(
    top: topMargin,
    left: horizontalMargin,
    right: horizontalMargin,
  );
  
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: snackbarMaxWidth),
        child: AppSnackBarContent(
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onAction: onAction,
          actionLabel: actionLabel,
          iconBackgroundColor: iconBackgroundColor,
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: defaultMargin,
      duration: duration,
    ),
  );
}

class AppSnackBarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Color? iconBackgroundColor;

  const AppSnackBarContent({
    super.key,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.onAction,
    this.actionLabel,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: textColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Message
          Expanded(
            child: CustomText(
              message,
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              maxLines: 3,
            ),
          ),
          
          // Action Button (if provided)
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: textColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
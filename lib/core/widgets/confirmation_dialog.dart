import 'package:flutter/material.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/custom_button.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';

enum DialogType {
  info,
  warning,
  danger,
  success,
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final DialogType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon = Icons.help_outline,
    this.type = DialogType.info,
    this.onConfirm,
    this.onCancel,
  });

  Color get _primaryColor {
    switch (type) {
      case DialogType.info:
        return AppColors.primary;
      case DialogType.warning:
        return AppColors.orange;
      case DialogType.danger:
        return AppColors.error;
      case DialogType.success:
        return AppColors.primary;
    }
  }

  Color get _lightColor {
    switch (type) {
      case DialogType.info:
        return AppColors.lightPrimary;
      case DialogType.warning:
        return AppColors.orange.withOpacity(0.1);
      case DialogType.danger:
        return AppColors.error.withOpacity(0.1);
      case DialogType.success:
        return AppColors.lightPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: SizeConfig.scalePadding(horizontal: 6),
      child: Container(
        padding: SizeConfig.allPadding(6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeConfig.scaleRadius(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: SizeConfig.allPadding(4),
              decoration: BoxDecoration(
                color: _lightColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: SizeConfig.scaleWidth(12),
                color: _primaryColor,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(3)),
            // Title
            CustomText(
              title,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(1.5)),
            // Description
            CustomText(
              description,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey600,
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            SizedBox(height: SizeConfig.scaleHeight(4)),
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    text: cancelText,
                    type: ButtonType.outlined,
                    borderColor: AppColors.grey400,
                    textColor: AppColors.grey700,
                    height: SizeConfig.scaleHeight(6),
                    borderRadius: SizeConfig.scaleRadius(3),
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
                // Confirm button
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    text: confirmText,
                    backgroundColor: _primaryColor,
                    textColor: AppColors.white,
                    height: SizeConfig.scaleHeight(6),
                    borderRadius: SizeConfig.scaleRadius(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the confirmation dialog with animation
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData icon = Icons.help_outline,
    DialogType type = DialogType.info,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirmation Dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ConfirmationDialog(
          title: title,
          description: description,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
          type: type,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// Convenience method for showing an info dialog
  static Future<bool?> showInfo(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData icon = Icons.info_outline,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      type: DialogType.info,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// Convenience method for showing a warning dialog
  static Future<bool?> showWarning(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData icon = Icons.warning_amber_outlined,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      type: DialogType.warning,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// Convenience method for showing a danger/destructive dialog
  static Future<bool?> showDanger(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    IconData icon = Icons.delete_outline,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      type: DialogType.danger,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// Convenience method for showing a success dialog
  static Future<bool?> showSuccess(
    BuildContext context, {
    required String title,
    required String description,
    String confirmText = 'Continue',
    String cancelText = 'Cancel',
    IconData icon = Icons.check_circle_outline,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      type: DialogType.success,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}


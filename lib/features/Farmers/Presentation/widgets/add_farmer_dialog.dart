import 'package:flutter/material.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/custom_button.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/custom_text_field.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';

class AddFarmerDialog extends StatefulWidget {
  final Function(String farmerName, String cropType)? onAdd;

  const AddFarmerDialog({
    super.key,
    this.onAdd,
  });

  @override
  State<AddFarmerDialog> createState() => _AddFarmerDialogState();

  /// Shows the add farmer dialog
  static Future<Map<String, String>?> show(BuildContext context) {
    return showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Farmer Dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddFarmerDialog();
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
}

class _AddFarmerDialogState extends State<AddFarmerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _farmerNameController = TextEditingController();
  final _cropTypeController = TextEditingController();

  @override
  void dispose() {
    _farmerNameController.dispose();
    _cropTypeController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      final result = {
        'farmerName': _farmerNameController.text.trim(),
        'cropType': _cropTypeController.text.trim(),
      };
      widget.onAdd?.call(result['farmerName']!, result['cropType']!);
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: SizeConfig.scalePadding(horizontal: 6),
      child: Container(
        width: SizeConfig.responsive(
          mobile: SizeConfig.screenWidth * 0.8,
          tablet: SizeConfig.screenWidth * 0.35,
          desktop: SizeConfig.screenWidth * 0.35,
        ),
        padding: SizeConfig.allPadding(
          SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            SizeConfig.scaleRadius(
              SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: SizeConfig.allPadding(
                  SizeConfig.responsive(mobile: 3, tablet: 3.5, desktop: 4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add_outlined,
                  size: SizeConfig.responsive(mobile: 32, tablet: 40, desktop: 48),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              
              // Title
              CustomText(
                'Add New Farmer',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.scaleHeight(1)),
              
              // Description
              CustomText(
                'Enter the farmer details below to add them to your list.',
                fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              
              // Farmer Name Field
              CustomTextField(
                fillColor: AppColors.primary.withOpacity(0.08),
                controller: _farmerNameController,
                label: 'Farmer Name',
                hintText: 'Enter farmer name',
                prefixWidget: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter farmer name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.scaleHeight(2)),
              
              // Crop Type Field
              CustomTextField(
                fillColor: AppColors.primary.withOpacity(0.08),
                controller: _cropTypeController,
                label: 'Crop Type',
                hintText: 'Enter crop type (e.g., Corn, Wheat)',
                prefixWidget: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(
                    Icons.grass_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter crop type';
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.scaleHeight(4)),
              
              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: CustomButton(
                      onPressed: () => Navigator.of(context).pop(),
                      text: 'Cancel',
                      type: ButtonType.outlined,
                      borderColor: AppColors.grey400,
                      textColor: AppColors.grey700,
                      height: SizeConfig.scaleHeight(
                        SizeConfig.responsive(mobile: 5, tablet: 5.5, desktop: 6),
                      ),
                      borderRadius: SizeConfig.scaleRadius(
                        SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(3)),
                  // Add button
                  Expanded(
                    child: CustomButton(
                      onPressed: _handleAdd,
                      text: 'Add Farmer',
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.white,
                      height: SizeConfig.scaleHeight(
                        SizeConfig.responsive(mobile: 5, tablet: 5.5, desktop: 6),
                      ),
                      borderRadius: SizeConfig.scaleRadius(
                        SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


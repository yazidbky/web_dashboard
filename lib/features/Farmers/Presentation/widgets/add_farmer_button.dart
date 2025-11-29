import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class AddFarmerButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddFarmerButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.responsive(mobile: 12, tablet: 16, desktop: 20),
            vertical: SizeConfig.responsive(mobile: 8, tablet: 10, desktop: 12),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
            ),
            border: Border.all(
              color: AppColors.grey300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                'Add farmer',
                fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              SizedBox(width: SizeConfig.scaleWidth(1)),
              Icon(
                Icons.add,
                size: SizeConfig.responsive(mobile: 16, tablet: 18, desktop: 20),
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


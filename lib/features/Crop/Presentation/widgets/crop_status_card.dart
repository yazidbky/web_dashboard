import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class CropStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final String label;
  final String icon;
  final Color backgroundColor;
  final Color? iconColor;

  const CropStatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.responsive(mobile: 1, tablet: 1, desktop: 1.5),
        vertical: SizeConfig.responsive(mobile: 1, tablet: 1, desktop: 10),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 1.5,
            tablet: 2,
            desktop: 2.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 5),
              vertical: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 30),
            ),
            child: CustomText(
            title,
            fontSize: SizeConfig.responsive(mobile: 11, tablet: 13, desktop: 14),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
         
          SizedBox(height: SizeConfig.scaleHeight(1)),
          Center(
            child: buildIcon(
              icon,
              SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
              SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
              color: iconColor,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          Center(
            child: CustomText(
              value,
              fontSize: SizeConfig.responsive(mobile: 18, tablet: 22, desktop: 22),
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(0.5)),
          Center(
            child: CustomText(
              label,
              fontSize: SizeConfig.responsive(mobile: 11, tablet: 13, desktop: 15),
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


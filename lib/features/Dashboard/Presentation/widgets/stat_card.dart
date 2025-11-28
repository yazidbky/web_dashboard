import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final String? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    this.icon,
  });

  @override
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 2,
            tablet: 2.5,
            desktop: 3,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CustomText(
              value,
              fontSize: SizeConfig.responsive(mobile: 24, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(0.5)),
          Flexible(
            child: CustomText(
              title,
              fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
              fontWeight: FontWeight.w500,
              color: AppColors.white.withOpacity(0.9),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


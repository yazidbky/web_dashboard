import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class SoilMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final String? icon;
  final Color? iconColor;

  const SoilMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    this.icon,
    this.iconColor,
  });

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  title,
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                buildIcon(
                  icon!,
                  SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
                  SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
                  color: iconColor ?? AppColors.grey600,
                ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          CustomText(
            value,
            fontSize: SizeConfig.responsive(mobile: 18, tablet: 22, desktop: 26),
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


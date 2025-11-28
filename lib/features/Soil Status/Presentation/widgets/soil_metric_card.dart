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
    
    // Create a lighter version of the background color
    final lighterBackground = backgroundColor.withOpacity(0.3);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.responsive(mobile: 7, tablet: 10, desktop: 20),
        vertical: SizeConfig.responsive(mobile: 7, tablet: 10, desktop: 20),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 1,
            tablet: 1.2,
            desktop: 1.5,
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
        
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            
            
            children: [
              if (icon != null)
                Container(
                  padding: EdgeInsets.all(
                    SizeConfig.responsive(mobile: 0.6, tablet: 0.8, desktop: 0.6),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white.withOpacity(0.3),
                    
                  ),
                  child: buildIcon(
                    icon!,
                    SizeConfig.responsive(mobile: 2.2, tablet: 2.8, desktop: 2),
                    SizeConfig.responsive(mobile: 2.2, tablet: 2.8, desktop: 2),
                    
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(1)),
              Expanded(
                child: CustomText(
                  title,
                  fontSize: SizeConfig.responsive(mobile: 11, tablet: 13, desktop: 15),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(1.2)),
          CustomText(
            value,
            fontSize: SizeConfig.responsive(mobile: 13, tablet: 16, desktop: 20),
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


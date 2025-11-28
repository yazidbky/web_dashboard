import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String icon;
  final Color? iconColor;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.responsive(mobile: 1.5, tablet: 2, desktop: 2.5),
        vertical: SizeConfig.responsive(mobile: 1.5, tablet: 2, desktop: 2.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title,
            fontSize: SizeConfig.responsive(mobile: 11, tablet: 13, desktop: 15),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIcon(
                icon,
                SizeConfig.responsive(mobile: 2.2, tablet: 2.8, desktop: 3.2),
                SizeConfig.responsive(mobile: 2.2, tablet: 2.8, desktop: 3.2),
                color: iconColor,
              ),
              SizedBox(width: SizeConfig.scaleWidth(1)),
              CustomText(
                value,
                fontSize: SizeConfig.responsive(mobile: 13, tablet: 16, desktop: 20),
                fontWeight: FontWeight.bold,
                color: valueColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


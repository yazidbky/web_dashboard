import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class ForecastData {
  final String day;
  final String date;
  final String icon;
  final String condition;
  final String temperatureRange;
  final String aqi;

  ForecastData({
    required this.day,
    required this.date,
    required this.icon,
    required this.condition,
    required this.temperatureRange,
    required this.aqi,
  });
}

class ForecastCard extends StatelessWidget {
  final ForecastData forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    forecast.day,
                    fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  CustomText(
                    forecast.date,
                    fontSize: SizeConfig.responsive(mobile: 10, tablet: 12, desktop: 14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ],
              ),
              buildIcon(
                forecast.icon,
                SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 4),
                SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 4),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          CustomText(
            forecast.condition,
            fontSize: SizeConfig.responsive(mobile: 11, tablet: 13, desktop: 15),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: SizeConfig.scaleHeight(0.5)),
          CustomText(
            forecast.temperatureRange,
            fontSize: SizeConfig.responsive(mobile: 10, tablet: 12, desktop: 14),
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
          SizedBox(height: SizeConfig.scaleHeight(0.5)),
          CustomText(
            'AQI ${forecast.aqi}',
            fontSize: SizeConfig.responsive(mobile: 10, tablet: 12, desktop: 14),
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class FarmerData {
  final String farmerName;
  final String cropType;
  final double soilMoisture;
  final String location;
  final WeatherImpact weatherImpact;

  FarmerData({
    required this.farmerName,
    required this.cropType,
    required this.soilMoisture,
    required this.location,
    required this.weatherImpact,
  });
}

enum WeatherImpact {
  bad,
  medium,
  great,
}

class FarmerDataTable extends StatelessWidget {
  final List<FarmerData> farmers;

  const FarmerDataTable({
    super.key,
    required this.farmers,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    if (SizeConfig.isMobile) {
      return _buildMobileView(context);
    } else {
      return _buildDesktopView(context);
    }
  }

  Widget _buildMobileView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: farmers.length,
      itemBuilder: (context, index) {
        final farmer = farmers[index];
        return Container(
          margin: EdgeInsets.only(
            bottom: SizeConfig.scaleHeight(1.5),
          ),
          padding: SizeConfig.scalePadding(all: 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              SizeConfig.getResponsiveBorderRadius(mobile: 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMobileRow('Farmer', farmer.farmerName),
              _buildMobileRow('Crop', farmer.cropType),
              _buildMobileRow('Soil Moisture', '${farmer.soilMoisture}'),
              _buildMobileRow('Location', farmer.location),
              _buildWeatherImpactMobile(farmer.weatherImpact),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.scaleHeight(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 13),
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
          CustomText(
            value,
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 13),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherImpactMobile(WeatherImpact impact) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.scaleHeight(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Weather Impact',
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 13),
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
          _buildWeatherBadge(impact),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth > 0 
                    ? constraints.maxWidth 
                    : SizeConfig.scaleWidth(100),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(AppColors.grey100),
                  dataRowMinHeight: SizeConfig.scaleHeight(5),
                  dataRowMaxHeight: SizeConfig.scaleHeight(8),
                  columns: [
              DataColumn(
                label: CustomText(
                  'Farmer Name',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              DataColumn(
                label: CustomText(
                  'Crop Type',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              DataColumn(
                label: CustomText(
                  'Soil Moisture',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              DataColumn(
                label: CustomText(
                  'Location',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              DataColumn(
                label: CustomText(
                  'Weather Impact',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
            ],
            rows: farmers.map((farmer) {
              return DataRow(
                cells: [
                  DataCell(
                    CustomText(
                      farmer.farmerName,
                      fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    CustomText(
                      farmer.cropType,
                      fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    CustomText(
                      '${farmer.soilMoisture}',
                      fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    CustomText(
                      farmer.location,
                      fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(_buildWeatherBadge(farmer.weatherImpact)),
                ],
              );
            }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherBadge(WeatherImpact impact) {
    String text;
    Color color;
    
    switch (impact) {
      case WeatherImpact.bad:
        text = 'Bad';
        color = AppColors.error;
        break;
      case WeatherImpact.medium:
        text = 'Medium';
        color = AppColors.orange;
        break;
      case WeatherImpact.great:
        text = 'Great';
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(2),
        vertical: SizeConfig.scaleHeight(0.5),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 1),
        ),
        border: Border.all(color: color, width: 1),
      ),
      child: CustomText(
        text,
        fontSize: SizeConfig.responsive(mobile: 10, tablet: 11, desktop: 12),
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}


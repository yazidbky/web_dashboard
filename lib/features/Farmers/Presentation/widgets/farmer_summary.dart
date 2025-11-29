import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Farmers/Data/Models/farmer_model.dart';

class FarmerSummary extends StatelessWidget {
  final FarmerTableData? selectedFarmer;

  const FarmerSummary({
    super.key,
    this.selectedFarmer,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
        ),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Farmer Summary',
            fontSize: SizeConfig.responsive(mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          if (selectedFarmer == null)
            _buildEmptyState()
          else
            _buildSummaryContent(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
              color: AppColors.grey300,
            ),
            SizedBox(height: SizeConfig.scaleHeight(2)),
            CustomText(
              'Select a farmer to view details',
              fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
              fontWeight: FontWeight.w500,
              color: AppColors.grey500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Name', selectedFarmer!.farmerName),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        _buildSummaryRow('Crop Type', selectedFarmer!.cropType),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        _buildSummaryRow('Last Activity', selectedFarmer!.lastActivity),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
          fontWeight: FontWeight.w500,
          color: AppColors.grey600,
        ),
        CustomText(
          value,
          fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/farmer_table_model.dart';

class FarmersTable extends StatelessWidget {
  final List<FarmerTableData> farmers;
  final Function(FarmerTableData)? onFarmerSelected;
  final Function(FarmerTableData)? onFarmerDisconnect;

  const FarmersTable({
    super.key,
    required this.farmers,
    this.onFarmerSelected,
    this.onFarmerDisconnect,
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
        return GestureDetector(
          onTap: () => onFarmerSelected?.call(farmer),
          child: Container(
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
                _buildMobileRow('Farmer Name', farmer.farmerName),
                _buildMobileRowWithBadge('Crop Type', farmer.cropType),
                _buildMobileRow('Last Activity', farmer.lastActivity),
                if (onFarmerDisconnect != null)
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.scaleHeight(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildDisconnectButton(context, farmer),
                      ],
                    ),
                  ),
              ],
            ),
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

  Widget _buildMobileRowWithBadge(String label, String cropType) {
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
          _buildCropBadge(cropType),
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
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 2,
            tablet: 2.5,
            desktop: 3,
          ),
        ),
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.white),
            dataRowMinHeight: SizeConfig.scaleHeight(6),
            dataRowMaxHeight: SizeConfig.scaleHeight(8),
            columnSpacing: SizeConfig.scaleWidth(4),
            horizontalMargin: SizeConfig.scaleWidth(2),
            dividerThickness: 1,
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
                  'Last Activity',
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              if (onFarmerDisconnect != null)
                DataColumn(
                  label: CustomText(
                    'Actions',
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
                    GestureDetector(
                      onTap: () => onFarmerSelected?.call(farmer),
                      child: CustomText(
                        farmer.farmerName,
                        fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                        color: AppColors.black,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(_buildCropBadge(farmer.cropType)),
                  DataCell(
                    CustomText(
                      farmer.lastActivity,
                      fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onFarmerDisconnect != null)
                    DataCell(
                      _buildDisconnectButton(context, farmer),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCropBadge(String cropType) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(2),
        vertical: SizeConfig.scaleHeight(0.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 1, tablet: 1.2, desktop: 1.5),
        ),
      ),
      child: CustomText(
        cropType,
        fontSize: SizeConfig.responsive(mobile: 10, tablet: 11, desktop: 12),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildDisconnectButton(BuildContext context, FarmerTableData farmer) {
    return InkWell(
      onTap: () => onFarmerDisconnect?.call(farmer),
      borderRadius: BorderRadius.circular(
        SizeConfig.getResponsiveBorderRadius(mobile: 1, tablet: 1.2, desktop: 1.5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(2),
          vertical: SizeConfig.scaleHeight(0.5),
        ),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            SizeConfig.getResponsiveBorderRadius(mobile: 1, tablet: 1.2, desktop: 1.5),
          ),
          border: Border.all(
            color: AppColors.error,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link_off,
              size: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
              color: AppColors.error,
            ),
            SizedBox(width: SizeConfig.scaleWidth(1)),
            CustomText(
              'Disconnect',
              fontSize: SizeConfig.responsive(mobile: 10, tablet: 11, desktop: 12),
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}


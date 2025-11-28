import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class SoilStatusHeader extends StatelessWidget {
  final String userName;
  final String? userImagePath;
  final String selectedFarmer;
  final Function(String)? onFarmerChanged;
  final Function(String)? onLandChanged;
  final Function(String)? onAreaChanged;

  const SoilStatusHeader({
    super.key,
    required this.userName,
    this.userImagePath,
    required this.selectedFarmer,
    this.onFarmerChanged,
    this.onLandChanged,
    this.onAreaChanged,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    final now = DateTime.now();
    final formattedDate = _formatDate(now);
    
    return Container(
      padding: SizeConfig.scalePadding(
        horizontal: SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
        vertical: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      formattedDate,
                      fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(0.3)),
                    CustomText(
                      'welcome back, $userName',
                      fontSize: SizeConfig.responsive(mobile: 18, tablet: 22, desktop: 24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1)),
                    Row(
                      children: [
                        CustomText(
                          'Select farmer: ',
                          fontSize: SizeConfig.responsive(mobile: 14, tablet: 15, desktop: 16),
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle farmer selection
                          },
                          child: CustomText(
                            '$selectedFarmer Soil status',
                            fontSize: SizeConfig.responsive(mobile: 14, tablet: 15, desktop: 16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!SizeConfig.isMobile) ...[
                SizedBox(width: SizeConfig.scaleWidth(2)),
                Row(
                  children: [
                    _buildDropdown(
                      'Select farmer',
                      selectedFarmer,
                      ['Taha laib', 'yazid bakai', 'Chaba heytem'],
                      onFarmerChanged,
                    ),
                    SizedBox(width: SizeConfig.scaleWidth(1.5)),
                    _buildDropdown(
                      'Select Land',
                      'Land 1',
                      ['Land 1', 'Land 2', 'Land 3'],
                      onLandChanged,
                    ),
                    SizedBox(width: SizeConfig.scaleWidth(1.5)),
                    _buildDropdown(
                      'Select area',
                      'Area 1',
                      ['Area 1', 'Area 2', 'Area 3'],
                      onAreaChanged,
                    ),
                    SizedBox(width: SizeConfig.scaleWidth(2)),
                    Row(
                      children: [
                        Container(
                          width: SizeConfig.scaleWidth(5),
                          height: SizeConfig.scaleWidth(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: userImagePath != null
                              ? ClipOval(
                                  child: Image.asset(
                                    userImagePath!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                  size: SizeConfig.scaleWidth(3),
                                ),
                        ),
                        SizedBox(width: SizeConfig.scaleWidth(1)),
                        CustomText(
                          userName,
                          fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (SizeConfig.isMobile) ...[
            SizedBox(height: SizeConfig.scaleHeight(1.5)),
            Wrap(
              spacing: SizeConfig.scaleWidth(2),
              runSpacing: SizeConfig.scaleHeight(1),
              children: [
                _buildDropdown(
                  'Select farmer',
                  selectedFarmer,
                  ['Taha laib', 'yazid bakai', 'Chaba heytem'],
                  onFarmerChanged,
                ),
                _buildDropdown(
                  'Select Land',
                  'Land 1',
                  ['Land 1', 'Land 2', 'Land 3'],
                  onLandChanged,
                ),
                _buildDropdown(
                  'Select area',
                  'Area 1',
                  ['Area 1', 'Area 2', 'Area 3'],
                  onAreaChanged,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String)? onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(2),
        vertical: SizeConfig.scaleHeight(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 1.5),
        ),
        border: Border.all(color: AppColors.grey300, width: 1),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        isDense: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.grey600,
          size: SizeConfig.scaleWidth(4),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: CustomText(
              item,
              fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
              color: AppColors.black,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null && onChanged != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class WeatherHeader extends StatelessWidget {
  final String userName;
  final String? userImagePath;
  final String selectedFarmer;
  final List<String> farmers;
  final Function(String)? onFarmerChanged;

  const WeatherHeader({
    super.key,
    required this.userName,
    this.userImagePath,
    required this.selectedFarmer,
    this.farmers = const [],
    this.onFarmerChanged,
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
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: _buildDropdown(
                          'Select farmer',
                          selectedFarmer,
                          farmers.isNotEmpty ? farmers : [selectedFarmer],
                          onFarmerChanged,
                        ),
                      ),
                      SizedBox(width: SizeConfig.scaleWidth(2)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          Flexible(
                            child: CustomText(
                              userName,
                              fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (SizeConfig.isMobile) ...[
            SizedBox(height: SizeConfig.scaleHeight(1.5)),
            Row(
              children: [
                _buildDropdown(
                  'Select farmer',
                  selectedFarmer,
                  farmers.isNotEmpty ? farmers : [selectedFarmer],
                  onFarmerChanged,
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: SizeConfig.responsive(mobile: 80, tablet: 100, desktop: 120),
        maxWidth: SizeConfig.responsive(mobile: 150, tablet: 180, desktop: 200),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.responsive(mobile: 1, tablet: 1.5, desktop: 2),
          vertical: SizeConfig.responsive(mobile: 0.6, tablet: 0.8, desktop: 1),
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
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.grey600,
            size: SizeConfig.responsive(mobile: 20, tablet: 22, desktop: 24),
          ),
          iconSize: SizeConfig.responsive(mobile: 20, tablet: 22, desktop: 24),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: CustomText(
                item,
                fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                color: AppColors.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  item == value ? item : '',
                  fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
                  color: AppColors.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          onChanged: (String? newValue) {
            if (newValue != null && onChanged != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class FarmerDropdown extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final String? subText;
  final Function(String?)? onChanged;

  const FarmerDropdown({
    super.key,
    required this.label,
    this.selectedValue,
    required this.items,
    this.subText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          label,
          fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        if (subText != null) ...[
          SizedBox(height: SizeConfig.scaleHeight(0.3)),
          CustomText(
            subText!,
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        ],
        SizedBox(height: SizeConfig.scaleHeight(1)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
            ),
            border: Border.all(
              color: AppColors.grey300,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              hint: CustomText(
                'Select $label',
                fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                color: AppColors.grey500,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.grey600,
                size: SizeConfig.responsive(mobile: 20, tablet: 22, desktop: 24),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: CustomText(
                    item,
                    fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                    color: AppColors.black,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}


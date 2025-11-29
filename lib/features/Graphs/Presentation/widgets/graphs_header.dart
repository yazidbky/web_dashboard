import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphsHeader extends StatelessWidget {
  final List<String> farmers;
  final String? selectedFarmer;
  final Function(String?)? onFarmerChanged;
  final List<String> lands;
  final String? selectedLand;
  final Function(String?)? onLandChanged;
  final List<String> sections;
  final String? selectedSection;
  final Function(String?)? onSectionChanged;
  final List<String> columns;
  final String? selectedColumn;
  final Function(String?)? onColumnChanged;
  final List<String> plotTypes;
  final String? selectedPlotType;
  final Function(String?)? onPlotTypeChanged;

  const GraphsHeader({
    super.key,
    required this.farmers,
    this.selectedFarmer,
    this.onFarmerChanged,
    required this.lands,
    this.selectedLand,
    this.onLandChanged,
    required this.sections,
    this.selectedSection,
    this.onSectionChanged,
    required this.columns,
    this.selectedColumn,
    this.onColumnChanged,
    required this.plotTypes,
    this.selectedPlotType,
    this.onPlotTypeChanged,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?)? onChanged,
    double? width,
  }) {
    // Validate that value exists in items
    final validValue = (value != null && items.contains(value)) ? value : null;
    
    return Container(
      width: width,
      padding: SizeConfig.scalePadding(
        horizontal: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
        vertical: SizeConfig.responsive(mobile: 1, tablet: 1.2, desktop: 1.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 1, tablet: 1.5, desktop: 2),
        ),
        border: Border.all(color: AppColors.grey300),
      ),
      child: DropdownButton<String>(
        value: validValue,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
            color: AppColors.grey500,
          ),
        ),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.grey600,
          size: SizeConfig.responsive(mobile: 20, tablet: 24, desktop: 28),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                color: AppColors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    final now = DateTime.now();
    final formattedDate = _formatDate(now);
    
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final userName = userState is UserSuccess ? userState.userData.fullName : 'User';
        
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.scaleHeight(2)),
              // Dropdowns row
              if (SizeConfig.isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDropdown(
                      value: selectedFarmer,
                      items: farmers.isEmpty ? ['Loading...'] : farmers,
                      hint: 'Select Farmer',
                      onChanged: farmers.isEmpty ? null : onFarmerChanged,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1.5)),
                    _buildDropdown(
                      value: selectedLand,
                      items: lands.isEmpty ? ['Select farmer first'] : lands,
                      hint: 'Select Land',
                      onChanged: lands.isEmpty ? null : onLandChanged,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1.5)),
                    _buildDropdown(
                      value: selectedSection,
                      items: sections.isEmpty ? ['No sections'] : sections,
                      hint: 'Select Section (Optional)',
                      onChanged: sections.isEmpty ? null : onSectionChanged,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1.5)),
                    _buildDropdown(
                      value: selectedColumn,
                      items: columns,
                      hint: 'Select Column',
                      onChanged: onColumnChanged,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(1.5)),
                    _buildDropdown(
                      value: selectedPlotType,
                      items: plotTypes,
                      hint: 'Select Plot Type',
                      onChanged: onPlotTypeChanged,
                    ),
                  ],
                )
              else
                Wrap(
                  spacing: SizeConfig.scaleWidth(2),
                  runSpacing: SizeConfig.scaleHeight(1.5),
                  children: [
                    SizedBox(
                      width: SizeConfig.scaleWidth(15),
                      child: _buildDropdown(
                        value: selectedFarmer,
                        items: farmers.isEmpty ? ['Loading...'] : farmers,
                        hint: 'Select Farmer',
                        onChanged: farmers.isEmpty ? null : onFarmerChanged,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.scaleWidth(12),
                      child: _buildDropdown(
                        value: selectedLand,
                        items: lands.isEmpty ? ['Select farmer first'] : lands,
                        hint: 'Select Land',
                        onChanged: lands.isEmpty ? null : onLandChanged,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.scaleWidth(12),
                      child: _buildDropdown(
                        value: selectedSection,
                        items: sections.isEmpty ? ['No sections'] : sections,
                        hint: 'Select Section (Optional)',
                        onChanged: sections.isEmpty ? null : onSectionChanged,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.scaleWidth(15),
                      child: _buildDropdown(
                        value: selectedColumn,
                        items: columns,
                        hint: 'Select Column',
                        onChanged: onColumnChanged,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.scaleWidth(12),
                      child: _buildDropdown(
                        value: selectedPlotType,
                        items: plotTypes,
                        hint: 'Select Plot Type',
                        onChanged: onPlotTypeChanged,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}


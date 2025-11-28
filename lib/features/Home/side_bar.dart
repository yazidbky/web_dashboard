import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/build_icon.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';

class SideBar extends StatefulWidget {
  final String currentRoute;
  final Function(String) onRouteChanged;

  const SideBar({
    super.key,
    required this.currentRoute,
    required this.onRouteChanged,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
      width: SizeConfig.responsive(
        mobile: SizeConfig.scaleWidth(20),
        tablet: SizeConfig.scaleWidth(18),
        desktop: SizeConfig.scaleWidth(15),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: SizeConfig.scalePadding(
              horizontal: 2,
              vertical: 2,
            ),
            child: buildIcon(
              AppAssets.logo,
              SizeConfig.responsive(mobile: 8, tablet: 10, desktop: 15),
              SizeConfig.responsive(mobile: 8, tablet: 10, desktop: 15),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  icon: AppAssets.home,
                  label: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildNavItem(
                  icon: AppAssets.farmer,
                  label: 'Farmers',
                  route: '/farmers',
                ),
                _buildNavItem(
                  icon: AppAssets.leaf,
                  label: 'Soil Status',
                  route: '/soil-status',
                ),
                _buildNavItem(
                  icon: AppAssets.rain,
                  label: 'Weather',
                  route: '/weather',
                ),
                _buildNavItem(
                  icon: AppAssets.notedLeaf,
                  label: 'Crop',
                  route: '/crop',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required String route,
  }) {
    final isActive = widget.currentRoute == route;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(1),
        vertical: SizeConfig.scaleHeight(0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onRouteChanged(route),
          borderRadius: BorderRadius.circular(
            SizeConfig.getResponsiveBorderRadius(mobile: 1.5),
          ),
          child: Container(
            padding: SizeConfig.scalePadding(
              horizontal: 2,
              vertical: 1.5,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.lightPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(
                SizeConfig.getResponsiveBorderRadius(mobile: 1.5),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: SizeConfig.scaleWidth(3),
                  height: SizeConfig.scaleWidth(3),
                  child: buildIcon(
                    icon,
                    SizeConfig.responsive(mobile: 2.5, tablet: 3, desktop: 3.5),
                    SizeConfig.responsive(mobile: 2.5, tablet: 3, desktop: 3.5),
                    color: isActive ? AppColors.primary : AppColors.grey600,
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(1.5)),
                Expanded(
                  child: CustomText(
                    label,
                    fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppColors.primary : AppColors.grey600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


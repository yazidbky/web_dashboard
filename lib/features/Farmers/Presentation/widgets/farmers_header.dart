import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class FarmersHeader extends StatelessWidget {
  final String userName;
  final String? userImageUrl;
  final VoidCallback? onAddFarmer;

  const FarmersHeader({
    super.key,
    required this.userName,
    this.userImageUrl,
    this.onAddFarmer,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Date and Welcome
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
          
          // Right side - User profile and Add farmer button
          Row(
            children: [
              // User profile section
              if (!SizeConfig.isMobile) ...[
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
                    image: userImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(userImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userImageUrl == null
                      ? Icon(
                          Icons.person,
                          color: AppColors.white,
                          size: SizeConfig.scaleWidth(3),
                        )
                      : null,
                ),
                SizedBox(width: SizeConfig.scaleWidth(1)),
                CustomText(
                  userName,
                  fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}


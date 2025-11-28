import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class CropScreen extends StatelessWidget {
  const CropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Center(
      child: CustomText(
        'Crop Screen - Coming Soon',
        fontSize: SizeConfig.responsive(mobile: 18, tablet: 22, desktop: 24),
        fontWeight: FontWeight.bold,
        color: AppColors.grey600,
      ),
    );
  }
}


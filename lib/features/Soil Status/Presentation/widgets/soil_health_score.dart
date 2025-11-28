import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class SoilHealthScore extends StatelessWidget {
  final double score; // 0-100
  final String status; // "low", "medium", "high"

  const SoilHealthScore({
    super.key,
    required this.score,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 2.5, tablet: 3, desktop: 4),
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            'soil health score',
            fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          SizedBox(
            height: SizeConfig.scaleHeight(20),
            width: SizeConfig.scaleWidth(40),
            child: CustomPaint(
              painter: _SemiCircleGaugePainter(
                score: score,
                isMobile: SizeConfig.isMobile,
                isTablet: SizeConfig.isTablet,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      '${score.toInt()}%',
                      fontSize: SizeConfig.responsive(mobile: 24, tablet: 28, desktop: 32),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          CustomText(
            'Overall status: $status',
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
        ],
      ),
    );
  }
}

class _SemiCircleGaugePainter extends CustomPainter {
  final double score;
  final bool isMobile;
  final bool isTablet;

  _SemiCircleGaugePainter({
    required this.score,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    
    // Draw background arc
    final backgroundPaint = Paint()
      ..color = AppColors.grey200
      ..style = PaintingStyle.stroke
      ..strokeWidth = isMobile ? 8.0 : (isTablet ? 10.0 : 12.0)
      ..strokeCap = StrokeCap.round;

    final backgroundPath = Path();
    backgroundPath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
    );
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw score arc
    final scorePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = isMobile ? 8.0 : (isTablet ? 10.0 : 12.0)
      ..strokeCap = StrokeCap.round;

    final scorePath = Path();
    final scoreAngle = (score / 100) * math.pi;
    scorePath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      scoreAngle,
    );
    canvas.drawPath(scorePath, scorePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


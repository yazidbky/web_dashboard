import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class FarmingOptimalityGauge extends StatelessWidget {
  final double score; // 0-100
  final String label;

  const FarmingOptimalityGauge({
    super.key,
    required this.score,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 2.5, tablet: 3, desktop: 4),
      ),
      decoration: BoxDecoration(
        color: AppColors.weatherSenary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 1.5,
            tablet: 2,
            desktop: 2.5,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final gaugeSize = SizeConfig.responsive(
                mobile: math.min(constraints.maxWidth * 0.8, SizeConfig.scaleWidth(35)),
                tablet: math.min(constraints.maxWidth * 0.7, SizeConfig.scaleWidth(40)),
                desktop: math.min(constraints.maxWidth * 0.6, SizeConfig.scaleWidth(45)),
              );
              return SizedBox(
                height: gaugeSize * 0.5,
                width: gaugeSize,
                child: CustomPaint(
                  painter: _SemiCircleGaugePainter(
                    score: score,
                    isMobile: SizeConfig.isMobile,
                    isTablet: SizeConfig.isTablet,
                  ),
                  child: Center(
                    child: CustomText(
                      '${score.toInt()} %',
                      fontSize: SizeConfig.responsive(mobile: 20, tablet: 24, desktop: 28),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          CustomText(
            label,
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
      ..strokeWidth = isMobile ? 8.0 : (isTablet ? 10.0 : 20.0)
      ..strokeCap = StrokeCap.square;

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
      ..strokeWidth = isMobile ? 8.0 : (isTablet ? 10.0 : 20.0)
      ..strokeCap = StrokeCap.square;

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


import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';

class LiveMonitorChart extends StatelessWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final String selectedDate;
  final String selectedKPI;
  final Function(String)? onDateChanged;
  final Function(String)? onKPIChanged;

  const LiveMonitorChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    required this.selectedDate,
    required this.selectedKPI,
    this.onDateChanged,
    this.onKPIChanged,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Live Monitor',
                    fontSize: SizeConfig.responsive(mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(0.3)),
                  CustomText(
                    'time progress',
                    fontSize: SizeConfig.responsive(mobile: 12, tablet: 13, desktop: 14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildDropdown(
                    'DATE',
                    selectedDate,
                    ['Today', 'Yesterday', 'Last Week'],
                    onDateChanged,
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(1.5)),
                  _buildDropdown(
                    'Select KPI',
                    selectedKPI,
                    ['Soil Moisture', 'Temperature', 'pH Level'],
                    onKPIChanged,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          Flexible(
            child: _buildChart(context),
          ),
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
        horizontal: SizeConfig.scaleWidth(1.5),
        vertical: SizeConfig.scaleHeight(0.6),
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 1),
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
          size: SizeConfig.scaleWidth(3.5),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: CustomText(
              item,
              fontSize: SizeConfig.responsive(mobile: 11, tablet: 12, desktop: 13),
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

  Widget _buildChart(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Center(
        child: CustomText(
          'No data available',
          fontSize: SizeConfig.responsive(mobile: 14, tablet: 16),
          color: AppColors.grey500,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxHeight;
        final chartWidth = constraints.maxWidth;
        final isMobile = SizeConfig.isMobile;
        final isTablet = SizeConfig.isTablet;
        
        return CustomPaint(
          size: Size(chartWidth, chartHeight),
          painter: _LineChartPainter(
            dataPoints: dataPoints,
            labels: labels,
            maxValue: 40,
            minValue: 0,
            isMobile: isMobile,
            isTablet: isTablet,
            lineColor: AppColors.weatherTertiary,
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final List<String> labels;
  final double maxValue;
  final double minValue;
  final bool isMobile;
  final bool isTablet;
  final Color lineColor;

  _LineChartPainter({
    required this.dataPoints,
    required this.labels,
    required this.maxValue,
    required this.minValue,
    required this.isMobile,
    required this.isTablet,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final padding = size.width * 0.05;
    final labelHeight = size.height * 0.08;
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2) - labelHeight;
    final startX = padding;
    final startY = padding;
    final endX = size.width - padding;
    final endY = startY + chartHeight;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.grey200
      ..strokeWidth = 1;

    final yStep = (maxValue - minValue) / 4;
    for (int i = 0; i <= 4; i++) {
      final y = startY + (chartHeight * (i / 4));
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        gridPaint,
      );
    }

    // Draw Y-axis labels
    final baseFontSize = isMobile ? 8.0 : (isTablet ? 9.0 : 10.0);
    final textStyle = TextStyle(
      fontSize: baseFontSize,
      color: AppColors.grey600,
      fontFamily: 'Poppins',
    );
    for (int i = 0; i <= 4; i++) {
      final value = maxValue - (yStep * i);
      final y = startY + (chartHeight * (i / 4));
      final textSpan = TextSpan(
        text: '${value.toInt()}°',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(startX - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final xStep = chartWidth / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final x = startX + (i * xStep);
      final normalizedValue = (dataPoints[i] - minValue) / (maxValue - minValue);
      final y = endY - (chartHeight * normalizedValue);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw point
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }

    canvas.drawPath(path, linePaint);

    // Draw X-axis labels
    final xLabelStep = chartWidth / (labels.length - 1);
    for (int i = 0; i < labels.length; i++) {
      final x = startX + (i * xLabelStep);
      final textSpan = TextSpan(
        text: labels[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, endY + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


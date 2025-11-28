import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_status_header.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_metric_card.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_health_score.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/live_monitor_chart.dart';

class SoilStatusScreen extends StatefulWidget {
  const SoilStatusScreen({super.key});

  @override
  State<SoilStatusScreen> createState() => _SoilStatusScreenState();
}

class _SoilStatusScreenState extends State<SoilStatusScreen> {
  String selectedFarmer = 'Taha laib';
  String selectedLand = 'Land 1';
  String selectedArea = 'Area 1';
  String selectedDate = 'Today';
  String selectedKPI = 'Soil Moisture';

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample chart data
    final chartData = [8.0, 12.0, 15.0, 18.0, 22.0, 25.0, 28.0, 32.0, 35.0, 38.0, 40.0, 42.0];
    final chartLabels = ['11h', '10h', '9h', '8h', '7h', '6h', '5h', '4h', '3h', '2h', '1h', 'now'];

    return _buildResponsiveLayout(
      context,
      chartData: chartData,
      chartLabels: chartLabels,
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required List<double> chartData,
    required List<String> chartLabels,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(chartData, chartLabels);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(chartData, chartLabels);
    } else {
      return _buildDesktopLayout(chartData, chartLabels);
    }
  }

  Widget _buildMobileLayout(
    List<double> chartData,
    List<String> chartLabels,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SoilStatusHeader(
            userName: 'admin',
            selectedFarmer: selectedFarmer,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
            onLandChanged: (value) => setState(() => selectedLand = value),
            onAreaChanged: (value) => setState(() => selectedArea = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildMetricCardsMobile(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          SoilHealthScore(score: 66, status: 'medium'),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(35),
              minHeight: SizeConfig.scaleHeight(30),
            ),
            child: LiveMonitorChart(
              dataPoints: chartData,
              labels: chartLabels,
              selectedDate: selectedDate,
              selectedKPI: selectedKPI,
              onDateChanged: (value) => setState(() => selectedDate = value),
              onKPIChanged: (value) => setState(() => selectedKPI = value),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    List<double> chartData,
    List<String> chartLabels,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SoilStatusHeader(
            userName: 'admin',
            selectedFarmer: selectedFarmer,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
            onLandChanged: (value) => setState(() => selectedLand = value),
            onAreaChanged: (value) => setState(() => selectedArea = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildMetricCardsTablet(),
              ),
              SizedBox(width: SizeConfig.scaleWidth(2)),
              Expanded(
                flex: 1,
                child: SoilHealthScore(score: 66, status: 'medium'),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(45),
              minHeight: SizeConfig.scaleHeight(40),
            ),
            child: LiveMonitorChart(
              dataPoints: chartData,
              labels: chartLabels,
              selectedDate: selectedDate,
              selectedKPI: selectedKPI,
              onDateChanged: (value) => setState(() => selectedDate = value),
              onKPIChanged: (value) => setState(() => selectedKPI = value),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<double> chartData,
    List<String> chartLabels,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 4,
        vertical: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SoilStatusHeader(
            userName: 'Taha Laib',
            selectedFarmer: selectedFarmer,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
            onLandChanged: (value) => setState(() => selectedLand = value),
            onAreaChanged: (value) => setState(() => selectedArea = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildMetricCardsDesktop(),
              ),
              SizedBox(width: SizeConfig.scaleWidth(3)),
              Expanded(
                flex: 1,
                child: SoilHealthScore(score: 66, status: 'medium'),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(50),
              minHeight: SizeConfig.scaleHeight(45),
            ),
            child: LiveMonitorChart(
              dataPoints: chartData,
              labels: chartLabels,
              selectedDate: selectedDate,
              selectedKPI: selectedKPI,
              onDateChanged: (value) => setState(() => selectedDate = value),
              onKPIChanged: (value) => setState(() => selectedKPI = value),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
        ],
      ),
    );
  }

  Widget _buildMetricCardsMobile() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Soil Moisture (%)',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherPrimary,
                  icon: AppAssets.soilMoisture,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1.5)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Soil Temperature',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSecondary,
                  icon: AppAssets.soilTemperature,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1.5)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Ph level',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherTertiary,
                  icon: AppAssets.phLevel,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Electrical Conductivity',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuaternary,
                  icon: AppAssets.electricalConductivity,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1.5)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Organic Matter',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuinary,
                  icon: AppAssets.organicMatter,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1.5)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'nitrite',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSenary,
                  icon: AppAssets.nitrite,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCardsTablet() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'Soil Moisture (%)',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherPrimary,
                  icon: AppAssets.soilMoisture,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(2)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'Soil Temperature',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSecondary,
                  icon: AppAssets.soilTemperature,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(2)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'Ph level',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherTertiary,
                  icon: AppAssets.phLevel,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.scaleHeight(2)),
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'Electrical Conductivity',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuaternary,
                  icon: AppAssets.electricalConductivity,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(2)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'Organic Matter',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuinary,
                  icon: AppAssets.organicMatter,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(2)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(18),
                  minHeight: SizeConfig.scaleHeight(15),
                ),
                child: SoilMetricCard(
                  title: 'nitrite',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSenary,
                  icon: AppAssets.nitrite,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCardsDesktop() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'Soil Moisture (%)',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherPrimary,
                  icon: AppAssets.soilMoisture,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(3)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'Soil Temperature',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSecondary,
                  icon: AppAssets.soilTemperature,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(3)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'Ph level',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherTertiary,
                  icon: AppAssets.phLevel,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.scaleHeight(2.5)),
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'Electrical Conductivity',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuaternary,
                  icon: AppAssets.electricalConductivity,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(3)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'Organic Matter',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherQuinary,
                  icon: AppAssets.organicMatter,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(3)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(22),
                  minHeight: SizeConfig.scaleHeight(18),
                ),
                child: SoilMetricCard(
                  title: 'nitrite',
                  value: '55% to the max',
                  backgroundColor: AppColors.weatherSenary,
                  icon: AppAssets.nitrite,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

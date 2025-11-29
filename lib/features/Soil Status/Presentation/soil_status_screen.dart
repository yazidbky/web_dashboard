import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_status_header.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_metric_card.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_health_score.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/live_monitor_chart.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';

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

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final userName = userState is UserSuccess ? userState.userData.fullName : 'User';
        return BlocBuilder<MyFarmersCubit, MyFarmersState>(
          builder: (context, farmersState) {
            final farmers = farmersState is MyFarmersSuccess
                ? farmersState.farmers.map((f) => f.fullName).toList()
                : <String>[];
            
            // Set initial farmer if not set and farmers available
            if (farmers.isNotEmpty && !farmers.contains(selectedFarmer)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => selectedFarmer = farmers.first);
                }
              });
            }
            
            return _buildResponsiveLayout(
              context,
              chartData: chartData,
              chartLabels: chartLabels,
              userName: userName,
              farmers: farmers,
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required List<double> chartData,
    required List<String> chartLabels,
    required String userName,
    required List<String> farmers,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(chartData, chartLabels, userName, farmers);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(chartData, chartLabels, userName, farmers);
    } else {
      return _buildDesktopLayout(chartData, chartLabels, userName, farmers);
    }
  }

  Widget _buildMobileLayout(
    List<double> chartData,
    List<String> chartLabels,
    String userName,
    List<String> farmers,
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
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
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
    String userName,
    List<String> farmers,
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
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
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
              Flexible(
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
    String userName,
    List<String> farmers,
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
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
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
              Flexible(
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
      mainAxisSize: MainAxisSize.min,
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
            SizedBox(width: SizeConfig.scaleWidth(1)),
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
            SizedBox(width: SizeConfig.scaleWidth(1)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Ph level',
                  value: '5.5',
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
                  value: '15-25 °C',
                  backgroundColor: AppColors.weatherQuaternary,
                  icon: AppAssets.electricalConductivity,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'Organic Matter',
                  value: '1.5%',
                  backgroundColor: AppColors.weatherQuinary,
                  icon: AppAssets.organicMatter,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(1)),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.scaleHeight(15),
                  minHeight: SizeConfig.scaleHeight(12),
                ),
                child: SoilMetricCard(
                  title: 'nitrite',
                  value: '0.5 mg/L',
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
                  value: '55%',
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
                  value: '25 °C',
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
                  value: '5.5',
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
                  value: '15-25 °C',
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
                  value: '1.5%',
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
                  value: '0.5 mg/L',
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
                  value: '55%',
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
                  value: '25 °C',
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
                  value: '5.5',
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
                  value: '15-25 °C',
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
                  value: '1.5%',
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
                  value: '55%',
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

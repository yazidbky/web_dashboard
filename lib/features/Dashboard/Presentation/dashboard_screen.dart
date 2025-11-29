import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/stat_card.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/farmer_data_table.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/dashboard_header.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample data - replace with actual data from your data source
    final farmers = [
      FarmerData(
        farmerName: 'taha laib',
        cropType: 'Rice',
        soilMoisture: 6.2,
        location: 'Msila',
        weatherImpact: WeatherImpact.bad,
      ),
      FarmerData(
        farmerName: 'yazid bakai',
        cropType: 'Wheat',
        soilMoisture: 2.3,
        location: 'setif',
        weatherImpact: WeatherImpact.great,
      ),
      FarmerData(
        farmerName: 'Chaba heytem',
        cropType: 'Wheat',
        soilMoisture: 3.5,
        location: 'bouira',
        weatherImpact: WeatherImpact.medium,
      ),
      FarmerData(
        farmerName: 'taha laib',
        cropType: 'Rice',
        soilMoisture: 5.8,
        location: 'alger',
        weatherImpact: WeatherImpact.bad,
      ),
      FarmerData(
        farmerName: 'yazid bakai',
        cropType: 'Wheat',
        soilMoisture: 4.1,
        location: 'biskra',
        weatherImpact: WeatherImpact.great,
      ),
    ];

    // Sample chart data - replace with actual data
    final chartData = [5.0, 8.0, 12.0, 15.0, 18.0, 22.0, 25.0, 28.0, 32.0, 35.0, 38.0, 42.0];
    final chartLabels = ['11h', '10h', '9h', '8h', '7h', '6h', '5h', '4h', '3h', '2h', '1h', 'now'];

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final userName = state is UserSuccess ? state.userData.fullName : 'User';
        return _buildResponsiveLayout(
          context,
          farmers: farmers,
          chartData: chartData,
          chartLabels: chartLabels,
          userName: userName,
        );
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required List<FarmerData> farmers,
    required List<double> chartData,
    required List<String> chartLabels,
    required String userName,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(farmers, chartData, chartLabels, userName);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(farmers, chartData, chartLabels, userName);
    } else {
      return _buildDesktopLayout(farmers, chartData, chartLabels, userName);
    }
  }

  Widget _buildMobileLayout(
    List<FarmerData> farmers,
    List<double> chartData,
    List<String> chartLabels,
    String userName,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardHeader(userName: userName),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildStatCardsMobile(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          // ConstrainedBox(
          //   constraints: BoxConstraints(
          //     maxHeight: SizeConfig.scaleHeight(30),
          //     minHeight: SizeConfig.scaleHeight(25),
          //   ),
          //   child: SoilMoistureChart(
          //     dataPoints: chartData,
          //     labels: chartLabels,
          //   ),
          // ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FarmerDataTable(farmers: farmers),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    List<FarmerData> farmers,
    List<double> chartData,
    List<String> chartLabels,
    String userName,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardHeader(userName: userName),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          _buildStatCardsTablet(),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: FarmerDataTable(farmers: farmers),
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(2)),
                // Expanded(
                //   flex: 1,
                //   child: ConstrainedBox(
                //     constraints: BoxConstraints(
                //       maxHeight: SizeConfig.scaleHeight(40),
                //       minHeight: SizeConfig.scaleHeight(30),
                //     ),
                //     child: SoilMoistureChart(
                //       dataPoints: chartData,
                //       labels: chartLabels,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<FarmerData> farmers,
    List<double> chartData,
    List<String> chartLabels,
    String userName,
  ) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardHeader(userName: userName),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          _buildStatCardsDesktop(),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(60),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: FarmerDataTable(farmers: farmers),
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
                // Expanded(
                //   flex: 2,
                //   child: ConstrainedBox(
                //     constraints: BoxConstraints(
                //       maxHeight: SizeConfig.scaleHeight(45),
                //       minHeight: SizeConfig.scaleHeight(35),
                //     ),
                //     child: SoilMoistureChart(
                //       dataPoints: chartData,
                //       labels: chartLabels,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildStatCardsMobile() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.scaleHeight(12),
            minHeight: SizeConfig.scaleHeight(10),
          ),
          child: StatCard(
            title: 'Total Farmers',
            value: '27',
            backgroundColor: AppColors.dashboardPrimary,
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.scaleHeight(12),
            minHeight: SizeConfig.scaleHeight(10),
          ),
          child: StatCard(
            title: 'farmers need attention',
            value: '2',
            backgroundColor: AppColors.dashboardSecondary,
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.scaleHeight(12),
            minHeight: SizeConfig.scaleHeight(10),
          ),
          child: StatCard(
            title: 'Average Soil Moisture',
            value: '45',
            backgroundColor: AppColors.dashboardTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsTablet() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(15),
              minHeight: SizeConfig.scaleHeight(12),
            ),
            child: StatCard(
              title: 'Total Farmers',
              value: '27',
              backgroundColor: AppColors.dashboardPrimary,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(2)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(15),
              minHeight: SizeConfig.scaleHeight(12),
            ),
            child: StatCard(
              title: 'farmers need attention',
              value: '2',
              backgroundColor: AppColors.dashboardSecondary,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(2)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(15),
              minHeight: SizeConfig.scaleHeight(12),
            ),
            child: StatCard(
              title: 'Average Soil Moisture',
              value: '45',
              backgroundColor: AppColors.dashboardTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsDesktop() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(25),
              minHeight: SizeConfig.scaleHeight(20),
            ),
            child: StatCard(
              title: 'Total Farmers',
              value: '27',
              backgroundColor: AppColors.dashboardPrimary,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(3)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(25),
              minHeight: SizeConfig.scaleHeight(20),
            ),
            child: StatCard(
              title: 'farmers need attention',
              value: '2',
              backgroundColor: AppColors.dashboardSecondary,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(3)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(25),
              minHeight: SizeConfig.scaleHeight(20),
            ),
            child: StatCard(
              title: 'Average Soil Moisture',
              value: '45',
              backgroundColor: AppColors.dashboardTertiary,
            ),
          ),
        ),
      ],
    );
  }
}


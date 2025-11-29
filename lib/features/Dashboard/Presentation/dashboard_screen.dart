import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/stat_card.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/farmer_data_table.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/widgets/dashboard_header.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/Dashboard/Logic/overview_cubit.dart';
import 'package:web_dashboard/features/Dashboard/Logic/overview_state.dart';
import 'package:web_dashboard/features/Dashboard/Data/Models/overview_table_data_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch overview data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OverviewCubit>().getOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final userName = userState is UserSuccess ? userState.userData.fullName : 'User';
        
        return BlocBuilder<OverviewCubit, OverviewState>(
          builder: (context, overviewState) {
            return _buildResponsiveLayout(
              context,
              userName: userName,
              overviewState: overviewState,
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required String userName,
    required OverviewState overviewState,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(userName, overviewState);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(userName, overviewState);
    } else {
      return _buildDesktopLayout(userName, overviewState);
    }
  }

  List<FarmerData> _convertTableData(List<OverviewTableDataModel> tableData) {
    return tableData.map((item) {
      WeatherImpact impact;
      switch (item.weatherImpact.toLowerCase()) {
        case 'bad':
          impact = WeatherImpact.bad;
          break;
        case 'great':
          impact = WeatherImpact.great;
          break;
        default:
          impact = WeatherImpact.medium;
      }

      return FarmerData(
        farmerName: item.farmerName,
        cropType: item.cropType,
        soilMoisture: double.tryParse(item.soilMoisture) ?? 0.0,
        location: item.location,
        weatherImpact: impact,
      );
    }).toList();
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            'Loading dashboard...',
            fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
            color: AppColors.grey600,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
            color: AppColors.error,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            message,
            fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
            color: AppColors.error,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          ElevatedButton(
            onPressed: () => context.read<OverviewCubit>().getOverview(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: CustomText(
              'Retry',
              color: AppColors.white,
              fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(String userName, OverviewState overviewState) {
    if (overviewState is OverviewLoading) {
      return _buildLoadingWidget();
    }

    if (overviewState is OverviewFailure) {
      return _buildErrorWidget(overviewState.failureMessage);
    }

    // Default values
    int totalFarmers = 0;
    int farmersNeedingAttention = 0;
    double averageSoilMoisture = 0.0;
    List<FarmerData> farmers = [];

    if (overviewState is OverviewSuccess) {
      totalFarmers = overviewState.data.stats.totalFarmers;
      farmersNeedingAttention = overviewState.data.stats.farmersNeedingAttention;
      averageSoilMoisture = overviewState.data.stats.averageSoilMoisture;
      farmers = _convertTableData(overviewState.data.tableData);
    }

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
          _buildStatCardsMobile(
            totalFarmers: totalFarmers,
            farmersNeedingAttention: farmersNeedingAttention,
            averageSoilMoisture: averageSoilMoisture,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          if (farmers.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FarmerDataTable(farmers: farmers),
            )
          else
            _buildEmptyTableWidget(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(String userName, OverviewState overviewState) {
    if (overviewState is OverviewLoading) {
      return _buildLoadingWidget();
    }

    if (overviewState is OverviewFailure) {
      return _buildErrorWidget(overviewState.failureMessage);
    }

    // Default values
    int totalFarmers = 0;
    int farmersNeedingAttention = 0;
    double averageSoilMoisture = 0.0;
    List<FarmerData> farmers = [];

    if (overviewState is OverviewSuccess) {
      totalFarmers = overviewState.data.stats.totalFarmers;
      farmersNeedingAttention = overviewState.data.stats.farmersNeedingAttention;
      averageSoilMoisture = overviewState.data.stats.averageSoilMoisture;
      farmers = _convertTableData(overviewState.data.tableData);
    }

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
          _buildStatCardsTablet(
            totalFarmers: totalFarmers,
            farmersNeedingAttention: farmersNeedingAttention,
            averageSoilMoisture: averageSoilMoisture,
          ),
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
                  child: farmers.isNotEmpty
                      ? SingleChildScrollView(
                          child: FarmerDataTable(farmers: farmers),
                        )
                      : _buildEmptyTableWidget(),
                ),
                SizedBox(width: SizeConfig.scaleWidth(2)),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(String userName, OverviewState overviewState) {
    if (overviewState is OverviewLoading) {
      return _buildLoadingWidget();
    }

    if (overviewState is OverviewFailure) {
      return _buildErrorWidget(overviewState.failureMessage);
    }

    // Default values
    int totalFarmers = 0;
    int farmersNeedingAttention = 0;
    double averageSoilMoisture = 0.0;
    List<FarmerData> farmers = [];

    if (overviewState is OverviewSuccess) {
      totalFarmers = overviewState.data.stats.totalFarmers;
      farmersNeedingAttention = overviewState.data.stats.farmersNeedingAttention;
      averageSoilMoisture = overviewState.data.stats.averageSoilMoisture;
      farmers = _convertTableData(overviewState.data.tableData);
    }

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
          _buildStatCardsDesktop(
            totalFarmers: totalFarmers,
            farmersNeedingAttention: farmersNeedingAttention,
            averageSoilMoisture: averageSoilMoisture,
          ),
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
                  child: farmers.isNotEmpty
                      ? SingleChildScrollView(
                          child: FarmerDataTable(farmers: farmers),
                        )
                      : _buildEmptyTableWidget(),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildEmptyTableWidget() {
    return Container(
      padding: SizeConfig.scalePadding(all: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
        ),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
              color: AppColors.grey400,
            ),
            SizedBox(height: SizeConfig.scaleHeight(2)),
            CustomText(
              'No farmer data available',
              fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
              color: AppColors.grey600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardsMobile({
    required int totalFarmers,
    required int farmersNeedingAttention,
    required double averageSoilMoisture,
  }) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.scaleHeight(12),
            minHeight: SizeConfig.scaleHeight(10),
          ),
          child: StatCard(
            title: 'Total Farmers',
            value: '$totalFarmers',
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
            title: 'Farmers Need Attention',
            value: '$farmersNeedingAttention',
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
            value: '${averageSoilMoisture.toStringAsFixed(1)}%',
            backgroundColor: AppColors.dashboardTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsTablet({
    required int totalFarmers,
    required int farmersNeedingAttention,
    required double averageSoilMoisture,
  }) {
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
              value: '$totalFarmers',
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
              title: 'Farmers Need Attention',
              value: '$farmersNeedingAttention',
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
              value: '${averageSoilMoisture.toStringAsFixed(1)}%',
              backgroundColor: AppColors.dashboardTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsDesktop({
    required int totalFarmers,
    required int farmersNeedingAttention,
    required double averageSoilMoisture,
  }) {
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
              value: '$totalFarmers',
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
              title: 'Farmers Need Attention',
              value: '$farmersNeedingAttention',
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
              value: '${averageSoilMoisture.toStringAsFixed(1)}%',
              backgroundColor: AppColors.dashboardTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/weather_header.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/kpi_card.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/forecast_section.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/temperature_chart.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/forecast_card.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String selectedFarmer = 'Taha laib';
  String selectedLand = 'Land 1';

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample forecast data
    final forecasts = [
      ForecastData(
        day: 'Today',
        date: 'Mar 6',
        icon: AppAssets.sunny,
        condition: 'Sunny',
        temperatureRange: '15-20°C',
        aqi: '67',
      ),
      ForecastData(
        day: 'Mon',
        date: 'Mar 7',
        icon: AppAssets.sunCloudy,
        condition: 'Cloudy',
        temperatureRange: '16-22°C',
        aqi: '71',
      ),
      ForecastData(
        day: 'Tue',
        date: 'Mar 8',
        icon: AppAssets.lightning,
        condition: 'Lightning',
        temperatureRange: '17-20°C',
        aqi: '65',
      ),
      ForecastData(
        day: 'Wed',
        date: 'Mar 9',
        icon: AppAssets.heavyRain,
        condition: 'Heavy rain',
        temperatureRange: '16-21°C',
        aqi: '70',
      ),
    ];

    // Sample chart data
    final chartData = [5.0, 8.0, 12.0, 15.0, 18.0, 10.0, 8.0, 12.0, 18.0, 25.0, 35.0, 42.0];
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
              forecasts: forecasts,
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
    required List<ForecastData> forecasts,
    required List<double> chartData,
    required List<String> chartLabels,
    required String userName,
    required List<String> farmers,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(forecasts, chartData, chartLabels, userName, farmers);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(forecasts, chartData, chartLabels, userName, farmers);
    } else {
      return _buildDesktopLayout(forecasts, chartData, chartLabels, userName, farmers);
    }
  }

  Widget _buildMobileLayout(
    List<ForecastData> forecasts,
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
          WeatherHeader(
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildKPICardsMobile(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          ForecastSection(
            forecasts: forecasts,
            lands: ['Land 1', 'Land 2'],
            selectedLand: selectedLand,
            onLandChanged: (value) => setState(() => selectedLand = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(35),
              minHeight: SizeConfig.scaleHeight(30),
            ),
            child: TemperatureChart(
              dataPoints: chartData,
              labels: chartLabels,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    List<ForecastData> forecasts,
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
          WeatherHeader(
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          _buildKPICardsTablet(),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ForecastSection(
                  forecasts: forecasts,
                  lands: ['Land 1', 'Land 2'],
                  selectedLand: selectedLand,
                  onLandChanged: (value) => setState(() => selectedLand = value),
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(2)),
              Expanded(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: SizeConfig.scaleHeight(45),
                    minHeight: SizeConfig.scaleHeight(40),
                  ),
                  child: TemperatureChart(
                    dataPoints: chartData,
                    labels: chartLabels,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<ForecastData> forecasts,
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
          WeatherHeader(
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          _buildKPICardsDesktop(),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ForecastSection(
                  forecasts: forecasts,
                  lands: ['Land 1', 'Land 2'],
                  selectedLand: selectedLand,
                  onLandChanged: (value) => setState(() => selectedLand = value),
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(3)),
              Expanded(
                flex: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: SizeConfig.scaleHeight(50),
                    minHeight: SizeConfig.scaleHeight(45),
                  ),
                  child: TemperatureChart(
                    dataPoints: chartData,
                    labels: chartLabels,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
        ],
      ),
    );
  }

  Widget _buildKPICardsMobile() {
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
                child: KPICard(
                  title: 'Rain',
                  value: '0MM',
                  valueColor: AppColors.primary,
                  icon: AppAssets.rain,
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
                child: KPICard(
                  title: 'Temperateur',
                  value: '-35°C',
                  valueColor: AppColors.orange,
                  icon: AppAssets.sunny,
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
                child: KPICard(
                  title: 'Wind',
                  value: '20km/H',
                  valueColor: const Color(0xFF03A9F4),
                  icon: AppAssets.windy,
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
                child: KPICard(
                  title: 'Humidity',
                  value: '40%',
                  valueColor: const Color(0xFF03A9F4),
                  icon: AppAssets.humidity,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICardsTablet() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(18),
              minHeight: SizeConfig.scaleHeight(15),
            ),
            child: KPICard(
              title: 'Rain',
              value: '0MM',
              valueColor: AppColors.primary,
              icon: AppAssets.rainfallAlert,
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
            child: KPICard(
              title: 'Temperateur',
              value: '-35°C',
              valueColor: AppColors.orange,
              icon: AppAssets.sunny,
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
            child: KPICard(
              title: 'Wind',
              value: '20km/H',
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.windyWeatherAlert,
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
            child: KPICard(
              title: 'Humidity',
              value: '40%',
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.rainfallAlert,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICardsDesktop() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(22),
              minHeight: SizeConfig.scaleHeight(18),
            ),
            child: KPICard(
              title: 'Rain',
              value: '0MM',
              valueColor: AppColors.primary,
              icon: AppAssets.heavyRain,
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
            child: KPICard(
              title: 'Temperateur',
              value: '-35°C',
              valueColor: AppColors.orange,
              icon: AppAssets.sunny,
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
            child: KPICard(
              title: 'Wind',
              value: '20km/H',
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.windy,
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
            child: KPICard(
              title: 'Humidity',
              value: '40%',
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.humidity,
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/core/DI/dependency_injection.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_cubit.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_state.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Logic/today_weather_cubit.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Logic/today_weather_state.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Logic/weather_forecast_cubit.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Logic/weather_forecast_state.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/weather_header.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/kpi_card.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/forecast_section.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/temperature_chart.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/forecast_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? selectedFarmer;
  String? selectedLand;
  int? selectedFarmerId;
  int? selectedLandId;
  
  // Cubits
  late FarmerLandsCubit _farmerLandsCubit;
  late TodayWeatherCubit _todayWeatherCubit;
  late WeatherForecastCubit _weatherForecastCubit;
  
  // Stream subscriptions
  StreamSubscription<FarmerLandsState>? _landsSubscription;
  
  // Dynamic data
  List<int> landIds = [];
  List<String> lands = [];

  @override
  void initState() {
    super.initState();
    _farmerLandsCubit = getIt<FarmerLandsCubit>();
    _todayWeatherCubit = getIt<TodayWeatherCubit>();
    _weatherForecastCubit = getIt<WeatherForecastCubit>();
    
    // Listen to lands state
    _landsSubscription = _farmerLandsCubit.stream.listen((state) {
      if (state is FarmerLandsSuccess) {
        setState(() {
          landIds = state.landIds;
          lands = state.landIds.map((id) => 'Land $id').toList();
        });
        // Auto-select first land if available
        if (lands.isNotEmpty && selectedLand == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                selectedLand = lands.first;
                selectedLandId = landIds.first;
              });
              // Fetch weather data for the selected land
              _fetchWeatherData(selectedLandId!);
            }
          });
        }
      } else if (state is FarmerLandsFailure) {
        setState(() {
          lands = [];
          landIds = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _landsSubscription?.cancel();
    _farmerLandsCubit.close();
    _todayWeatherCubit.close();
    _weatherForecastCubit.close();
    super.dispose();
  }

  void _fetchWeatherData(int landId) {
    print('🔄 [WeatherScreen] Fetching weather data for land ID: $landId');
    _todayWeatherCubit.getTodayWeather(landId);
    _weatherForecastCubit.getWeatherForecast(landId);
  }

  void _fetchFarmerLands(int farmerId) {
    print('🔄 [WeatherScreen] Fetching lands for farmer ID: $farmerId');
    _farmerLandsCubit.getFarmerLands(farmerId);
  }

  int? _getLandIdFromName(String landName) {
    // Extract ID from "Land X" format
    final match = RegExp(r'Land (\d+)').firstMatch(landName);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample chart data (can be replaced with real data later)
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
            if (farmers.isNotEmpty && (selectedFarmer == null || !farmers.contains(selectedFarmer))) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && farmersState is MyFarmersSuccess) {
                  final farmer = farmersState.farmers.firstWhere(
                    (f) => f.fullName == farmers.first,
                    orElse: () => farmersState.farmers.first,
                  );
                  setState(() {
                    selectedFarmer = farmer.fullName;
                    selectedFarmerId = farmer.id;
                  });
                  // Fetch lands for the selected farmer
                  _fetchFarmerLands(farmer.id);
                }
              });
            }
            
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _farmerLandsCubit),
                BlocProvider.value(value: _todayWeatherCubit),
                BlocProvider.value(value: _weatherForecastCubit),
              ],
              child: _buildResponsiveLayout(
                context,
                chartData: chartData,
                chartLabels: chartLabels,
                userName: userName,
                farmers: farmers,
                farmersState: farmersState,
              ),
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
    required MyFarmersState farmersState,
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
          WeatherHeader(
            userName: userName,
            selectedFarmer: selectedFarmer ?? '',
            farmers: farmers,
            onFarmerChanged: (value) {
              final currentFarmersState = context.read<MyFarmersCubit>().state;
              if (currentFarmersState is MyFarmersSuccess) {
                final farmer = currentFarmersState.farmers.firstWhere(
                  (f) => f.fullName == value,
                );
                setState(() {
                  selectedFarmer = value;
                  selectedFarmerId = farmer.id;
                  // Reset land when farmer changes
                  selectedLand = null;
                  selectedLandId = null;
                  lands = [];
                  landIds = [];
                });
                // Fetch lands for the new farmer
                _fetchFarmerLands(farmer.id);
              }
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          BlocBuilder<TodayWeatherCubit, TodayWeatherState>(
            builder: (context, todayState) {
              return _buildKPICardsMobile(todayState);
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
            builder: (context, landsState) {
              return BlocBuilder<WeatherForecastCubit, WeatherForecastState>(
                builder: (context, forecastState) {
                  return ForecastSection(
                    forecasts: _convertForecastData(forecastState),
                    lands: lands,
                    selectedLand: selectedLand ?? '',
                    onLandChanged: (value) {
                      final landId = _getLandIdFromName(value);
                      setState(() {
                        selectedLand = value;
                        selectedLandId = landId;
                      });
                      // Fetch weather data for the selected land
                      if (landId != null) {
                        _fetchWeatherData(landId);
                      }
                    },
                  );
                },
              );
            },
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
            selectedFarmer: selectedFarmer ?? '',
            farmers: farmers,
            onFarmerChanged: (value) {
              final currentFarmersState = context.read<MyFarmersCubit>().state;
              if (currentFarmersState is MyFarmersSuccess) {
                final farmer = currentFarmersState.farmers.firstWhere(
                  (f) => f.fullName == value,
                );
                setState(() {
                  selectedFarmer = value;
                  selectedFarmerId = farmer.id;
                  // Reset land when farmer changes
                  selectedLand = null;
                  selectedLandId = null;
                  lands = [];
                  landIds = [];
                });
                // Fetch lands for the new farmer
                _fetchFarmerLands(farmer.id);
              }
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          BlocBuilder<TodayWeatherCubit, TodayWeatherState>(
            builder: (context, todayState) {
              return _buildKPICardsTablet(todayState);
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
                  builder: (context, landsState) {
                    return BlocBuilder<WeatherForecastCubit, WeatherForecastState>(
                      builder: (context, forecastState) {
                        return ForecastSection(
                          forecasts: _convertForecastData(forecastState),
                          lands: lands,
                          selectedLand: selectedLand ?? '',
                          onLandChanged: (value) {
                            final landId = _getLandIdFromName(value);
                            setState(() {
                              selectedLand = value;
                              selectedLandId = landId;
                            });
                            // Fetch weather data for the selected land
                            if (landId != null) {
                              _fetchWeatherData(landId);
                            }
                          },
                        );
                      },
                    );
                  },
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
            selectedFarmer: selectedFarmer ?? '',
            farmers: farmers,
            onFarmerChanged: (value) {
              final currentFarmersState = context.read<MyFarmersCubit>().state;
              if (currentFarmersState is MyFarmersSuccess) {
                final farmer = currentFarmersState.farmers.firstWhere(
                  (f) => f.fullName == value,
                );
                setState(() {
                  selectedFarmer = value;
                  selectedFarmerId = farmer.id;
                  // Reset land when farmer changes
                  selectedLand = null;
                  selectedLandId = null;
                  lands = [];
                  landIds = [];
                });
                // Fetch lands for the new farmer
                _fetchFarmerLands(farmer.id);
              }
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          BlocBuilder<TodayWeatherCubit, TodayWeatherState>(
            builder: (context, todayState) {
              return _buildKPICardsDesktop(todayState);
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
                  builder: (context, landsState) {
                    return BlocBuilder<WeatherForecastCubit, WeatherForecastState>(
                      builder: (context, forecastState) {
                        return ForecastSection(
                          forecasts: _convertForecastData(forecastState),
                          lands: lands,
                          selectedLand: selectedLand ?? '',
                          onLandChanged: (value) {
                            final landId = _getLandIdFromName(value);
                            setState(() {
                              selectedLand = value;
                              selectedLandId = landId;
                            });
                            // Fetch weather data for the selected land
                            if (landId != null) {
                              _fetchWeatherData(landId);
                            }
                          },
                        );
                      },
                    );
                  },
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

  List<ForecastData> _convertForecastData(WeatherForecastState state) {
    if (state is WeatherForecastSuccess) {
      return state.forecastData.map((day) {
        // Map condition text to icon
        String icon = AppAssets.sunny;
        final conditionText = day.condition.text.toLowerCase();
        if (conditionText.contains('rain') || conditionText.contains('rainy')) {
          icon = AppAssets.heavyRain;
        } else if (conditionText.contains('cloud')) {
          icon = AppAssets.sunCloudy;
        } else if (conditionText.contains('lightning') || conditionText.contains('storm')) {
          icon = AppAssets.lightning;
        }
        
        // Extract day name and date from dayName (e.g., "Today (Sun) Mar 6")
        final parts = day.dayName.split(' ');
        final dayName = parts.isNotEmpty ? parts[0] : 'Today';
        final date = parts.length > 2 ? parts.sublist(1).join(' ') : day.dayName;
        
        return ForecastData(
          day: dayName,
          date: date,
          icon: icon,
          condition: day.condition.text,
          temperatureRange: '${day.tempMin}-${day.tempMax}°C',
          aqi: day.aqi.toString(),
        );
      }).toList();
    }
    return [];
  }

  Widget _buildKPICardsMobile(TodayWeatherState state) {
    String rainValue = '0MM';
    String tempValue = '-35°C';
    String windValue = '20km/H';
    String humidityValue = '40%';
    
    if (state is TodayWeatherSuccess) {
      rainValue = '${state.weatherData.rain.value.toInt()}${state.weatherData.rain.unit}';
      tempValue = '${state.weatherData.temperature.value.toInt()}${state.weatherData.temperature.unit}';
      windValue = '${state.weatherData.wind.value.toInt()}${state.weatherData.wind.unit}';
      humidityValue = '${state.weatherData.humidity.value.toInt()}${state.weatherData.humidity.unit}';
    }
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
                  value: rainValue,
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
                  value: tempValue,
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
                  value: windValue,
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
                  value: humidityValue,
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

  Widget _buildKPICardsTablet(TodayWeatherState state) {
    String rainValue = '0MM';
    String tempValue = '-35°C';
    String windValue = '20km/H';
    String humidityValue = '40%';
    
    if (state is TodayWeatherSuccess) {
      rainValue = '${state.weatherData.rain.value.toInt()}${state.weatherData.rain.unit}';
      tempValue = '${state.weatherData.temperature.value.toInt()}${state.weatherData.temperature.unit}';
      windValue = '${state.weatherData.wind.value.toInt()}${state.weatherData.wind.unit}';
      humidityValue = '${state.weatherData.humidity.value.toInt()}${state.weatherData.humidity.unit}';
    }
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
              value: rainValue,
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
              value: tempValue,
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
              value: windValue,
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
              value: humidityValue,
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.rainfallAlert,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICardsDesktop(TodayWeatherState state) {
    String rainValue = '0MM';
    String tempValue = '-35°C';
    String windValue = '20km/H';
    String humidityValue = '40%';
    
    if (state is TodayWeatherSuccess) {
      rainValue = '${state.weatherData.rain.value.toInt()}${state.weatherData.rain.unit}';
      tempValue = '${state.weatherData.temperature.value.toInt()}${state.weatherData.temperature.unit}';
      windValue = '${state.weatherData.wind.value.toInt()}${state.weatherData.wind.unit}';
      humidityValue = '${state.weatherData.humidity.value.toInt()}${state.weatherData.humidity.unit}';
    }
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
              value: rainValue,
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
              value: tempValue,
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
              value: windValue,
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
              value: humidityValue,
              valueColor: const Color(0xFF03A9F4),
              icon: AppAssets.humidity,
            ),
          ),
        ),
      ],
    );
  }
}
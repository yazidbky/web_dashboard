import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/core/DI/dependency_injection.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_status_header.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_metric_card.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/soil_health_score.dart';
import 'package:web_dashboard/features/Soil Status/Presentation/widgets/live_monitor_chart.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmer_data_model.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Logic/soil_data_cubit.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Logic/soil_data_state.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_model.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_cubit.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_state.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_cubit.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_state.dart';

class SoilStatusScreen extends StatefulWidget {
  const SoilStatusScreen({super.key});

  @override
  State<SoilStatusScreen> createState() => _SoilStatusScreenState();
}

class _SoilStatusScreenState extends State<SoilStatusScreen> {
  late SoilDataCubit _soilDataCubit;
  late FarmerLandsCubit _farmerLandsCubit;
  late SoilSectionsCubit _soilSectionsCubit;
  
  // Selected values
  int? selectedFarmerId;
  String selectedFarmerName = '';
  int? selectedLandId;
  String selectedLand = '';
  String selectedArea = ''; // This is the "section" in the API
  String selectedDate = 'Today';
  String selectedKPI = 'Soil Moisture';

  // Dynamic options
  List<int> landIds = [];
  List<String> lands = [];
  List<String> areas = [];

  @override
  void initState() {
    super.initState();
    _soilDataCubit = getIt<SoilDataCubit>();
    _farmerLandsCubit = getIt<FarmerLandsCubit>();
    _soilSectionsCubit = getIt<SoilSectionsCubit>();
  }

  @override
  void dispose() {
    _soilDataCubit.close();
    _farmerLandsCubit.close();
    _soilSectionsCubit.close();
    super.dispose();
  }

  void _fetchSoilData() {
    if (selectedFarmerId != null && selectedLandId != null && selectedArea.isNotEmpty) {
      print('🔄 [SoilStatusScreen] Fetching soil data for farmer: $selectedFarmerId, land: $selectedLandId, section: $selectedArea');
      _soilDataCubit.getSoilData(
        farmerId: selectedFarmerId!,
        landId: selectedLandId!,
        section: selectedArea,
      );
    }
  }

  void _fetchFarmerLands(int farmerId) {
    print('🔄 [SoilStatusScreen] Fetching lands for farmer ID: $farmerId');
    _farmerLandsCubit.getFarmerLands(farmerId);
  }

  void _fetchSoilSections(int farmerId, int landId) {
    print('🔄 [SoilStatusScreen] Fetching sections for farmer ID: $farmerId, land ID: $landId');
    _soilSectionsCubit.getAllSoilSections(farmerId, landId);
  }

  String _getLandNameFromId(int landId) {
    return 'Land $landId';
  }

  int? _getLandIdFromName(String landName) {
    // Extract number from "Land X" format
    final match = RegExp(r'Land (\d+)').firstMatch(landName);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample chart data
    final chartData = [8.0, 12.0, 15.0, 18.0, 22.0, 25.0, 28.0, 32.0, 35.0, 38.0, 40.0, 42.0];
    final chartLabels = ['11h', '10h', '9h', '8h', '7h', '6h', '5h', '4h', '3h', '2h', '1h', 'now'];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _soilDataCubit),
        BlocProvider.value(value: _farmerLandsCubit),
        BlocProvider.value(value: _soilSectionsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // Listen for lands fetched
          BlocListener<FarmerLandsCubit, FarmerLandsState>(
            listener: (context, state) {
              if (state is FarmerLandsSuccess) {
                print('✅ [SoilStatusScreen] Lands fetched: ${state.landIds}');
                setState(() {
                  landIds = state.landIds;
                  lands = state.landIds.map((id) => _getLandNameFromId(id)).toList();
                  
                  // Auto-select first land if available
                  if (lands.isNotEmpty && selectedLand.isEmpty) {
                    selectedLand = lands.first;
                    selectedLandId = landIds.first;
                    // Fetch sections for this land
                    if (selectedFarmerId != null) {
                      _fetchSoilSections(selectedFarmerId!, selectedLandId!);
                    }
                  }
                });
              } else if (state is FarmerLandsFailure) {
                print('❌ [SoilStatusScreen] Failed to fetch lands: ${state.failureMessage}');
                setState(() {
                  lands = [];
                  landIds = [];
                  selectedLand = '';
                  selectedLandId = null;
                });
              }
            },
          ),
          // Listen for sections fetched
          BlocListener<SoilSectionsCubit, SoilSectionsState>(
            listener: (context, state) {
              if (state is SoilSectionsSuccess) {
                print('✅ [SoilStatusScreen] Sections fetched: ${state.sections}');
                setState(() {
                  areas = state.sections;
                  
                  // Auto-select first section if available
                  if (areas.isNotEmpty && selectedArea.isEmpty) {
                    selectedArea = areas.first;
                    // Fetch soil data
                    _fetchSoilData();
                  }
                });
              } else if (state is SoilSectionsFailure) {
                print('❌ [SoilStatusScreen] Failed to fetch sections: ${state.failureMessage}');
                setState(() {
                  areas = [];
                  selectedArea = '';
                });
              }
            },
          ),
        ],
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final userName = userState is UserSuccess ? userState.userData.fullName : 'User';
            return BlocBuilder<MyFarmersCubit, MyFarmersState>(
              builder: (context, farmersState) {
                final farmers = farmersState is MyFarmersSuccess
                    ? farmersState.farmers
                    : <FarmerDataModel>[];
                
                // Set initial farmer if not set and farmers available
                if (farmers.isNotEmpty && selectedFarmerId == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        selectedFarmerId = farmers.first.id;
                        selectedFarmerName = farmers.first.fullName;
                      });
                      // Fetch lands for this farmer
                      _fetchFarmerLands(selectedFarmerId!);
                    }
                  });
                }
                
                return BlocBuilder<SoilDataCubit, SoilDataState>(
                  builder: (context, soilState) {
                    return _buildResponsiveLayout(
                      context,
                      chartData: chartData,
                      chartLabels: chartLabels,
                      userName: userName,
                      farmers: farmers,
                      soilState: soilState,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required List<double> chartData,
    required List<String> chartLabels,
    required String userName,
    required List<FarmerDataModel> farmers,
    required SoilDataState soilState,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(chartData, chartLabels, userName, farmers, soilState);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(chartData, chartLabels, userName, farmers, soilState);
    } else {
      return _buildDesktopLayout(chartData, chartLabels, userName, farmers, soilState);
    }
  }

  Widget _buildMobileLayout(
    List<double> chartData,
    List<String> chartLabels,
    String userName,
    List<FarmerDataModel> farmers,
    SoilDataState soilState,
  ) {
    final soilData = soilState is SoilDataSuccess ? soilState.soilData : null;
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
            builder: (context, landsState) {
              final isLoadingLands = landsState is FarmerLandsLoading;
              final displayLands = isLoadingLands ? ['Loading...'] : lands;
              
              return BlocBuilder<SoilSectionsCubit, SoilSectionsState>(
                builder: (context, sectionsState) {
                  final isLoadingSections = sectionsState is SoilSectionsLoading;
                  final displayAreas = isLoadingSections ? ['Loading...'] : areas;
                  
                  return SoilStatusHeader(
                    userName: userName,
                    selectedFarmer: selectedFarmerName,
                    selectedLand: selectedLand,
                    selectedArea: selectedArea,
                    farmers: farmers.map((f) => f.fullName).toList(),
                    lands: displayLands,
                    areas: displayAreas,
            onFarmerChanged: (value) {
              final farmer = farmers.firstWhere((f) => f.fullName == value);
              print('🔄 [SoilStatusScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
              setState(() {
                selectedFarmerId = farmer.id;
                selectedFarmerName = farmer.fullName;
                // Reset land and area when farmer changes
                selectedLand = '';
                selectedLandId = null;
                selectedArea = '';
                lands = [];
                landIds = [];
                areas = [];
              });
              // Fetch lands for the new farmer
              _fetchFarmerLands(farmer.id);
            },
            onLandChanged: (value) {
              print('🔄 [SoilStatusScreen] Land changed to: $value');
              final landId = _getLandIdFromName(value);
              setState(() {
                selectedLand = value;
                selectedLandId = landId;
                // Reset area when land changes
                selectedArea = '';
                areas = [];
              });
              // Fetch sections for the new land
              if (selectedFarmerId != null && landId != null) {
                _fetchSoilSections(selectedFarmerId!, landId);
              }
            },
                    onAreaChanged: (value) {
                      print('🔄 [SoilStatusScreen] Area (section) changed to: $value');
                      setState(() => selectedArea = value);
                      // Fetch soil data for the selected section
                      _fetchSoilData();
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          if (soilState is SoilDataLoading)
            const Center(child: CircularProgressIndicator())
          else if (soilState is SoilDataFailure)
            Center(
              child: Text(
                soilState.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            )
          else
            _buildMetricCardsMobile(soilData),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          SoilHealthScore(
            score: soilData?.soilHealthScore ?? 0,
            status: soilData?.overallStatus ?? 'N/A',
          ),
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
    List<FarmerDataModel> farmers,
    SoilDataState soilState,
  ) {
    final soilData = soilState is SoilDataSuccess ? soilState.soilData : null;
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
            builder: (context, landsState) {
              final isLoadingLands = landsState is FarmerLandsLoading;
              final displayLands = isLoadingLands ? ['Loading...'] : lands;
              
              return BlocBuilder<SoilSectionsCubit, SoilSectionsState>(
                builder: (context, sectionsState) {
                  final isLoadingSections = sectionsState is SoilSectionsLoading;
                  final displayAreas = isLoadingSections ? ['Loading...'] : areas;
                  
                  return SoilStatusHeader(
                    userName: userName,
                    selectedFarmer: selectedFarmerName,
                    selectedLand: selectedLand,
                    selectedArea: selectedArea,
                    farmers: farmers.map((f) => f.fullName).toList(),
                    lands: displayLands,
                    areas: displayAreas,
            onFarmerChanged: (value) {
              final farmer = farmers.firstWhere((f) => f.fullName == value);
              print('🔄 [SoilStatusScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
              setState(() {
                selectedFarmerId = farmer.id;
                selectedFarmerName = farmer.fullName;
                // Reset land and area when farmer changes
                selectedLand = '';
                selectedLandId = null;
                selectedArea = '';
                lands = [];
                landIds = [];
                areas = [];
              });
              // Fetch lands for the new farmer
              _fetchFarmerLands(farmer.id);
            },
            onLandChanged: (value) {
              print('🔄 [SoilStatusScreen] Land changed to: $value');
              final landId = _getLandIdFromName(value);
              setState(() {
                selectedLand = value;
                selectedLandId = landId;
                // Reset area when land changes
                selectedArea = '';
                areas = [];
              });
              // Fetch sections for the new land
              if (selectedFarmerId != null && landId != null) {
                _fetchSoilSections(selectedFarmerId!, landId);
              }
            },
                    onAreaChanged: (value) {
                      print('🔄 [SoilStatusScreen] Area (section) changed to: $value');
                      setState(() => selectedArea = value);
                      // Fetch soil data for the selected section
                      _fetchSoilData();
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          if (soilState is SoilDataLoading)
            const Center(child: CircularProgressIndicator())
          else if (soilState is SoilDataFailure)
            Center(
              child: Text(
                soilState.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMetricCardsTablet(soilData),
                ),
                SizedBox(width: SizeConfig.scaleWidth(2)),
                Flexible(
                  flex: 1,
                  child: SoilHealthScore(
                    score: soilData?.soilHealthScore ?? 0,
                    status: soilData?.overallStatus ?? 'N/A',
                  ),
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
    List<FarmerDataModel> farmers,
    SoilDataState soilState,
  ) {
    final soilData = soilState is SoilDataSuccess ? soilState.soilData : null;
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 4,
        vertical: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
            builder: (context, landsState) {
              final isLoadingLands = landsState is FarmerLandsLoading;
              final displayLands = isLoadingLands ? ['Loading...'] : lands;
              
              return BlocBuilder<SoilSectionsCubit, SoilSectionsState>(
                builder: (context, sectionsState) {
                  final isLoadingSections = sectionsState is SoilSectionsLoading;
                  final displayAreas = isLoadingSections ? ['Loading...'] : areas;
                  
                  return SoilStatusHeader(
                    userName: userName,
                    selectedFarmer: selectedFarmerName,
                    selectedLand: selectedLand,
                    selectedArea: selectedArea,
                    farmers: farmers.map((f) => f.fullName).toList(),
                    lands: displayLands,
                    areas: displayAreas,
            onFarmerChanged: (value) {
              final farmer = farmers.firstWhere((f) => f.fullName == value);
              print('🔄 [SoilStatusScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
              setState(() {
                selectedFarmerId = farmer.id;
                selectedFarmerName = farmer.fullName;
                // Reset land and area when farmer changes
                selectedLand = '';
                selectedLandId = null;
                selectedArea = '';
                lands = [];
                landIds = [];
                areas = [];
              });
              // Fetch lands for the new farmer
              _fetchFarmerLands(farmer.id);
            },
            onLandChanged: (value) {
              print('🔄 [SoilStatusScreen] Land changed to: $value');
              final landId = _getLandIdFromName(value);
              setState(() {
                selectedLand = value;
                selectedLandId = landId;
                // Reset area when land changes
                selectedArea = '';
                areas = [];
              });
              // Fetch sections for the new land
              if (selectedFarmerId != null && landId != null) {
                _fetchSoilSections(selectedFarmerId!, landId);
              }
            },
                    onAreaChanged: (value) {
                      print('🔄 [SoilStatusScreen] Area (section) changed to: $value');
                      setState(() => selectedArea = value);
                      // Fetch soil data for the selected section
                      _fetchSoilData();
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(3)),
          if (soilState is SoilDataLoading)
            const Center(child: CircularProgressIndicator())
          else if (soilState is SoilDataFailure)
            Center(
              child: Text(
                soilState.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMetricCardsDesktop(soilData),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
                Flexible(
                  flex: 1,
                  child: SoilHealthScore(
                    score: soilData?.soilHealthScore ?? 0,
                    status: soilData?.overallStatus ?? 'N/A',
                  ),
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

  Widget _buildMetricCardsMobile(SoilDataModel? soilData) {
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
                  value: '${soilData?.soilMoisture.toStringAsFixed(1) ?? '0'}%',
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
                  value: '${soilData?.soilTemperature.toStringAsFixed(1) ?? '0'} °C',
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
                  value: soilData?.ph.toStringAsFixed(1) ?? '0',
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
                  value: '${soilData?.electricalConductivity.toStringAsFixed(2) ?? '0'} dS/m',
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
                  value: '${soilData?.organicMatter.toStringAsFixed(1) ?? '0'}%',
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
                  title: 'Nitrite',
                  value: '${soilData?.nitrite.toStringAsFixed(2) ?? '0'} mg/L',
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

  Widget _buildMetricCardsTablet(SoilDataModel? soilData) {
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
                  value: '${soilData?.soilMoisture.toStringAsFixed(1) ?? '0'}%',
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
                  value: '${soilData?.soilTemperature.toStringAsFixed(1) ?? '0'} °C',
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
                  value: soilData?.ph.toStringAsFixed(1) ?? '0',
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
                  value: '${soilData?.electricalConductivity.toStringAsFixed(2) ?? '0'} dS/m',
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
                  value: '${soilData?.organicMatter.toStringAsFixed(1) ?? '0'}%',
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
                  title: 'Nitrite',
                  value: '${soilData?.nitrite.toStringAsFixed(2) ?? '0'} mg/L',
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

  Widget _buildMetricCardsDesktop(SoilDataModel? soilData) {
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
                  value: '${soilData?.soilMoisture.toStringAsFixed(1) ?? '0'}%',
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
                  value: '${soilData?.soilTemperature.toStringAsFixed(1) ?? '0'} °C',
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
                  value: soilData?.ph.toStringAsFixed(1) ?? '0',
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
                  value: '${soilData?.electricalConductivity.toStringAsFixed(2) ?? '0'} dS/m',
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
                  value: '${soilData?.organicMatter.toStringAsFixed(1) ?? '0'}%',
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
                  title: 'Nitrite',
                  value: '${soilData?.nitrite.toStringAsFixed(2) ?? '0'} mg/L',
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

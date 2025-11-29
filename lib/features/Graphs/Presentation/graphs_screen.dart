import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/DI/dependency_injection.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_cubit.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_state.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_cubit.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_state.dart';
import 'package:web_dashboard/features/Graphs/Logic/grafana_graph_cubit.dart';
import 'package:web_dashboard/features/Graphs/Logic/grafana_graph_state.dart';
import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_request_model.dart';
import 'package:web_dashboard/features/Graphs/Presentation/widgets/graphs_header.dart';
import 'package:web_dashboard/features/Graphs/Presentation/widgets/grafana_iframe.dart';

class GraphsScreen extends StatefulWidget {
  const GraphsScreen({super.key});

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  String? selectedFarmer;
  String? selectedLand;
  String? selectedSection;
  String? selectedColumn;
  String? selectedPlotType;
  
  int? selectedFarmerId;
  int? selectedLandId;
  
  // Cubits
  late MyFarmersCubit _myFarmersCubit;
  late FarmerLandsCubit _farmerLandsCubit;
  late SoilSectionsCubit _soilSectionsCubit;
  late GrafanaGraphCubit _grafanaGraphCubit;
  
  // Stream subscriptions
  StreamSubscription<MyFarmersState>? _farmersSubscription;
  StreamSubscription<FarmerLandsState>? _landsSubscription;
  StreamSubscription<SoilSectionsState>? _sectionsSubscription;
  StreamSubscription<GrafanaGraphState>? _graphSubscription;
  
  // Dynamic data
  List<String> farmers = [];
  List<int> farmerIds = [];
  List<String> lands = [];
  List<int> landIds = [];
  List<String> sections = [];
  
  // Available columns and plot types
  final List<String> columns = [
    'sunlight_hours_per_day',
    'temperature',
    'humidity',
    'rainfall',
    'wind_speed',
  ];
  
  final List<String> plotTypes = [
    'time series',
   
   
  ];

  @override
  void initState() {
    super.initState();
    _myFarmersCubit = getIt<MyFarmersCubit>();
    _farmerLandsCubit = getIt<FarmerLandsCubit>();
    _soilSectionsCubit = getIt<SoilSectionsCubit>();
    _grafanaGraphCubit = getIt<GrafanaGraphCubit>();
    
    // Initialize with default values
    selectedColumn = columns.first;
    selectedPlotType = plotTypes.first;
    
    // Fetch farmers on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _myFarmersCubit.getMyFarmers();
    });
    
    // Listen to farmers state
    _farmersSubscription = _myFarmersCubit.stream.listen((state) {
      if (state is MyFarmersSuccess) {
        setState(() {
          farmers = state.farmers.map((f) => f.fullName).toList();
          farmerIds = state.farmers.map((f) => f.id).toList();
        });
      }
    });
    
    // Listen to lands state
    _landsSubscription = _farmerLandsCubit.stream.listen((state) {
      if (state is FarmerLandsSuccess) {
        setState(() {
          landIds = state.landIds;
          lands = state.landIds.map((id) => 'Land $id').toList();
        });
      } else if (state is FarmerLandsFailure) {
        setState(() {
          lands = [];
          landIds = [];
        });
      }
    });
    
    // Listen to sections state
    _sectionsSubscription = _soilSectionsCubit.stream.listen((state) {
      if (state is SoilSectionsSuccess) {
        setState(() {
          sections = state.sections;
        });
      } else if (state is SoilSectionsFailure) {
        setState(() {
          sections = [];
        });
      }
    });
    
    // Listen to graph state
    _graphSubscription = _grafanaGraphCubit.stream.listen((state) {
      if (state is GrafanaGraphSuccess) {
        print('✅ [GraphsScreen] Graph URL fetched successfully!');
      } else if (state is GrafanaGraphFailure) {
        print('❌ [GraphsScreen] Failed to fetch graph URL: ${state.failureMessage}');
      }
    });
  }

  @override
  void dispose() {
    _farmersSubscription?.cancel();
    _landsSubscription?.cancel();
    _sectionsSubscription?.cancel();
    _graphSubscription?.cancel();
    _myFarmersCubit.close();
    _farmerLandsCubit.close();
    _soilSectionsCubit.close();
    _grafanaGraphCubit.close();
    super.dispose();
  }

  void _onFarmerChanged(String? farmerName) {
    if (farmerName == null) return;
    
    setState(() {
      selectedFarmer = farmerName;
      final index = farmers.indexOf(farmerName);
      if (index >= 0 && index < farmerIds.length) {
        selectedFarmerId = farmerIds[index];
      }
      // Reset dependent selections
      selectedLand = null;
      selectedLandId = null;
      selectedSection = null;
      lands = [];
      landIds = [];
      sections = [];
    });
    
    if (selectedFarmerId != null) {
      print('🔄 [GraphsScreen] Fetching lands for farmer ID: $selectedFarmerId');
      _farmerLandsCubit.getFarmerLands(selectedFarmerId!);
    }
  }

  void _onLandChanged(String? landName) {
    if (landName == null) return;
    
    setState(() {
      selectedLand = landName;
      final index = lands.indexOf(landName);
      if (index >= 0 && index < landIds.length) {
        selectedLandId = landIds[index];
      }
      // Reset sections
      selectedSection = null;
      sections = [];
    });
    
    if (selectedFarmerId != null && selectedLandId != null) {
      print('🔄 [GraphsScreen] Fetching sections for farmer ID: $selectedFarmerId, land ID: $selectedLandId');
      _soilSectionsCubit.getAllSoilSections(selectedFarmerId!, selectedLandId!);
    }
    
    // Fetch graph when land is selected
    _fetchGraph();
  }

  void _onSectionChanged(String? section) {
    setState(() {
      selectedSection = section;
    });
    _fetchGraph();
  }

  void _onColumnChanged(String? column) {
    setState(() {
      selectedColumn = column;
    });
    _fetchGraph();
  }

  void _onPlotTypeChanged(String? plotType) {
    setState(() {
      selectedPlotType = plotType;
    });
    _fetchGraph();
  }

  String _getTableFromColumn(String column) {
    // Determine table based on column name
    final weatherColumns = [
      'sunlight_hours_per_day',
      'temperature',
      'humidity',
      'rainfall',
      'wind_speed',
    ];
    
    if (weatherColumns.contains(column)) {
      return 'weathers';
    } else {
      // Default to soils for soil-related columns
      return 'section_soils';
    }
  }

  void _fetchGraph() {
    if (selectedFarmerId == null || selectedLandId == null || selectedColumn == null || selectedPlotType == null) {
      print('⚠️ [GraphsScreen] Missing required parameters for graph request');
      return;
    }
    
    print('🔄 [GraphsScreen] Fetching Grafana graph URL...');
    print('📋 [GraphsScreen] Farmer ID: $selectedFarmerId');
    print('📋 [GraphsScreen] Land ID: $selectedLandId');
    print('📋 [GraphsScreen] Column: $selectedColumn');
    print('📋 [GraphsScreen] Plot Type: $selectedPlotType');
    print('📋 [GraphsScreen] Section ID: ${selectedSection ?? "N/A"}');
    
    final tables = _getTableFromColumn(selectedColumn!);
    print('📋 [GraphsScreen] Tables: $tables');
    
    final request = GrafanaGraphRequestModel(
      farmerId: selectedFarmerId!,
      landId: selectedLandId!,
      column: selectedColumn!,
      plotType: selectedPlotType!,
      tables: tables,
      sectionId: selectedSection,
    );
    
    _grafanaGraphCubit.getGrafanaGraphUrl(request);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _myFarmersCubit),
        BlocProvider.value(value: _farmerLandsCubit),
        BlocProvider.value(value: _soilSectionsCubit),
        BlocProvider.value(value: _grafanaGraphCubit),
      ],
      child: BlocBuilder<GrafanaGraphCubit, GrafanaGraphState>(
        builder: (context, graphState) {
          return _buildResponsiveLayout(graphState);
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(GrafanaGraphState graphState) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(graphState);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(graphState);
    } else {
      return _buildDesktopLayout(graphState);
    }
  }

  Widget _buildMobileLayout(GrafanaGraphState graphState) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GraphsHeader(
            farmers: farmers,
            selectedFarmer: selectedFarmer,
            onFarmerChanged: _onFarmerChanged,
            lands: lands,
            selectedLand: selectedLand,
            onLandChanged: _onLandChanged,
            sections: sections,
            selectedSection: selectedSection,
            onSectionChanged: _onSectionChanged,
            columns: columns,
            selectedColumn: selectedColumn,
            onColumnChanged: _onColumnChanged,
            plotTypes: plotTypes,
            selectedPlotType: selectedPlotType,
            onPlotTypeChanged: _onPlotTypeChanged,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildGraphContainer(graphState),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(GrafanaGraphState graphState) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GraphsHeader(
            farmers: farmers,
            selectedFarmer: selectedFarmer,
            onFarmerChanged: _onFarmerChanged,
            lands: lands,
            selectedLand: selectedLand,
            onLandChanged: _onLandChanged,
            sections: sections,
            selectedSection: selectedSection,
            onSectionChanged: _onSectionChanged,
            columns: columns,
            selectedColumn: selectedColumn,
            onColumnChanged: _onColumnChanged,
            plotTypes: plotTypes,
            selectedPlotType: selectedPlotType,
            onPlotTypeChanged: _onPlotTypeChanged,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          _buildGraphContainer(graphState),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(GrafanaGraphState graphState) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GraphsHeader(
            farmers: farmers,
            selectedFarmer: selectedFarmer,
            onFarmerChanged: _onFarmerChanged,
            lands: lands,
            selectedLand: selectedLand,
            onLandChanged: _onLandChanged,
            sections: sections,
            selectedSection: selectedSection,
            onSectionChanged: _onSectionChanged,
            columns: columns,
            selectedColumn: selectedColumn,
            onColumnChanged: _onColumnChanged,
            plotTypes: plotTypes,
            selectedPlotType: selectedPlotType,
            onPlotTypeChanged: _onPlotTypeChanged,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          _buildGraphContainer(graphState),
        ],
      ),
    );
  }

  Widget _buildGraphContainer(GrafanaGraphState graphState) {
    if (graphState is GrafanaGraphLoading) {
      return Container(
        height: SizeConfig.scaleHeight(60),
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
              const CircularProgressIndicator(),
              SizedBox(height: SizeConfig.scaleHeight(2)),
              Text(
                'Loading graph...',
                style: TextStyle(
                  fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (graphState is GrafanaGraphFailure) {
      return Container(
        height: SizeConfig.scaleHeight(60),
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
                Icons.error_outline,
                size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
                color: AppColors.error,
              ),
              SizedBox(height: SizeConfig.scaleHeight(2)),
              Text(
                graphState.failureMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(2)),
              ElevatedButton(
                onPressed: _fetchGraph,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (graphState is GrafanaGraphSuccess) {
      return Container(
        height: SizeConfig.scaleHeight(60),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
          ),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            SizeConfig.getResponsiveBorderRadius(mobile: 2, tablet: 2.5, desktop: 3),
          ),
          child: GrafanaIframe(
            key: ValueKey(graphState.data.iframeUrl),
            url: graphState.data.iframeUrl,
          ),
        ),
      );
    }

    // Initial state - show placeholder
    return Container(
      height: SizeConfig.scaleHeight(60),
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
              Icons.bar_chart,
              size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
              color: AppColors.grey400,
            ),
            SizedBox(height: SizeConfig.scaleHeight(2)),
            Text(
              'Select a farmer, land, column, and plot type to view the graph',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


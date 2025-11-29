import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/core/DI/dependency_injection.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_header.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_status_card.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/farming_optimality_gauge.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_data_table.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmer_data_model.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_cubit.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_state.dart';
import 'package:web_dashboard/features/Recommendation/Logic/recommendation_cubit.dart';
import 'package:web_dashboard/features/Recommendation/Logic/recommendation_state.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  String? selectedFarmer;
  int? selectedFarmerId;
  int? selectedLandId;
  final ScrollController _tableScrollController = ScrollController();
  
  // Cubits
  late FarmerLandsCubit _farmerLandsCubit;
  late RecommendationCubit _recommendationCubit;
  
  // Dynamic data
  List<int> landIds = [];

  @override
  void initState() {
    super.initState();
    _farmerLandsCubit = getIt<FarmerLandsCubit>();
    _recommendationCubit = getIt<RecommendationCubit>();
  }

  @override
  void dispose() {
    _tableScrollController.dispose();
    _farmerLandsCubit.close();
    _recommendationCubit.close();
    super.dispose();
  }

  void _fetchFarmerLands(int farmerId) {
    print('🔄 [CropScreen] Fetching lands for farmer ID: $farmerId');
    _farmerLandsCubit.getFarmerLands(farmerId);
  }

  void _fetchRecommendations(int farmerId, int landId) {
    print('🔄 [CropScreen] Fetching recommendations for farmer ID: $farmerId, land ID: $landId');
    _recommendationCubit.getCropRecommendations(
      farmerId: farmerId,
      landId: landId,
    );
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Sample crop data
    final crops = [
      CropData(
        season: 'taha laib',
        cropType: 'Rice',
        soilMoisture: 6.2,
        location: 'Msila',
        weatherImpact: WeatherImpact.bad,
      ),
      CropData(
        season: 'yazid bakai',
        cropType: 'Wheat',
        soilMoisture: 2.3,
        location: 'setif',
        weatherImpact: WeatherImpact.great,
      ),
      CropData(
        season: 'Chaba heytem',
        cropType: 'Wheat',
        soilMoisture: 3.5,
        location: 'bouira',
        weatherImpact: WeatherImpact.medium,
      ),
      CropData(
        season: 'taha laib',
        cropType: 'Rice',
        soilMoisture: 5.8,
        location: 'alger',
        weatherImpact: WeatherImpact.bad,
      ),
      CropData(
        season: 'yazid bakai',
        cropType: 'Wheat',
        soilMoisture: 4.1,
        location: 'biskra',
        weatherImpact: WeatherImpact.great,
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _farmerLandsCubit),
        BlocProvider.value(value: _recommendationCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // Listen for lands fetched
          BlocListener<FarmerLandsCubit, FarmerLandsState>(
            listener: (context, state) {
              if (state is FarmerLandsSuccess) {
                print('✅ [CropScreen] Lands fetched: ${state.landIds}');
                setState(() {
                  landIds = state.landIds;
                  
                  // Auto-select first land if available
                  if (landIds.isNotEmpty && selectedLandId == null) {
                    selectedLandId = landIds.first;
                    // Fetch recommendations for this land
                    if (selectedFarmerId != null) {
                      _fetchRecommendations(selectedFarmerId!, selectedLandId!);
                    }
                  }
                });
              } else if (state is FarmerLandsFailure) {
                print('❌ [CropScreen] Failed to fetch lands: ${state.failureMessage}');
                setState(() {
                  landIds = [];
                  selectedLandId = null;
                });
              }
            },
          ),
          // Listen for recommendation state changes
          BlocListener<RecommendationCubit, RecommendationState>(
            listener: (context, state) {
              if (state is RecommendationSuccess) {
                print('✅ [CropScreen] Recommendations fetched successfully');
                print('📊 [CropScreen] Number of recommendations: ${state.recommendationData.recommendations.length}');
                if (state.recommendationData.recommendations.isNotEmpty) {
                  final first = state.recommendationData.recommendations.first;
                  print('📊 [CropScreen] First recommendation - Crop: ${first.cropName}, Similarity: ${first.similarityPercentage}%');
                } else {
                  print('⚠️ [CropScreen] Recommendations list is empty!');
                }
              } else if (state is RecommendationFailure) {
                print('❌ [CropScreen] Failed to fetch recommendations: ${state.failureMessage}');
              } else if (state is RecommendationLoading) {
                print('🔄 [CropScreen] Loading recommendations...');
              } else {
                print('ℹ️ [CropScreen] Recommendation state: ${state.runtimeType}');
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
                        selectedFarmer = farmers.first.fullName;
                      });
                      // Fetch lands for this farmer
                      _fetchFarmerLands(selectedFarmerId!);
                    }
                  });
                }
                
                return BlocBuilder<RecommendationCubit, RecommendationState>(
                  builder: (context, recommendationState) {
                    return _buildResponsiveLayout(
                      context,
                      crops: crops,
                      userName: userName,
                      farmers: farmers,
                      recommendationState: recommendationState,
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
    required List<CropData> crops,
    required String userName,
    required List<FarmerDataModel> farmers,
    required RecommendationState recommendationState,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(crops, userName, farmers, recommendationState);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(crops, userName, farmers, recommendationState);
    } else {
      return _buildDesktopLayout(crops, userName, farmers, recommendationState);
    }
  }

  Widget _buildMobileLayout(
    List<CropData> crops,
    String userName,
    List<FarmerDataModel> farmers,
    RecommendationState recommendationState,
  ) {
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
              return CropHeader(
                userName: userName,
                selectedFarmer: selectedFarmer ?? '',
                farmers: farmers.map((f) => f.fullName).toList(),
                onFarmerChanged: (value) {
                  final farmer = farmers.firstWhere((f) => f.fullName == value);
                  print('🔄 [CropScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
                  setState(() {
                    selectedFarmerId = farmer.id;
                    selectedFarmer = farmer.fullName;
                    selectedLandId = null;
                    landIds = [];
                  });
                  // Reset recommendation state
                  _recommendationCubit.reset();
                  // Fetch lands for the new farmer
                  _fetchFarmerLands(farmer.id);
                },
              );
            },
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            'Crop Status',
            fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildCropStatusCardsMobile(recommendationState),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CropDataTable(
            crops: crops,
            scrollController: _tableScrollController,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    List<CropData> crops,
    String userName,
    List<FarmerDataModel> farmers,
    RecommendationState recommendationState,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: SizeConfig.scalePadding(
            horizontal: 3,
            vertical: 2.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
                builder: (context, landsState) {
                  return CropHeader(
                    userName: userName,
                    selectedFarmer: selectedFarmer ?? '',
                    farmers: farmers.map((f) => f.fullName).toList(),
                    onFarmerChanged: (value) {
                      final farmer = farmers.firstWhere((f) => f.fullName == value);
                      print('🔄 [CropScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
                      setState(() {
                        selectedFarmerId = farmer.id;
                        selectedFarmer = farmer.fullName;
                        selectedLandId = null;
                        landIds = [];
                      });
                      // Reset recommendation state
                      _recommendationCubit.reset();
                      // Fetch lands for the new farmer
                      _fetchFarmerLands(farmer.id);
                    },
                  );
                },
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              CustomText(
                'Crop Status',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              _buildCropStatusCardsTablet(recommendationState),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight > 0 
                      ? constraints.maxHeight * 0.5 
                      : SizeConfig.scaleHeight(50),
                ),
                child: CropDataTable(
                  crops: crops,
                  scrollController: _tableScrollController,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    List<CropData> crops,
    String userName,
    List<FarmerDataModel> farmers,
    RecommendationState recommendationState,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: SizeConfig.scalePadding(
            horizontal: 4,
            vertical: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<FarmerLandsCubit, FarmerLandsState>(
                builder: (context, landsState) {
                  return CropHeader(
                    userName: userName,
                    selectedFarmer: selectedFarmer ?? '',
                    farmers: farmers.map((f) => f.fullName).toList(),
                    onFarmerChanged: (value) {
                      final farmer = farmers.firstWhere((f) => f.fullName == value);
                      print('🔄 [CropScreen] Farmer changed to: ${farmer.fullName} (ID: ${farmer.id})');
                      setState(() {
                        selectedFarmerId = farmer.id;
                        selectedFarmer = farmer.fullName;
                        selectedLandId = null;
                        landIds = [];
                      });
                      // Reset recommendation state
                      _recommendationCubit.reset();
                      // Fetch lands for the new farmer
                      _fetchFarmerLands(farmer.id);
                    },
                  );
                },
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              CustomText(
                'Crop Status',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              _buildCropStatusCardsDesktop(recommendationState),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight > 0 
                      ? constraints.maxHeight * 0.5 
                      : SizeConfig.scaleHeight(50),
                ),
                child: CropDataTable(
                  crops: crops,
                  scrollController: _tableScrollController,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCropStatusCardsMobile(RecommendationState recommendationState) {
    // Extract recommendation data
    String currentCropType = 'N/A';
    String recommendedCropType = 'N/A';
    String recommendedCropLabel = 'Next Season';
    double optimalityScore = 0.0;
    
    if (recommendationState is RecommendationLoading) {
      currentCropType = 'Loading...';
      recommendedCropType = 'Loading...';
      recommendedCropLabel = 'Loading...';
    } else if (recommendationState is RecommendationSuccess) {
      final recommendations = recommendationState.recommendationData.recommendations;
      print('📊 [CropScreen] Recommendations received: ${recommendations.length} items');
      
      if (recommendations.isNotEmpty) {
        // Use first recommendation (rank 1) as recommended crop
        final firstRecommendation = recommendations.first;
        print('📊 [CropScreen] First recommendation: cropName="${firstRecommendation.cropName}", cropRecId=${firstRecommendation.cropRecId}, similarity=${firstRecommendation.similarityPercentage}%');
        
        // Use cropName if available, otherwise use cropRecId as fallback
        recommendedCropType = firstRecommendation.cropName.isNotEmpty 
            ? firstRecommendation.cropName 
            : 'Crop #${firstRecommendation.cropRecId}';
        optimalityScore = firstRecommendation.similarityPercentage;
        recommendedCropLabel = '${firstRecommendation.similarityPercentage.toStringAsFixed(1)}% Match';
        // For current crop, we could use the second recommendation or a different source
        // For now, using the first recommendation as fallback
        final secondRecommendation = recommendations.length > 1 ? recommendations[1] : recommendations.first;
        currentCropType = secondRecommendation.cropName.isNotEmpty 
            ? secondRecommendation.cropName 
            : 'Crop #${secondRecommendation.cropRecId}';
      } else {
        print('⚠️ [CropScreen] Recommendations list is empty');
        recommendedCropType = 'No recommendations';
        recommendedCropLabel = 'No data available';
      }
    } else if (recommendationState is RecommendationFailure) {
      print('❌ [CropScreen] Recommendation fetch failed: ${recommendationState.failureMessage}');
      recommendedCropType = 'Error';
      recommendedCropLabel = 'Failed to load';
    } else {
      // RecommendationInitial or unknown state
      print('ℹ️ [CropScreen] Recommendation state: ${recommendationState.runtimeType}');
      if (selectedFarmerId != null && selectedLandId != null) {
        recommendedCropType = 'Select farmer & land';
        recommendedCropLabel = 'Waiting for data';
      }
    }
    
    return Column(
      children: [
        CropStatusCard(
          title: 'current crop type',
          value: currentCropType,
          label: 'Growth Stage',
          icon: AppAssets.leaf,
          backgroundColor: AppColors.weatherPrimary,
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        CropStatusCard(
          title: 'Recomanded crop type',
          value: recommendedCropType,
          label: recommendedCropLabel,
          icon: AppAssets.leaf,
          backgroundColor: AppColors.weatherQuaternary.withOpacity(0.3),
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.scaleHeight(30),
            minHeight: SizeConfig.scaleHeight(25),
          ),
          child: FarmingOptimalityGauge(
            score: optimalityScore,
            label: 'Current',
          ),
        ),
      ],
    );
  }

  Widget _buildCropStatusCardsTablet(RecommendationState recommendationState) {
    // Extract recommendation data
    String currentCropType = 'N/A';
    String recommendedCropType = 'N/A';
    String recommendedCropLabel = 'Next Season';
    double optimalityScore = 0.0;
    
    if (recommendationState is RecommendationLoading) {
      currentCropType = 'Loading...';
      recommendedCropType = 'Loading...';
      recommendedCropLabel = 'Loading...';
    } else if (recommendationState is RecommendationSuccess) {
      final recommendations = recommendationState.recommendationData.recommendations;
      print('📊 [CropScreen] Recommendations received: ${recommendations.length} items');
      
      if (recommendations.isNotEmpty) {
        final firstRecommendation = recommendations.first;
        print('📊 [CropScreen] First recommendation: ${firstRecommendation.cropName}, ${firstRecommendation.similarityPercentage}%');
        
        recommendedCropType = firstRecommendation.cropName;
        optimalityScore = firstRecommendation.similarityPercentage;
        recommendedCropLabel = '${firstRecommendation.similarityPercentage.toStringAsFixed(1)}% Match';
        currentCropType = recommendations.length > 1 
            ? recommendations[1].cropName 
            : recommendations.first.cropName;
      } else {
        print('⚠️ [CropScreen] Recommendations list is empty');
        recommendedCropType = 'No recommendations';
        recommendedCropLabel = 'No data available';
      }
    } else if (recommendationState is RecommendationFailure) {
      print('❌ [CropScreen] Recommendation fetch failed: ${recommendationState.failureMessage}');
      recommendedCropType = 'Error';
      recommendedCropLabel = 'Failed to load';
    } else {
      // RecommendationInitial or unknown state
      print('ℹ️ [CropScreen] Recommendation state: ${recommendationState.runtimeType}');
      if (selectedFarmerId != null && selectedLandId != null) {
        recommendedCropType = 'Select farmer & land';
        recommendedCropLabel = 'Waiting for data';
      }
    }
    
    return Row(
      children: [
        Expanded(
          child: CropStatusCard(
            title: 'current crop type',
            value: currentCropType,
            label: 'Growth Stage',
            icon: AppAssets.leaf,
            backgroundColor: AppColors.weatherPrimary,
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(2)),
        Expanded(
          child: CropStatusCard(
            title: 'Recomanded crop type',
            value: recommendedCropType,
            label: recommendedCropLabel,
            icon: AppAssets.leaf,
            backgroundColor: AppColors.weatherQuaternary.withOpacity(0.3),
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(2)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(35),
              minHeight: SizeConfig.scaleHeight(30),
            ),
            child: FarmingOptimalityGauge(
              score: optimalityScore,
              label: 'Current',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCropStatusCardsDesktop(RecommendationState recommendationState) {
    // Extract recommendation data
    String currentCropType = 'N/A';
    String recommendedCropType = 'N/A';
    String recommendedCropLabel = 'Next Season';
    double optimalityScore = 0.0;
    
    if (recommendationState is RecommendationLoading) {
      currentCropType = 'Loading...';
      recommendedCropType = 'Loading...';
      recommendedCropLabel = 'Loading...';
    } else if (recommendationState is RecommendationSuccess) {
      final recommendations = recommendationState.recommendationData.recommendations;
      print('📊 [CropScreen] Recommendations received: ${recommendations.length} items');
      
      if (recommendations.isNotEmpty) {
        final firstRecommendation = recommendations.first;
        print('📊 [CropScreen] First recommendation: ${firstRecommendation.cropName}, ${firstRecommendation.similarityPercentage}%');
        
        recommendedCropType = firstRecommendation.cropName;
        optimalityScore = firstRecommendation.similarityPercentage;
        recommendedCropLabel = '${firstRecommendation.similarityPercentage.toStringAsFixed(1)}% Match';
        currentCropType = recommendations.length > 1 
            ? recommendations[1].cropName 
            : recommendations.first.cropName;
      } else {
        print('⚠️ [CropScreen] Recommendations list is empty');
        recommendedCropType = 'No recommendations';
        recommendedCropLabel = 'No data available';
      }
    } else if (recommendationState is RecommendationFailure) {
      print('❌ [CropScreen] Recommendation fetch failed: ${recommendationState.failureMessage}');
      recommendedCropType = 'Error';
      recommendedCropLabel = 'Failed to load';
    } else {
      // RecommendationInitial or unknown state
      print('ℹ️ [CropScreen] Recommendation state: ${recommendationState.runtimeType}');
      if (selectedFarmerId != null && selectedLandId != null) {
        recommendedCropType = 'Select farmer & land';
        recommendedCropLabel = 'Waiting for data';
      }
    }
    
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.scaleHeight(25),
              minHeight: SizeConfig.scaleHeight(20),
            ),
            child: CropStatusCard(
              title: 'current crop type',
              value: currentCropType,
              label: 'Growth Stage',
              icon: AppAssets.corn,
              backgroundColor: AppColors.weatherPrimary,
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
            child: CropStatusCard(
              title: 'Recomanded crop type',
              value: recommendedCropType,
              label: recommendedCropLabel,
              icon: AppAssets.corn,
              backgroundColor: AppColors.weatherQuaternary.withOpacity(0.3),
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
            child: FarmingOptimalityGauge(
              score: optimalityScore,
              label: 'Current',
            ),
          ),
        ),
      ],
    );
  }
}


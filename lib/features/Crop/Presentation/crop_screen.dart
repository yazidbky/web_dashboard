import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/constants/app_assets.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_header.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_status_card.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/farming_optimality_gauge.dart';
import 'package:web_dashboard/features/Crop/Presentation/widgets/crop_data_table.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  String selectedFarmer = 'Taha laib';
  final ScrollController _tableScrollController = ScrollController();

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
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
              crops: crops,
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
    required List<CropData> crops,
    required String userName,
    required List<String> farmers,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(crops, userName, farmers);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(crops, userName, farmers);
    } else {
      return _buildDesktopLayout(crops, userName, farmers);
    }
  }

  Widget _buildMobileLayout(List<CropData> crops, String userName, List<String> farmers) {
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CropHeader(
            userName: userName,
            selectedFarmer: selectedFarmer,
            farmers: farmers,
            onFarmerChanged: (value) => setState(() => selectedFarmer = value),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            'Crop Status',
            fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          _buildCropStatusCardsMobile(),
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

  Widget _buildTabletLayout(List<CropData> crops, String userName, List<String> farmers) {
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
              CropHeader(
                userName: userName,
                selectedFarmer: selectedFarmer,
                farmers: farmers,
                onFarmerChanged: (value) => setState(() => selectedFarmer = value),
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              CustomText(
                'Crop Status',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: SizeConfig.scaleHeight(2.5)),
              _buildCropStatusCardsTablet(),
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

  Widget _buildDesktopLayout(List<CropData> crops, String userName, List<String> farmers) {
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
              CropHeader(
                userName: userName,
                selectedFarmer: selectedFarmer,
                farmers: farmers,
                onFarmerChanged: (value) => setState(() => selectedFarmer = value),
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              CustomText(
                'Crop Status',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 20, desktop: 22),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: SizeConfig.scaleHeight(3)),
              _buildCropStatusCardsDesktop(),
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

  Widget _buildCropStatusCardsMobile() {
    return Column(
      children: [
        CropStatusCard(
          title: 'current crop type',
          value: 'Wheat',
          label: 'Growth Stage',
          icon: AppAssets.leaf,
          backgroundColor: AppColors.weatherPrimary,
        ),
        SizedBox(height: SizeConfig.scaleHeight(1.5)),
        CropStatusCard(
          title: 'Recomanded crop type',
          value: 'Corn',
          label: 'Next Season',
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
            score: 74,
            label: 'Current',
          ),
        ),
      ],
    );
  }

  Widget _buildCropStatusCardsTablet() {
    return Row(
      children: [
        Expanded(
          child: CropStatusCard(
            title: 'current crop type',
            value: 'Wheat',
            label: 'Growth Stage',
            icon: AppAssets.leaf,
            backgroundColor: AppColors.weatherPrimary,
          ),
        ),
        SizedBox(width: SizeConfig.scaleWidth(2)),
        Expanded(
          child: CropStatusCard(
            title: 'Recomanded crop type',
            value: 'Corn',
            label: 'Next Season',
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
              score: 74,
              label: 'Current',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCropStatusCardsDesktop() {
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
              value: 'Wheat',
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
              value: 'Corn',
              label: 'Next Season',
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
              score: 74,
              label: 'Current',
            ),
          ),
        ),
      ],
    );
  }
}


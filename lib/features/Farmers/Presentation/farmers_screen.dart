import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/widgets/app_snack_bar.dart';
import 'package:web_dashboard/features/Farmers/Data/Models/farmer_model.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/farmers_header.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/farmers_table.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/farmer_dropdown.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/farmer_summary.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/add_farmer_dialog.dart';
import 'package:web_dashboard/features/Farmers/Presentation/widgets/add_farmer_button.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_state.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';

class FarmersScreen extends StatefulWidget {
  const FarmersScreen({super.key});

  @override
  State<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  String? _selectedFarmer;
  FarmerTableData? _selectedFarmerData;

  @override
  void initState() {
    super.initState();
    // Fetch farmers when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyFarmersCubit>().getMyFarmers();
    });
  }

  void _handleAddFarmer() async {
    final result = await AddFarmerDialog.show(context);
    
    if (result != null && mounted) {
      // TODO: Implement API call to add farmer
      // For now, just show success message and refresh the list
      showAppSnackBar(
        context: context,
        message: 'Farmer "${result['farmerName']}" added successfully',
        icon: Icons.check_circle,
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        behavior: SnackBarBehavior.floating,
      );
      
      // Refresh farmers list
      context.read<MyFarmersCubit>().getMyFarmers();
    }
  }

  void _handleFarmerSelected(FarmerTableData farmer) {
    setState(() {
      _selectedFarmerData = farmer;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final userName = state is UserSuccess ? state.userData.fullName : 'admin';
        
        return BlocBuilder<MyFarmersCubit, MyFarmersState>(
          builder: (context, farmersState) {
            return _buildResponsiveLayout(
              context,
              userName: userName,
              farmersState: farmersState,
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context, {
    required String userName,
    required MyFarmersState farmersState,
  }) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(userName, farmersState);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(userName, farmersState);
    } else {
      return _buildDesktopLayout(userName, farmersState);
    }
  }

  List<FarmerTableData> _getFarmersFromState(MyFarmersState state) {
    if (state is MyFarmersSuccess) {
      return state.farmers.map((farmer) => 
        FarmerTableData.fromFarmerDataModel(farmer)
      ).toList();
    }
    return [];
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            'Loading farmers...',
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
            onPressed: () => context.read<MyFarmersCubit>().getMyFarmers(),
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

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: SizeConfig.responsive(mobile: 48, tablet: 56, desktop: 64),
            color: AppColors.grey400,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          CustomText(
            'No farmers found',
            fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
            color: AppColors.grey600,
          ),
          SizedBox(height: SizeConfig.scaleHeight(1)),
          CustomText(
            'Add your first farmer to get started',
            fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(String userName, MyFarmersState farmersState) {
    final farmers = _getFarmersFromState(farmersState);
    final farmerNames = farmers.map((f) => f.farmerName).toSet().toList();
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 2,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FarmersHeader(userName: userName),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          
          // Dropdown and Add button row
          Row(
            children: [
              Expanded(
                child: FarmerDropdown(
                  label: 'Select farmer',
                  subText: _selectedFarmer != null ? '$_selectedFarmer Soil status' : null,
                  selectedValue: _selectedFarmer,
                  items: farmerNames,
                  onChanged: (value) {
                    setState(() {
                      _selectedFarmer = value;
                    });
                  },
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(2)),
              AddFarmerButton(onPressed: _handleAddFarmer),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          
          // Content based on state
          if (farmersState is MyFarmersLoading)
            SizedBox(
              height: SizeConfig.scaleHeight(30),
              child: _buildLoadingWidget(),
            )
          else if (farmersState is MyFarmersFailure)
            SizedBox(
              height: SizeConfig.scaleHeight(30),
              child: _buildErrorWidget(farmersState.failureMessage),
            )
          else if (farmers.isEmpty)
            SizedBox(
              height: SizeConfig.scaleHeight(30),
              child: _buildEmptyWidget(),
            )
          else ...[
            // Farmers table
            FarmersTable(
              farmers: farmers,
              onFarmerSelected: _handleFarmerSelected,
            ),
            SizedBox(height: SizeConfig.scaleHeight(2)),
            
            // Farmer summary
            SizedBox(
              height: SizeConfig.scaleHeight(30),
              child: FarmerSummary(selectedFarmer: _selectedFarmerData),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabletLayout(String userName, MyFarmersState farmersState) {
    final farmers = _getFarmersFromState(farmersState);
    final farmerNames = farmers.map((f) => f.farmerName).toSet().toList();
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FarmersHeader(userName: userName),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          
          // Dropdown and Add button row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: FarmerDropdown(
                  label: 'Select farmer',
                  subText: _selectedFarmer != null ? '$_selectedFarmer Soil status' : null,
                  selectedValue: _selectedFarmer,
                  items: farmerNames,
                  onChanged: (value) {
                    setState(() {
                      _selectedFarmer = value;
                    });
                  },
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(3)),
              AddFarmerButton(onPressed: _handleAddFarmer),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          
          // Content based on state
          if (farmersState is MyFarmersLoading)
            SizedBox(
              height: SizeConfig.scaleHeight(40),
              child: _buildLoadingWidget(),
            )
          else if (farmersState is MyFarmersFailure)
            SizedBox(
              height: SizeConfig.scaleHeight(40),
              child: _buildErrorWidget(farmersState.failureMessage),
            )
          else if (farmers.isEmpty)
            SizedBox(
              height: SizeConfig.scaleHeight(40),
              child: _buildEmptyWidget(),
            )
          else
            // Main content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table
                Expanded(
                  flex: 2,
                  child: FarmersTable(
                    farmers: farmers,
                    onFarmerSelected: _handleFarmerSelected,
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
                // Summary
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: SizeConfig.scaleHeight(40),
                    child: FarmerSummary(selectedFarmer: _selectedFarmerData),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(String userName, MyFarmersState farmersState) {
    final farmers = _getFarmersFromState(farmersState);
    final farmerNames = farmers.map((f) => f.farmerName).toSet().toList();
    
    return SingleChildScrollView(
      padding: SizeConfig.scalePadding(
        horizontal: 3,
        vertical: 2.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with profile and add button on same line
          _buildDesktopHeader(userName),
          SizedBox(height: SizeConfig.scaleHeight(1.5)),
          
          // Dropdown section
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
            ),
            child: SizedBox(
              width: SizeConfig.scaleWidth(25),
              child: FarmerDropdown(
                label: 'Select farmer',
                subText: _selectedFarmer != null ? '$_selectedFarmer Soil status' : null,
                selectedValue: _selectedFarmer,
                items: farmerNames,
                onChanged: (value) {
                  setState(() {
                    _selectedFarmer = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2.5)),
          
          // Content based on state
          if (farmersState is MyFarmersLoading)
            SizedBox(
              height: SizeConfig.scaleHeight(50),
              child: _buildLoadingWidget(),
            )
          else if (farmersState is MyFarmersFailure)
            SizedBox(
              height: SizeConfig.scaleHeight(50),
              child: _buildErrorWidget(farmersState.failureMessage),
            )
          else if (farmers.isEmpty)
            SizedBox(
              height: SizeConfig.scaleHeight(50),
              child: _buildEmptyWidget(),
            )
          else
            // Main content row - Table and Summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table
                Expanded(
                  flex: 2,
                  child: FarmersTable(
                    farmers: farmers,
                    onFarmerSelected: _handleFarmerSelected,
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(3)),
                // Summary
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: SizeConfig.scaleHeight(50),
                    child: FarmerSummary(selectedFarmer: _selectedFarmerData),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopHeader(String userName) {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final formattedDate = '${now.day} ${months[now.month - 1]}, ${now.year}';
    
    return Container(
      padding: SizeConfig.scalePadding(
        horizontal: SizeConfig.responsive(mobile: 3, tablet: 4, desktop: 5),
        vertical: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Date and Welcome
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                formattedDate,
                fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                fontWeight: FontWeight.w500,
                color: AppColors.grey600,
              ),
              SizedBox(height: SizeConfig.scaleHeight(0.3)),
              CustomText(
                'welcome back, $userName',
                fontSize: SizeConfig.responsive(mobile: 18, tablet: 22, desktop: 24),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ],
          ),
          
          // Right side - Profile on top, Add button below
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // User profile row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: SizeConfig.scaleWidth(5),
                    height: SizeConfig.scaleWidth(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: SizeConfig.scaleWidth(3),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(1)),
                  CustomText(
                    userName,
                    fontSize: SizeConfig.responsive(mobile: 14, tablet: 16, desktop: 18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.scaleHeight(1.5)),
              // Add farmer button below profile
              AddFarmerButton(onPressed: _handleAddFarmer),
            ],
          ),
        ],
      ),
    );
  }
}

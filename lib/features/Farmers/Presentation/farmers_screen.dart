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

class FarmersScreen extends StatefulWidget {
  const FarmersScreen({super.key});

  @override
  State<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  String? _selectedFarmer;
  FarmerTableData? _selectedFarmerData;
  
  // Sample data - replace with actual data from API
  List<FarmerTableData> _farmers = [
    FarmerTableData(id: '1', farmerName: 'taha laib', cropType: 'Corn', lastActivity: '11/10/2025'),
    FarmerTableData(id: '2', farmerName: 'taha laib', cropType: 'Wheat', lastActivity: '11/10/2025'),
    FarmerTableData(id: '3', farmerName: 'taha laib', cropType: 'Soybean', lastActivity: '11/10/2025'),
    FarmerTableData(id: '4', farmerName: 'taha laib', cropType: 'Potato', lastActivity: '11/10/2025'),
    FarmerTableData(id: '5', farmerName: 'taha laib', cropType: 'Barley', lastActivity: '11/10/2025'),
    FarmerTableData(id: '6', farmerName: 'taha laib', cropType: 'Barley', lastActivity: '11/10/2025'),
    FarmerTableData(id: '7', farmerName: 'taha laib', cropType: 'Barley', lastActivity: '11/10/2025'),
    FarmerTableData(id: '8', farmerName: 'taha laib', cropType: 'Barley', lastActivity: '11/10/2025'),
    FarmerTableData(id: '9', farmerName: 'taha laib', cropType: 'Barley', lastActivity: '11/10/2025'),
  ];

  void _handleAddFarmer() async {
    final result = await AddFarmerDialog.show(context);
    
    if (result != null && mounted) {
      final now = DateTime.now();
      final formattedDate = '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
      final newFarmer = FarmerTableData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        farmerName: result['farmerName']!,
        cropType: result['cropType']!,
        lastActivity: formattedDate,
      );
      
      setState(() {
        _farmers = [..._farmers, newFarmer];
      });
      
      showAppSnackBar(
        context: context,
        message: 'Farmer "${result['farmerName']}" added successfully',
        icon: Icons.check_circle,
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        behavior: SnackBarBehavior.floating,
      );
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
        
        return _buildResponsiveLayout(
          context,
          userName: userName,
        );
      },
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, {required String userName}) {
    if (SizeConfig.isMobile) {
      return _buildMobileLayout(userName);
    } else if (SizeConfig.isTablet) {
      return _buildTabletLayout(userName);
    } else {
      return _buildDesktopLayout(userName);
    }
  }

  Widget _buildMobileLayout(String userName) {
    final farmerNames = _farmers.map((f) => f.farmerName).toSet().toList();
    
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
          
          // Farmers table
          FarmersTable(
            farmers: _farmers,
            onFarmerSelected: _handleFarmerSelected,
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          
          // Farmer summary
          SizedBox(
            height: SizeConfig.scaleHeight(30),
            child: FarmerSummary(selectedFarmer: _selectedFarmerData),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(String userName) {
    final farmerNames = _farmers.map((f) => f.farmerName).toSet().toList();
    
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
          
          // Main content row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table
              Expanded(
                flex: 2,
                child: FarmersTable(
                  farmers: _farmers,
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

  Widget _buildDesktopLayout(String userName) {
    final farmerNames = _farmers.map((f) => f.farmerName).toSet().toList();
    
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
          
          // Main content row - Table and Summary
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table
              Expanded(
                flex: 2,
                child: FarmersTable(
                  farmers: _farmers,
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

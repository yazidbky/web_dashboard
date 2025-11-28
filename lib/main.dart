import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Crop/Presentation/crop_screen.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/dashboard_screen.dart';
import 'package:web_dashboard/features/Farmers/Presentation/farmers_screen.dart';
import 'package:web_dashboard/features/Soil%20Status/Presentation/soil_status_screen.dart';
import 'package:web_dashboard/features/Weather/Presentation/weather_screen.dart';
import 'package:web_dashboard/features/Home/side_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSense Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      builder: (context, child) {
        SizeConfig.init(context);
        return child ?? const SizedBox();
      },
      initialRoute: '/dashboard',
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return _getRouteWidget(settings.name ?? '/dashboard');
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }

  static Widget _buildWithSidebar(Widget child, String route) {
    return Builder(
      builder: (context) {
        SizeConfig.init(context);
        
        if (SizeConfig.isMobile) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            drawer: SideBar(
              currentRoute: route,
              onRouteChanged: (newRoute) {
                Navigator.pushReplacementNamed(
                  context,
                  newRoute,
                );
              },
            ),
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            body: child,
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Row(
                children: [
                  SideBar(
                    currentRoute: route,
                    onRouteChanged: (newRoute) {
                      Navigator.pushReplacementNamed(
                        context,
                        newRoute,
                      );
                    },
                  ),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  static Widget _getRouteWidget(String route) {
    switch (route) {
      case '/dashboard':
        return _buildWithSidebar(const DashboardScreen(), '/dashboard');
      case '/farmers':
        return _buildWithSidebar(const FarmersScreen(), '/farmers');
      case '/soil-status':
        return _buildWithSidebar(const SoilStatusScreen(), '/soil-status');
      case '/weather':
        return _buildWithSidebar(const WeatherScreen(), '/weather');
      case '/crop':
        return _buildWithSidebar(const CropScreen(), '/crop');
      default:
        return _buildWithSidebar(const DashboardScreen(), '/dashboard');
    }
  }
}



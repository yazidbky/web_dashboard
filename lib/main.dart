import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_dashboard/features/Weather/Presentation/weather_screen.dart';
import 'package:web_dashboard/firebase_options.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/core/DI/dependency_injection.dart';
import 'package:web_dashboard/core/services/fcm_service.dart';
import 'package:web_dashboard/features/Auth/Presentation/login_screen.dart';
import 'package:web_dashboard/features/Auth/Logic/login_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/Notifications/Logic/notification_cubit.dart';
import 'package:web_dashboard/features/Crop/Presentation/crop_screen.dart';
import 'package:web_dashboard/features/Dashboard/Presentation/dashboard_screen.dart';
import 'package:web_dashboard/features/Farmers/Presentation/farmers_screen.dart';
import 'package:web_dashboard/features/Soil%20Status/Presentation/soil_status_screen.dart';
import 'package:web_dashboard/features/Weather/Presentation/weather_screen.dart';
import 'package:web_dashboard/features/Home/side_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection first
  setupDependencyInjection();
  
  // Initialize Firebase (optional - skip if not configured)
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    print('✅ Firebase initialized successfully');
    
    // Initialize FCM Service only if Firebase is initialized
    await getIt<FCMService>().initialize();
  } catch (e) {
    print('⚠️ Firebase not configured: $e');
    print('📝 Run "flutterfire configure" to setup Firebase');
  }
  
  runApp(MyApp(firebaseInitialized: firebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;
  
  const MyApp({super.key, this.firebaseInitialized = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>()..getUserProfile(),
        ),
        BlocProvider(
          create: (context) => getIt<MyFarmersCubit>()..getMyFarmers(),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'AgriSense Dashboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        builder: (context, child) {
          SizeConfig.init(context);
          return child ?? const SizedBox();
        },
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) {
              return _getRouteWidget(settings.name ?? '/login');
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        },
        debugShowCheckedModeBanner: false,
      ),
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
      case '/login':
        return const LoginScreen();
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
        return const LoginScreen();
    }
  }
}



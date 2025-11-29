import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/core/Database/dio_consumer.dart';
import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/services/fcm_service.dart';
import 'package:web_dashboard/features/Auth/Data/Api/login_api_service.dart';
import 'package:web_dashboard/features/Auth/Logic/login_cubit.dart';
import 'package:web_dashboard/features/User%20Profile/Data/Api/user_api_service.dart';
import 'package:web_dashboard/features/User%20Profile/Logic/user_cubit.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Api/my_farmers_api_service.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_cubit.dart';
import 'package:web_dashboard/features/Notifications/Data/Api/notification_api_service.dart';
import 'package:web_dashboard/features/Notifications/Logic/notification_cubit.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Api/weather_api_service.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Logic/weather_cubit.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Api/soil_data_api_service.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Logic/soil_data_cubit.dart';
import 'package:web_dashboard/features/Dashboard/Data/Api/overview_api_service.dart';
import 'package:web_dashboard/features/Dashboard/Logic/overview_cubit.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Api/connect_farmer_api_service.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Logic/connect_farmer_cubit.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Data/Api/farmer_lands_api_service.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_cubit.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Data/Api/soil_sections_api_service.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_cubit.dart';


final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ApiConsumer
  getIt.registerLazySingleton<DioConsumer>(
    () => DioConsumer(getIt<Dio>()),
  );
  
  // Register ApiConsumer interface to DioConsumer implementation
  getIt.registerLazySingleton<ApiConsumer>(
    () => getIt<DioConsumer>(),
  );

  // Auth Services
  getIt.registerLazySingleton<LoginApiService>(
    () => LoginApiService(getIt<ApiConsumer>()),
  );

  // User Profile Services
  getIt.registerLazySingleton<EngineerApiService>(
    () => EngineerApiService(getIt<ApiConsumer>()),
  );

  // My Farmers Services
  getIt.registerLazySingleton<MyFarmersApiService>(
    () => MyFarmersApiService(getIt<ApiConsumer>()),
  );

  // Auth Cubits (factory because they are stateful)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginApiService>()),
  );

  // User Profile Cubit (singleton to share state across screens)
  getIt.registerLazySingleton<UserCubit>(
    () => UserCubit(getIt<EngineerApiService>()),
  );

  // My Farmers Cubit (singleton to share state across screens)
  getIt.registerLazySingleton<MyFarmersCubit>(
    () => MyFarmersCubit(getIt<MyFarmersApiService>()),
  );

  // FCM Service
  getIt.registerLazySingleton<FCMService>(
    () => FCMService(),
  );

  // Notification Services
  getIt.registerLazySingleton<NotificationApiService>(
    () => NotificationApiService(getIt<ApiConsumer>()),
  );

  // Notification Cubit
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(
      apiService: getIt<NotificationApiService>(),
      fcmService: getIt<FCMService>(),
    ),
  );

  // Weather Services
  getIt.registerLazySingleton<WeatherApiService>(
    () => WeatherApiService(getIt<ApiConsumer>()),
  );

  // Weather Cubit
  getIt.registerLazySingleton<WeatherCubit>(
    () => WeatherCubit(getIt<WeatherApiService>()),
  );

  // Soil Data Services
  getIt.registerLazySingleton<SoilDataApiService>(
    () => SoilDataApiService(getIt<ApiConsumer>()),
  );

  // Soil Data Cubit (factory to allow multiple instances with different params)
  getIt.registerFactory<SoilDataCubit>(
    () => SoilDataCubit(getIt<SoilDataApiService>()),
  );

  // Dashboard Overview Services
  getIt.registerLazySingleton<OverviewApiService>(
    () => OverviewApiService(getIt<ApiConsumer>()),
  );

  // Dashboard Overview Cubit
  getIt.registerLazySingleton<OverviewCubit>(
    () => OverviewCubit(getIt<OverviewApiService>()),
  );

  // Connect Farmer Services
  getIt.registerLazySingleton<ConnectFarmerApiService>(
    () => ConnectFarmerApiService(getIt<ApiConsumer>()),
  );

  // Connect Farmer Cubit (factory to allow fresh state for each connection attempt)
  getIt.registerFactory<ConnectFarmerCubit>(
    () => ConnectFarmerCubit(getIt<ConnectFarmerApiService>()),
  );

  // Get Farmer Lands Services
  getIt.registerLazySingleton<FarmerLandsApiService>(
    () => FarmerLandsApiService(getIt<ApiConsumer>()),
  );

  // Get Farmer Lands Cubit (factory to allow multiple instances for different farmers)
  getIt.registerFactory<FarmerLandsCubit>(
    () => FarmerLandsCubit(getIt<FarmerLandsApiService>()),
  );

  // Get All Soil Sections Services
  getIt.registerLazySingleton<SoilSectionsApiService>(
    () => SoilSectionsApiService(getIt<ApiConsumer>()),
  );

  // Get All Soil Sections Cubit (factory to allow multiple instances for different farmer/land combinations)
  getIt.registerFactory<SoilSectionsCubit>(
    () => SoilSectionsCubit(getIt<SoilSectionsApiService>()),
  );
}
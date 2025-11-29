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
import 'package:web_dashboard/features/Weather%20Charts/Data/Api/weather_api_service.dart';
import 'package:web_dashboard/features/Weather%20Charts/Logic/weather_cubit.dart';


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
}
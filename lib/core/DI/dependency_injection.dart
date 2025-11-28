import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/core/Database/dio_consumer.dart';


final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ApiConsumer
  getIt.registerLazySingleton<DioConsumer>(
    () => DioConsumer(getIt<Dio>()),
  );

  
  
}
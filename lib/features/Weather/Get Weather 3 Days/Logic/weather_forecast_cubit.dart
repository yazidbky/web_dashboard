import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Data/Api/weather_forecast_api_service.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Logic/weather_forecast_state.dart';

class WeatherForecastCubit extends Cubit<WeatherForecastState> {
  final WeatherForecastApiService apiService;

  WeatherForecastCubit(this.apiService) : super(WeatherForecastInitial());

  Future<void> getWeatherForecast(int landId) async {
    print('🔄 [WeatherForecastCubit] Fetching weather forecast for land ID: $landId');
    emit(WeatherForecastLoading());

    try {
      final response = await apiService.getWeatherForecast(landId);
      print('📡 [WeatherForecastCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [WeatherForecastCubit] Weather forecast fetched successfully');
        print('📋 [WeatherForecastCubit] Found ${response.data.length} day(s) of forecast');
        emit(WeatherForecastSuccess(
          forecastData: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [WeatherForecastCubit] Unauthorized: ${response.message}');
        emit(WeatherForecastFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [WeatherForecastCubit] Land not found: ${response.message}');
        emit(WeatherForecastFailure('Land not found'));
      } else if (response.statusCode == 500) {
        print('❌ [WeatherForecastCubit] Server error: ${response.message}');
        emit(WeatherForecastFailure(response.message));
      } else {
        print('❓ [WeatherForecastCubit] Unknown error: ${response.message.isNotEmpty ? response.message : ApiErrors.unknownError}');
        emit(WeatherForecastFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [WeatherForecastCubit] ServerException: ${e.errorModel.message}');
      emit(WeatherForecastFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [WeatherForecastCubit] Unexpected Error: $e');
      emit(WeatherForecastFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    print('🔄 [WeatherForecastCubit] Resetting state to initial.');
    emit(WeatherForecastInitial());
  }
}


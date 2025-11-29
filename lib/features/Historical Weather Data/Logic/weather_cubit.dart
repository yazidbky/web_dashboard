import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Api/weather_api_service.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Models/weather_request_model.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Logic/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApiService apiService;

  WeatherCubit(this.apiService) : super(WeatherInitial());

  Future<void> fetchAndSaveWeather(int landId) async {
    print('🔄 [WeatherCubit] Fetching weather data for land ID: $landId');
    emit(WeatherLoading());

    try {
      final request = WeatherRequestModel(landId: landId);
      print('📡 [WeatherCubit] Sending request with landId: $landId');
      
      final response = await apiService.fetchAndSaveWeather(request);
      print('📡 [WeatherCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [WeatherCubit] Successfully fetched and saved weather data for land ID: $landId');
        print('📋 [WeatherCubit] Message: ${response.message}');
        emit(WeatherSuccess(
          weatherData: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 400) {
        // Validation error
        print('❌ [WeatherCubit] Validation error: ${response.message}');
        emit(WeatherFailure(response.message));
      } else if (response.statusCode == 404) {
        // Land not found
        print('❌ [WeatherCubit] Land not found: ${response.message}');
        emit(WeatherFailure(response.message));
      } else {
        print('❌ [WeatherCubit] Error: ${response.message}');
        emit(WeatherFailure(
          response.message.isNotEmpty ? response.message : ApiErrors.unknownError,
        ));
      }
    } on ServerException catch (e) {
      print('❌ [WeatherCubit] ServerException: ${e.errorModel.message}');
      emit(WeatherFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [WeatherCubit] Unexpected error: $e');
      emit(WeatherFailure(ApiErrors.unknownError));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(WeatherInitial());
  }
}


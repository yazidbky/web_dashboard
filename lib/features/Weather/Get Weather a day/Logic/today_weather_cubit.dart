import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Data/Api/today_weather_api_service.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Logic/today_weather_state.dart';

class TodayWeatherCubit extends Cubit<TodayWeatherState> {
  final TodayWeatherApiService apiService;

  TodayWeatherCubit(this.apiService) : super(TodayWeatherInitial());

  Future<void> getTodayWeather(int landId) async {
    print('🔄 [TodayWeatherCubit] Fetching today weather for land ID: $landId');
    emit(TodayWeatherLoading());

    try {
      final response = await apiService.getTodayWeather(landId);
      print('📡 [TodayWeatherCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [TodayWeatherCubit] Today weather fetched successfully');
        print('📋 [TodayWeatherCubit] Rain: ${response.data.rain.value}${response.data.rain.unit}');
        print('📋 [TodayWeatherCubit] Temperature: ${response.data.temperature.value}${response.data.temperature.unit}');
        print('📋 [TodayWeatherCubit] Wind: ${response.data.wind.value}${response.data.wind.unit}');
        print('📋 [TodayWeatherCubit] Humidity: ${response.data.humidity.value}${response.data.humidity.unit}');
        emit(TodayWeatherSuccess(
          weatherData: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [TodayWeatherCubit] Unauthorized: ${response.message}');
        emit(TodayWeatherFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [TodayWeatherCubit] Land not found: ${response.message}');
        emit(TodayWeatherFailure('Land not found'));
      } else if (response.statusCode == 500) {
        print('❌ [TodayWeatherCubit] Server error: ${response.message}');
        emit(TodayWeatherFailure(response.message));
      } else {
        print('❓ [TodayWeatherCubit] Unknown error: ${response.message.isNotEmpty ? response.message : ApiErrors.unknownError}');
        emit(TodayWeatherFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [TodayWeatherCubit] ServerException: ${e.errorModel.message}');
      emit(TodayWeatherFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [TodayWeatherCubit] Unexpected Error: $e');
      emit(TodayWeatherFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    print('🔄 [TodayWeatherCubit] Resetting state to initial.');
    emit(TodayWeatherInitial());
  }
}


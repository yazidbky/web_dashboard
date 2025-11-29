import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Farmers/Cron%20job/Data/Api/weather_cron_job_api_service.dart';
import 'package:web_dashboard/features/Farmers/Cron%20job/Logic/weather_cron_job_state.dart';

class WeatherCronJobCubit extends Cubit<WeatherCronJobState> {
  final WeatherCronJobApiService apiService;

  WeatherCronJobCubit(this.apiService) : super(WeatherCronJobInitial());

  Future<void> startWeatherCronJob() async {
    print('🔄 [WeatherCronJobCubit] Starting weather cron job...');
    emit(WeatherCronJobLoading());

    try {
      final response = await apiService.startWeatherCronJob();
      print('📡 [WeatherCronJobCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [WeatherCronJobCubit] Weather cron job started successfully!');
        print('📋 [WeatherCronJobCubit] Schedule: ${response.data.schedule}');
        print('📋 [WeatherCronJobCubit] Lands Count: ${response.data.landsCount}');
        emit(WeatherCronJobSuccess(
          data: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [WeatherCronJobCubit] Unauthorized: ${response.message}');
        emit(WeatherCronJobFailure(response.message));
      } else if (response.statusCode == 500) {
        print('❌ [WeatherCronJobCubit] Server error: ${response.message}');
        emit(WeatherCronJobFailure(response.message));
      } else {
        print('❓ [WeatherCronJobCubit] Unknown error: ${response.message.isNotEmpty ? response.message : ApiErrors.unknownError}');
        emit(WeatherCronJobFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [WeatherCronJobCubit] ServerException: ${e.errorModel.message}');
      emit(WeatherCronJobFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [WeatherCronJobCubit] Unexpected Error: $e');
      emit(WeatherCronJobFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    print('🔄 [WeatherCronJobCubit] Resetting state to initial.');
    emit(WeatherCronJobInitial());
  }
}


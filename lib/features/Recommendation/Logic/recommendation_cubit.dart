import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Recommendation/Data/Api/recommendation_api_service.dart';
import 'package:web_dashboard/features/Recommendation/Logic/recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final RecommendationApiService apiService;

  RecommendationCubit(this.apiService) : super(RecommendationInitial());

  Future<void> getCropRecommendations({
    required int farmerId,
    required int landId,
  }) async {
    emit(RecommendationLoading());

    try {
      final response = await apiService.getCropRecommendations(
        farmerId: farmerId,
        landId: landId,
      );

      if (response.statusCode == 200 && response.success == true) {
        emit(RecommendationSuccess(
          recommendationData: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 500) {
        // Server error - show user-friendly message
        emit(const RecommendationFailure(
          'Server is temporarily unavailable. Please try again later.',
        ));
      } else {
        emit(RecommendationFailure(
          response.message.isNotEmpty ? response.message : ApiErrors.unknownError,
        ));
      }
    } on ServerException catch (e) {
      // Check if it's a 500 server error
      if (e.errorModel.statusCode == 500) {
        emit(const RecommendationFailure(
          'Server is temporarily unavailable. Please try again later.',
        ));
      } else {
        emit(RecommendationFailure(e.errorModel.message));
      }
    } catch (e) {
      emit(const RecommendationFailure(
        'Unable to load recommendations. Please try again.',
      ));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(RecommendationInitial());
  }
}


import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Data/Api/farmer_lands_api_service.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Logic/farmer_lands_state.dart';

class FarmerLandsCubit extends Cubit<FarmerLandsState> {
  final FarmerLandsApiService apiService;

  FarmerLandsCubit(this.apiService) : super(FarmerLandsInitial());

  Future<void> getFarmerLands(int farmerId) async {
    print('🔄 [FarmerLandsCubit] Fetching lands for farmer ID: $farmerId');
    emit(FarmerLandsLoading());

    try {
      final response = await apiService.getFarmerLands(farmerId);
      print('📡 [FarmerLandsCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [FarmerLandsCubit] Successfully fetched ${response.data.landIds.length} land(s)');
        print('📋 [FarmerLandsCubit] Land IDs: ${response.data.landIds}');
        emit(FarmerLandsSuccess(
          landIds: response.data.landIds,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [FarmerLandsCubit] Unauthorized: ${response.message}');
        emit(FarmerLandsFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [FarmerLandsCubit] Farmer not found');
        emit(FarmerLandsFailure('Farmer not found'));
      } else if (response.statusCode == 500) {
        print('❌ [FarmerLandsCubit] Server error: ${response.message}');
        emit(FarmerLandsFailure(response.message));
      } else {
        print('❌ [FarmerLandsCubit] Unknown error: ${response.message}');
        emit(FarmerLandsFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [FarmerLandsCubit] ServerException: ${e.errorModel.message}');
      emit(FarmerLandsFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [FarmerLandsCubit] Unexpected error: $e');
      emit(FarmerLandsFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(FarmerLandsInitial());
  }
}


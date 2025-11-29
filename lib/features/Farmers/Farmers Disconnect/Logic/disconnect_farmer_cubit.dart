import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Disconnect/Data/Api/disconnect_farmer_api_service.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Disconnect/Logic/disconnect_farmer_state.dart';

class DisconnectFarmerCubit extends Cubit<DisconnectFarmerState> {
  final DisconnectFarmerApiService apiService;

  DisconnectFarmerCubit(this.apiService) : super(DisconnectFarmerInitial());

  Future<void> disconnectFarmer(int farmerId) async {
    print('🔄 [DisconnectFarmerCubit] Disconnecting farmer ID: $farmerId');
    emit(DisconnectFarmerLoading());

    try {
      final response = await apiService.disconnectFarmer(farmerId);
      print('📡 [DisconnectFarmerCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [DisconnectFarmerCubit] Farmer disconnected successfully');
        print('📋 [DisconnectFarmerCubit] Message: ${response.message}');
        emit(DisconnectFarmerSuccess(
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [DisconnectFarmerCubit] Unauthorized: ${response.message}');
        emit(DisconnectFarmerFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [DisconnectFarmerCubit] Farmer not found');
        emit(DisconnectFarmerFailure('Farmer not found'));
      } else if (response.statusCode == 500) {
        print('❌ [DisconnectFarmerCubit] Server error: ${response.message}');
        emit(DisconnectFarmerFailure(response.message));
      } else {
        print('❌ [DisconnectFarmerCubit] Unknown error: ${response.message}');
        emit(DisconnectFarmerFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [DisconnectFarmerCubit] ServerException: ${e.errorModel.message}');
      emit(DisconnectFarmerFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [DisconnectFarmerCubit] Unexpected error: $e');
      emit(DisconnectFarmerFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(DisconnectFarmerInitial());
  }
}


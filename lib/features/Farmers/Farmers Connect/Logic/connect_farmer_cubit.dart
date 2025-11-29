import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Api/connect_farmer_api_service.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connect_farmer_request_model.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Logic/connect_farmer_state.dart';

class ConnectFarmerCubit extends Cubit<ConnectFarmerState> {
  final ConnectFarmerApiService apiService;

  ConnectFarmerCubit(this.apiService) : super(ConnectFarmerInitial());

  Future<void> connectFarmer(String username) async {
    print('🔄 [ConnectFarmerCubit] Connecting to farmer with username: $username');
    emit(ConnectFarmerLoading());

    try {
      final request = ConnectFarmerRequestModel(username: username);
      print('📡 [ConnectFarmerCubit] Sending connection request...');
      
      final response = await apiService.connectFarmer(request);
      print('📡 [ConnectFarmerCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.success == true && (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data != null) {
          print('✅ [ConnectFarmerCubit] Farmer connected successfully!');
          print('📋 [ConnectFarmerCubit] Connection ID: ${response.data!.id}');
          print('👤 [ConnectFarmerCubit] Farmer ID: ${response.data!.farmerId}');
          print('👨‍💼 [ConnectFarmerCubit] Engineer ID: ${response.data!.engineerId}');
          print('👤 [ConnectFarmerCubit] Farmer Name: ${response.data!.farmer.fullName}');
          emit(ConnectFarmerSuccess(
            data: response.data!,
            message: response.message,
          ));
        } else {
          print('❌ [ConnectFarmerCubit] No data received in response');
          emit(ConnectFarmerFailure('No data received'));
        }
      } else if (response.statusCode == 400) {
        // Validation error
        print('❌ [ConnectFarmerCubit] Validation error: ${response.formattedErrorMessage}');
        emit(ConnectFarmerFailure(response.formattedErrorMessage));
      } else if (response.statusCode == 401) {
        print('❌ [ConnectFarmerCubit] Unauthorized: ${response.message}');
        emit(ConnectFarmerFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [ConnectFarmerCubit] Farmer not found');
        emit(ConnectFarmerFailure('Farmer not found'));
      } else if (response.statusCode == 500) {
        print('❌ [ConnectFarmerCubit] Server error: ${response.message}');
        emit(ConnectFarmerFailure(response.message));
      } else {
        print('❌ [ConnectFarmerCubit] Unknown error: ${response.message}');
        emit(ConnectFarmerFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [ConnectFarmerCubit] ServerException: ${e.errorModel.message}');
      emit(ConnectFarmerFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [ConnectFarmerCubit] Unexpected error: $e');
      emit(ConnectFarmerFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(ConnectFarmerInitial());
  }
}


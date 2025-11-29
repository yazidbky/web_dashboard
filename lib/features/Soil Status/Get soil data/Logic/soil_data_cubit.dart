import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Api/soil_data_api_service.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Logic/soil_data_state.dart';

class SoilDataCubit extends Cubit<SoilDataState> {
  final SoilDataApiService apiService;

  SoilDataCubit(this.apiService) : super(SoilDataInitial());

  /// Fetches soil data for a specific farmer, land, and section
  /// 
  /// [farmerId] - The ID of the farmer
  /// [landId] - The ID of the land
  /// [section] - The section identifier (e.g., "A", "B", "North", etc.)
  Future<void> getSoilData({
    required int farmerId,
    required int landId,
    required String section,
  }) async {
    emit(SoilDataLoading());

    try {
      final response = await apiService.getSoilData(
        farmerId: farmerId,
        landId: landId,
        section: section,
      );

      if (response.success && response.data != null) {
        emit(SoilDataSuccess(
          soilData: response.data!,
          message: response.message,
        ));
      } else {
        emit(SoilDataFailure(response.message.isNotEmpty 
            ? response.message 
            : 'Failed to fetch soil data'));
      }
    } on ConnectionErrorException catch (e) {
      emit(SoilDataFailure(e.errorModel.message));
    } on UnauthorizedException catch (e) {
      emit(SoilDataFailure(e.errorModel.message));
    } on NotFoundException catch (e) {
      emit(SoilDataFailure(e.errorModel.message));
    } on ServerException catch (e) {
      emit(SoilDataFailure(e.errorModel.message));
    } catch (e) {
      emit(SoilDataFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Resets the state to initial
  void reset() {
    emit(SoilDataInitial());
  }
}


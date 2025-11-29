import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Data/Api/soil_sections_api_service.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Logic/soil_sections_state.dart';

class SoilSectionsCubit extends Cubit<SoilSectionsState> {
  final SoilSectionsApiService apiService;

  SoilSectionsCubit(this.apiService) : super(SoilSectionsInitial());

  Future<void> getAllSoilSections(int farmerId, int landId) async {
    print('🔄 [SoilSectionsCubit] Fetching soil sections for farmer ID: $farmerId, land ID: $landId');
    emit(SoilSectionsLoading());

    try {
      final response = await apiService.getAllSoilSections(farmerId, landId);
      print('📡 [SoilSectionsCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');

      if (response.statusCode == 200 && response.success == true) {
        print('✅ [SoilSectionsCubit] Successfully fetched ${response.data.count} section(s)');
        print('📋 [SoilSectionsCubit] Sections: ${response.data.sections}');
        emit(SoilSectionsSuccess(
          sections: response.data.sections,
          count: response.data.count,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        print('❌ [SoilSectionsCubit] Unauthorized: ${response.message}');
        emit(SoilSectionsFailure(response.message));
      } else if (response.statusCode == 404) {
        print('❌ [SoilSectionsCubit] Farmer or land not found');
        emit(SoilSectionsFailure('Farmer or land not found'));
      } else if (response.statusCode == 500) {
        print('❌ [SoilSectionsCubit] Server error: ${response.message}');
        emit(SoilSectionsFailure(response.message));
      } else {
        print('❌ [SoilSectionsCubit] Unknown error: ${response.message}');
        emit(SoilSectionsFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      print('❌ [SoilSectionsCubit] ServerException: ${e.errorModel.message}');
      emit(SoilSectionsFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [SoilSectionsCubit] Unexpected error: $e');
      emit(SoilSectionsFailure(ApiErrors.unknownError));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(SoilSectionsInitial());
  }
}


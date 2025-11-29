import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Graphs/Data/Api/grafana_graph_api_service.dart';
import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_request_model.dart';
import 'package:web_dashboard/features/Graphs/Logic/grafana_graph_state.dart';

class GrafanaGraphCubit extends Cubit<GrafanaGraphState> {
  final GrafanaGraphApiService apiService;

  GrafanaGraphCubit(this.apiService) : super(GrafanaGraphInitial());

  Future<void> getGrafanaGraphUrl(GrafanaGraphRequestModel request) async {
    print('🔄 [GrafanaGraphCubit] Fetching Grafana graph URL...');
    print('📋 [GrafanaGraphCubit] Farmer ID: ${request.farmerId}');
    print('📋 [GrafanaGraphCubit] Land ID: ${request.landId}');
    print('📋 [GrafanaGraphCubit] Column: ${request.column}');
    print('📋 [GrafanaGraphCubit] Plot Type: ${request.plotType}');
    print('📋 [GrafanaGraphCubit] Section ID: ${request.sectionId ?? "N/A"}');
    
    emit(GrafanaGraphLoading());

    try {
      final response = await apiService.getGrafanaGraphUrl(request);
      
      print('📡 [GrafanaGraphCubit] API Response - Status: ${response.statusCode}, Success: ${response.success}');
      
      if (response.success && response.data != null) {
        print('✅ [GrafanaGraphCubit] Grafana graph URL fetched successfully!');
        print('📋 [GrafanaGraphCubit] URL: ${response.data!.url}');
        print('📋 [GrafanaGraphCubit] Iframe URL: ${response.data!.iframeUrl}');
        emit(GrafanaGraphSuccess(response.data!));
      } else {
        print('❌ [GrafanaGraphCubit] Failed to fetch Grafana graph URL: ${response.message}');
        emit(GrafanaGraphFailure(response.message));
      }
    } on ServerException catch (e) {
      print('❌ [GrafanaGraphCubit] Server error: ${e.errorModel.message}');
      emit(GrafanaGraphFailure(e.errorModel.message));
    } catch (e) {
      print('❌ [GrafanaGraphCubit] Unexpected error: $e');
      emit(GrafanaGraphFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}


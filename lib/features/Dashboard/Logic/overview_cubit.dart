import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Dashboard/Data/Api/overview_api_service.dart';
import 'package:web_dashboard/features/Dashboard/Logic/overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  final OverviewApiService apiService;

  OverviewCubit(this.apiService) : super(OverviewInitial());

  Future<void> getOverview() async {
    emit(OverviewLoading());

    try {
      final response = await apiService.getOverview();

      if (response.statusCode == 200 && response.success == true) {
        emit(OverviewSuccess(
          data: response.data,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        emit(OverviewFailure(response.message));
      } else if (response.statusCode == 500) {
        emit(OverviewFailure(response.message));
      } else {
        emit(OverviewFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      emit(OverviewFailure(e.errorModel.message));
    } catch (e) {
      emit(OverviewFailure(ApiErrors.unknownError));
    }
  }
}


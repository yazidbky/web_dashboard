import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Api/my_farmers_api_service.dart';
import 'package:web_dashboard/features/My%20Farmers/Logic/my_farmers_state.dart';

class MyFarmersCubit extends Cubit<MyFarmersState> {
  final MyFarmersApiService apiService;

  MyFarmersCubit(this.apiService) : super(MyFarmersInitial());

  Future<void> getMyFarmers() async {
    emit(MyFarmersLoading());

    try {
      final response = await apiService.getMyFarmers();

      if (response.statusCode == 200 && response.success == true) {
        emit(MyFarmersSuccess(
          farmers: response.data.farmers,
          count: response.data.count,
          message: response.message,
        ));
      } else if (response.statusCode == 401) {
        emit(MyFarmersFailure(response.message));
      } else if (response.statusCode == 500) {
        emit(MyFarmersFailure(response.message));
      } else {
        emit(MyFarmersFailure(
            response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      emit(MyFarmersFailure(e.errorModel.message));
    } catch (e) {
      emit(MyFarmersFailure(ApiErrors.unknownError));
    }
  }
}


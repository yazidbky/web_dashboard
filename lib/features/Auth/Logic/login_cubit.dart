import 'package:bloc/bloc.dart';
import 'package:web_dashboard/core/Database/Local/local_storage.dart';
import 'package:web_dashboard/core/Errors/api_errors.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/features/Auth/Data/Api/login_api_service.dart';
import 'package:web_dashboard/features/Auth/Data/Models/login_request_model.dart';
import 'package:web_dashboard/features/Auth/Logic/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final LoginApiService apiService ;
  LoginCubit(this.apiService) : super(LoginInitial());

  Future<void> login(LoginRequestModel loginRequestModel) async {
    emit(LoginLoading());

    try {
      final response = await apiService.login(loginRequestModel);

      if (response.statusCode == 200 && response.success == true) {
        // Store token securely in local storage
        await LocalStorage.setSecureData('access_token', response.dataModel.token);
        
        // Store user info
        await LocalStorage.storeUserInfo(
          userId: response.dataModel.engineerData.id.toString(),
          email: response.dataModel.engineerData.email,
        );
        
        emit(LoginSuccess(response.message));
      } else if (response.statusCode == 401) {
        emit(LoginFailure(response.message));
      } else if (response.statusCode == 500) {
        emit(LoginFailure(response.message));
      } else {
        emit(LoginFailure(response.message.isNotEmpty ? response.message : ApiErrors.unknownError));
      }
    } on ServerException catch (e) {
      emit(LoginFailure(e.errorModel.message));
    } catch (e) {
      emit(LoginFailure(ApiErrors.unknownError));
    }
  }
}
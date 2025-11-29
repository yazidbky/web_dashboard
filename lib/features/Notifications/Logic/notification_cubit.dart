import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/core/services/fcm_service.dart';
import 'package:web_dashboard/features/Notifications/Data/Api/notification_api_service.dart';
import 'package:web_dashboard/features/Notifications/Logic/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationApiService apiService;
  final FCMService fcmService;

  NotificationCubit({
    required this.apiService,
    required this.fcmService,
  }) : super(NotificationInitial());

  /// Register FCM token with the backend
  /// Call this after successful login
  Future<void> registerFcmToken() async {
    emit(NotificationLoading());

    try {
      // Get the stored FCM token
      final fcmToken = await FCMService.getStoredToken();
      
      if (fcmToken == null) {
        emit(const TokenRegistrationFailure('FCM token not available'));
        return;
      }

      // Determine device type
      String deviceType = 'web';
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceType = 'android';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        deviceType = 'ios';
      }

      // Register with backend
      final response = await apiService.registerToken(
        fcmToken,
        deviceType: deviceType,
      );

      if (response.success) {
        emit(TokenRegistrationSuccess(response.message));
        print('✅ FCM token registered with server');
      } else {
        emit(TokenRegistrationFailure(response.message));
      }
    } on ServerException catch (e) {
      emit(TokenRegistrationFailure(e.errorModel.message));
    } catch (e) {
      emit(TokenRegistrationFailure('Failed to register token: $e'));
    }
  }

  /// Send a notification to a specific user
  Future<void> sendNotification({
    required String targetFcmToken,
    required String title,
    required String body,
    String? image,
    Map<String, dynamic>? data,
  }) async {
    emit(NotificationLoading());

    try {
      final response = await apiService.sendNotification(
        fcmToken: targetFcmToken,
        title: title,
        body: body,
        image: image,
        data: data,
      );

      if (response.success) {
        emit(NotificationSentSuccess(response.message));
      } else {
        emit(NotificationSentFailure(response.message));
      }
    } on ServerException catch (e) {
      emit(NotificationSentFailure(e.errorModel.message));
    } catch (e) {
      emit(NotificationSentFailure('Failed to send notification: $e'));
    }
  }

  /// Unregister FCM token (call on logout)
  Future<void> unregisterToken() async {
    try {
      await fcmService.deleteToken();
      emit(NotificationInitial());
      print('✅ FCM token unregistered');
    } catch (e) {
      print('❌ Error unregistering FCM token: $e');
    }
  }
}


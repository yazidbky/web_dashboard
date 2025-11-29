import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Notifications/Data/Models/notification_response_model.dart';
import 'package:web_dashboard/features/Notifications/Data/Models/register_token_request_model.dart';
import 'package:web_dashboard/features/Notifications/Data/Models/send_notification_request_model.dart';
import 'package:web_dashboard/features/Notifications/Data/Models/notification_model.dart';

class NotificationApiService {
  final ApiConsumer apiConsumer;

  NotificationApiService(this.apiConsumer);

  /// Register FCM token with the server
  Future<NotificationResponseModel> registerToken(String fcmToken, {String? deviceType}) async {
    final request = RegisterTokenRequestModel(
      fcmToken: fcmToken,
      deviceType: deviceType,
    );
    
    final response = await apiConsumer.post(
      Endpoints.registerFcmTokenEndPoint,
      data: request.toJson(),
    );
    
    return NotificationResponseModel.fromJson(response);
  }

  /// Send notification to a specific user
  Future<NotificationResponseModel> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    String? image,
    Map<String, dynamic>? data,
  }) async {
    final request = SendNotificationRequestModel(
      fcmToken: fcmToken,
      notification: NotificationModel(
        title: title,
        body: body,
        image: image,
      ),
      data: data ?? {},
    );
    
    final response = await apiConsumer.post(
      Endpoints.sendNotificationEndPoint,
      data: request.toJson(),
    );
    
    return NotificationResponseModel.fromJson(response);
  }

  /// Get user's notifications
  Future<dynamic> getNotifications({int page = 1, int limit = 20}) async {
    final response = await apiConsumer.get(
      Endpoints.getNotificationsEndPoint,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    
    return response;
  }

  /// Mark notification as read
  Future<NotificationResponseModel> markAsRead(String notificationId) async {
    final response = await apiConsumer.patch(
      '${Endpoints.markNotificationReadEndPoint}/$notificationId',
    );
    
    return NotificationResponseModel.fromJson(response);
  }
}


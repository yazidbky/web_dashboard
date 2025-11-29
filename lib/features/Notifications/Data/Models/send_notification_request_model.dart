import 'package:web_dashboard/features/Notifications/Data/Models/notification_model.dart';

class SendNotificationRequestModel {
  final String fcmToken;
  final NotificationModel notification;
  final Map<String, dynamic> data;

  SendNotificationRequestModel({
    required this.fcmToken,
    required this.notification,
    this.data = const {},
  });

  Map<String, dynamic> toJson() => {
    'fcmToken': fcmToken,
    'notification': notification.toJson(),
    'data': data,
  };
}


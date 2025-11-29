class RegisterTokenRequestModel {
  final String fcmToken;
  final String? deviceType; // 'android', 'ios', 'web'
  final String? deviceId;

  RegisterTokenRequestModel({
    required this.fcmToken,
    this.deviceType,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'fcmToken': fcmToken,
    if (deviceType != null) 'deviceType': deviceType,
    if (deviceId != null) 'deviceId': deviceId,
  };
}


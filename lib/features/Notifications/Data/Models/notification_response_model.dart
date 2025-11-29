class NotificationResponseModel {
  final int statusCode;
  final String message;
  final bool success;

  NotificationResponseModel({
    required this.statusCode,
    required this.message,
    required this.success,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}


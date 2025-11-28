class ErrorModel {
  final bool success;
  final int statusCode;
  final String message;

  ErrorModel({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      success: jsonData["success"] ?? false,
      statusCode: jsonData["statusCode"] ?? 0,
      message: jsonData["message"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
      };
}
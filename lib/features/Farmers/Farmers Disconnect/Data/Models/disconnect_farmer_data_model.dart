class DisconnectFarmerDataModel {
  final String message;

  DisconnectFarmerDataModel({
    required this.message,
  });

  factory DisconnectFarmerDataModel.fromJson(Map<String, dynamic> json) {
    return DisconnectFarmerDataModel(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}


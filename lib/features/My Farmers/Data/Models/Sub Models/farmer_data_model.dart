class FarmerDataModel {
  final int id;
  final String fullName;
  final String email;
  final String username;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;

  FarmerDataModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FarmerDataModel.fromJson(Map<String, dynamic> json) {
    return FarmerDataModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}


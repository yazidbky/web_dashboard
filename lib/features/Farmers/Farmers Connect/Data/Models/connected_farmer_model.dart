class ConnectedFarmerModel {
  final int id;
  final String fullName;
  final String email;
  final String username;
  final String phoneNumber;

  ConnectedFarmerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber,
  });

  factory ConnectedFarmerModel.fromJson(Map<String, dynamic> json) {
    return ConnectedFarmerModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
      };
}


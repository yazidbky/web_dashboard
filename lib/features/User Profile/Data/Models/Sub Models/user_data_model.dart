class EngineerData {
  int id;
  String fullName;
  String email;
  String username;
  String phoneNumber;
  String createdAt;
  String updatedAt;

  EngineerData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EngineerData.fromJson(Map<String, dynamic> json) {
    return EngineerData(
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


class ConnectedEngineerModel {
  final int id;
  final String fullName;
  final String email;
  final String username;

  ConnectedEngineerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
  });

  factory ConnectedEngineerModel.fromJson(Map<String, dynamic> json) {
    return ConnectedEngineerModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'username': username,
      };
}


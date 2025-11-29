class EngineerData{
  int id;
  String fullName, email, username, phoneNumber;
  
  EngineerData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber
  });

  factory EngineerData.fromJson(Map<String, dynamic> json) {
    return EngineerData(
     id: json['id'] ?? 0,
     fullName: json['fullName'] ?? '',
     email: json['email'] ?? '',
     username: json['username'] ?? '',
     phoneNumber: json['phoneNumber'] ?? '',
    );
  }

   Map<String, dynamic> toJson() => {
     'id': id, 'fullName': fullName , 'email': email, 'username': username , 'phoneNumber': phoneNumber
  };


}
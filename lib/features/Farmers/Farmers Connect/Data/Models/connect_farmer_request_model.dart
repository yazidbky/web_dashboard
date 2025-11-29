class ConnectFarmerRequestModel {
  final String username;

  ConnectFarmerRequestModel({
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
      };
}


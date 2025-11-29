
class LoginRequestModel {
  String username , password ;

  LoginRequestModel({
    required this.username,
    required this.password ,
  });

   factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
     username: json['username'],
     password: json['password']
    );
  }

   Map<String, dynamic> toJson() => {
     'username': username, 'password': password
  };
}
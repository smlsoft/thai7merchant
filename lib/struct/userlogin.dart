import 'package:json_annotation/json_annotation.dart';

part 'userlogin.g.dart';

@JsonSerializable()
class UserLogin {
  String userName;
  String token;

  UserLogin({required this.userName, required this.token});

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}


import 'package:json_annotation/json_annotation.dart';

part 'UserToken.g.dart';

@JsonSerializable()
class UserToken {
  final String status;
  final UserInfo response;
  String? token;

  UserToken({required this.status, required this.response, this.token});

  factory UserToken.fromJson(Map<String, dynamic> json) =>  _$UserTokenFromJson(json);

  Map<String, dynamic> toJson() => _$UserTokenToJson(this);
}

@JsonSerializable()
class  UserInfo {
  final String usrNm;
  final String? mail;

  UserInfo({required this.usrNm, required this.mail});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

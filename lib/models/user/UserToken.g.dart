// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserToken.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) => UserToken(
      status: json['status'] as String,
      response: UserInfo.fromJson(json['response'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
      'token': instance.token,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      usrNm: json['usrNm'] as String,
      mail: json['mail'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'usrNm': instance.usrNm,
      'mail': instance.mail,
    };

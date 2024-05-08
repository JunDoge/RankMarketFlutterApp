// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMassages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMassages _$ChatMassagesFromJson(Map<String, dynamic> json) => ChatMassages(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => ChatMassage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatMassagesToJson(ChatMassages instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

ChatMassage _$ChatMassageFromJson(Map<String, dynamic> json) => ChatMassage(
      chat_id: json['chat_id'] as String,
      usr_id: json['usr_id'] as String,
      msg: json['msg'] as String,
      cre_dtm: DateTime.parse(json['cre_dtm'] as String),
      prd_id: json['prd_id'] as int,
    );

Map<String, dynamic> _$ChatMassageToJson(ChatMassage instance) =>
    <String, dynamic>{
      'chat_id': instance.chat_id,
      'usr_id': instance.usr_id,
      'msg': instance.msg,
      'cre_dtm': instance.cre_dtm.toIso8601String(),
      'prd_id': instance.prd_id,
    };

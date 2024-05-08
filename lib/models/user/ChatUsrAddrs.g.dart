// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatUsrAddrs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUsrAddrs _$ChatUsrAddrsFromJson(Map<String, dynamic> json) => ChatUsrAddrs(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => ChatUsrAddr.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatUsrAddrsToJson(ChatUsrAddrs instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

ChatUsrAddr _$ChatUsrAddrFromJson(Map<String, dynamic> json) => ChatUsrAddr(
      buyer: json['buyer'] as String,
      seller: json['seller'] as String,
      prd_id: json['prd_id'] as int,
      buyer_id: json['buyer_id'] as String?,
    );

Map<String, dynamic> _$ChatUsrAddrToJson(ChatUsrAddr instance) =>
    <String, dynamic>{
      'buyer': instance.buyer,
      'seller': instance.seller,
      'prd_id': instance.prd_id,
      'buyer_id': instance.buyer_id,
    };

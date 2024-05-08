// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PayHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayHistorys _$PayHistorysFromJson(Map<String, dynamic> json) => PayHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => PayHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PayHistorysToJson(PayHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

PayHistory _$PayHistoryFromJson(Map<String, dynamic> json) => PayHistory(
      img: json['img'] as String,
      title: json['title'] as String,
      win_price: json['win_price'] as int,
      pay_diff: json['pay_diff'] as bool,
      pay_dtm: json['pay_dtm'] as String?,
      prd_id: json['prd_id'] as int,
    );

Map<String, dynamic> _$PayHistoryToJson(PayHistory instance) =>
    <String, dynamic>{
      'img': instance.img,
      'title': instance.title,
      'win_price': instance.win_price,
      'pay_dtm': instance.pay_dtm,
      'pay_diff': instance.pay_diff,
      'prd_id': instance.prd_id,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReviewHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewHistorys _$ReviewHistorysFromJson(Map<String, dynamic> json) =>
    ReviewHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => ReviewHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReviewHistorysToJson(ReviewHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

ReviewHistory _$ReviewHistoryFromJson(Map<String, dynamic> json) =>
    ReviewHistory(
      prd_id: json['prd_id'] as int,
      img: json['img'] as String,
      revDes: json['revDes'] as String,
      rate_scr: json['rate_scr'] as int,
    );

Map<String, dynamic> _$ReviewHistoryToJson(ReviewHistory instance) =>
    <String, dynamic>{
      'prd_id': instance.prd_id,
      'img': instance.img,
      'revDes': instance.revDes,
      'rate_scr': instance.rate_scr,
    };

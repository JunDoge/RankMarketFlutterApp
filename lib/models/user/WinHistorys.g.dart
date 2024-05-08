// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WinHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WinHistorys _$WinHistorysFromJson(Map<String, dynamic> json) => WinHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => WinHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WinHistorysToJson(WinHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

WinHistory _$WinHistoryFromJson(Map<String, dynamic> json) => WinHistory(
      img: json['img'] as String,
      win_price: json['win_price'] as int?,
      prd_id: json['prd_id'] as int,
      title: json['title'] as String,
      sell_price: json['sell_price'] as int,
      high_price: json['high_price'] as int,
      win_dtm: json['win_dtm'] as String?,
      status: json['status'] as int,
    );

Map<String, dynamic> _$WinHistoryToJson(WinHistory instance) =>
    <String, dynamic>{
      'img': instance.img,
      'win_price': instance.win_price,
      'prd_id': instance.prd_id,
      'win_dtm': instance.win_dtm,
      'sell_price': instance.sell_price,
      'high_price': instance.high_price,
      'title': instance.title,
      'status': instance.status,
    };

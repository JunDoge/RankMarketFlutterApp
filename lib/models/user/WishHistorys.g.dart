// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WishHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishHistorys _$WishHistorysFromJson(Map<String, dynamic> json) => WishHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => WishHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WishHistorysToJson(WishHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

WishHistory _$WishHistoryFromJson(Map<String, dynamic> json) => WishHistory(
      img: json['img'] as String,
      bid_price: json['bid_price'] as int,
      title: json['title'] as String,
      end_dtm: json['end_dtm'] as String,
      prd_id: json['prd_id'] as int,
      ieast_price: json['ieast_price'] as int,
      high_price: json['high_price'] as int,
    );

Map<String, dynamic> _$WishHistoryToJson(WishHistory instance) =>
    <String, dynamic>{
      'img': instance.img,
      'bid_price': instance.bid_price,
      'end_dtm': instance.end_dtm,
      'title': instance.title,
      'prd_id': instance.prd_id,
      'high_price': instance.high_price,
      'ieast_price': instance.ieast_price,
    };

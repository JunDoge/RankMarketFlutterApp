// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PrdMgmts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrdMgmts _$PrdMgmtsFromJson(Map<String, dynamic> json) => PrdMgmts(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => PrdMgmt.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrdMgmtsToJson(PrdMgmts instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

PrdMgmt _$PrdMgmtFromJson(Map<String, dynamic> json) => PrdMgmt(
      imgs: (json['imgs'] as List<dynamic>).map((e) => e as String).toList(),
      prd_id: json['prd_id'] as int,
      title: json['title'] as String,
      sell_price: json['sell_price'] as int,
      high_price: json['high_price'] as int,
      ieast_price: json['ieast_price'] as int,
      end_dtm: json['end_dtm'] as String,
      status: json['status'] as String,
      bid_cnt: json['bid_cnt'] as int,
      bid_price: json['bid_price'] as int,
    );

Map<String, dynamic> _$PrdMgmtToJson(PrdMgmt instance) => <String, dynamic>{
      'imgs': instance.imgs,
      'prd_id': instance.prd_id,
      'title': instance.title,
      'sell_price': instance.sell_price,
      'high_price': instance.high_price,
      'ieast_price': instance.ieast_price,
      'end_dtm': instance.end_dtm,
      'status': instance.status,
      'bid_price': instance.bid_price,
      'bid_cnt': instance.bid_cnt,
    };

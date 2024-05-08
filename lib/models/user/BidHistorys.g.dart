// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BidHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidHistorys _$BidHistorysFromJson(Map<String, dynamic> json) => BidHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => BidHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BidHistorysToJson(BidHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

BidHistory _$BidHistoryFromJson(Map<String, dynamic> json) => BidHistory(
      img: json['img'] as String,
      bid_dtm: json['bid_dtm'] as String,
      bid_price: json['bid_price'] as int,
      prd_id: json['prd_id'] as int,
      end_dtm: json['end_dtm'] as String,
      high_price: json['high_price'] as int,
      ieast_price: json['ieast_price'] as int,
      sell_price: json['sell_price'] as int,
      status: json['status'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$BidHistoryToJson(BidHistory instance) =>
    <String, dynamic>{
      'img': instance.img,
      'bid_dtm': instance.bid_dtm,
      'bid_price': instance.bid_price,
      'prd_id': instance.prd_id,
      'end_dtm': instance.end_dtm,
      'sell_price': instance.sell_price,
      'high_price': instance.high_price,
      'ieast_price': instance.ieast_price,
      'title': instance.title,
      'status': instance.status,
    };

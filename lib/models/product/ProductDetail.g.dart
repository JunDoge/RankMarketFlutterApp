// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetails _$ProductDetailsFromJson(Map<String, dynamic> json) =>
    ProductDetails(
      status: json['status'] as String,
      response:
          ProductDetail.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDetailsToJson(ProductDetails instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    ProductDetail(
      prd_id: json['prd_id'] as int,
      title: json['title'] as String,
      imgs: (json['imgs'] as List<dynamic>).map((e) => e as String).toList(),
      sell_price: json['sell_price'] as int,
      high_price: json['high_price'] as int,
      ieast_price: json['ieast_price'] as int,
      bid_price: json['bid_price'] as int,
      des: json['des'] as String,
      end_dtm: json['end_dtm'] as String,
      significant: json['significant'] as String?,
    );

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'prd_id': instance.prd_id,
      'imgs': instance.imgs,
      'title': instance.title,
      'sell_price': instance.sell_price,
      'high_price': instance.high_price,
      'ieast_price': instance.ieast_price,
      'bid_price': instance.bid_price,
      'des': instance.des,
      'significant': instance.significant,
      'end_dtm': instance.end_dtm,
    };

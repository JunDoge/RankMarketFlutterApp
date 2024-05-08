// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      img: json['img'] as String,
      title: json['title'] as String,
      prd_id: json['prd_id'] as int,
      sell_price: json['sell_price'] as int,
      wish: json['wish'] as bool,
      end_dtm: json['end_dtm'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'img': instance.img,
      'title': instance.title,
      'prd_id': instance.prd_id,
      'sell_price': instance.sell_price,
      'wish': instance.wish,
      'end_dtm': instance.end_dtm,
    };

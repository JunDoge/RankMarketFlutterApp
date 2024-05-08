// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Popular.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Populars _$PopularsFromJson(Map<String, dynamic> json) => Populars(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => Popular.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PopularsToJson(Populars instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

Popular _$PopularFromJson(Map<String, dynamic> json) => Popular(
      img: json['img'] as String,
      title: json['title'] as String,
      prd_id: json['prd_id'] as int,
      ieast_price: json['ieast_price'] as int,
      high_price: json['high_price'] as int,
    );

Map<String, dynamic> _$PopularToJson(Popular instance) => <String, dynamic>{
      'img': instance.img,
      'title': instance.title,
      'ieast_price': instance.ieast_price,
      'high_price': instance.high_price,
      'prd_id': instance.prd_id,
    };

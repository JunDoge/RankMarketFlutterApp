// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Mosts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mosts _$MostsFromJson(Map<String, dynamic> json) => Mosts(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => Most.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MostsToJson(Mosts instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

Most _$MostFromJson(Map<String, dynamic> json) => Most(
      img: (json['img'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      ieast_price: json['ieast_price'] as int,
      prd_id: json['prd_id'] as int,
      high_price: json['high_price'] as int,
    );

Map<String, dynamic> _$MostToJson(Most instance) => <String, dynamic>{
      'img': instance.img,
      'title': instance.title,
      'ieast_price': instance.ieast_price,
      'prd_id': instance.prd_id,
      'high_price': instance.high_price,
    };

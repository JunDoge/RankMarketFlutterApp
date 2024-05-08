// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RankingChecks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankingChecks _$RankingChecksFromJson(Map<String, dynamic> json) =>
    RankingChecks(
      status: json['status'] as String,
      response: RankingCheck.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RankingChecksToJson(RankingChecks instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

RankingCheck _$RankingCheckFromJson(Map<String, dynamic> json) => RankingCheck(
      rank: json['rank'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$RankingCheckToJson(RankingCheck instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'price': instance.price,
    };

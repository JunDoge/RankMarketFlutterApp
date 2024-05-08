// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RptHistorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RptHistorys _$RptHistorysFromJson(Map<String, dynamic> json) => RptHistorys(
      status: json['status'] as String,
      response: (json['response'] as List<dynamic>)
          .map((e) => RptHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RptHistorysToJson(RptHistorys instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

RptHistory _$RptHistoryFromJson(Map<String, dynamic> json) => RptHistory(
      img: json['img'] as String,
      rpt_id: json['rpt_id'] as String,
      rpt_des: json['rpt_des'] as String,
      rpt_type: json['rpt_type'] as String,
    );

Map<String, dynamic> _$RptHistoryToJson(RptHistory instance) =>
    <String, dynamic>{
      'img': instance.img,
      'rpt_id': instance.rpt_id,
      'rpt_des': instance.rpt_des,
      'rpt_type': instance.rpt_type,
    };

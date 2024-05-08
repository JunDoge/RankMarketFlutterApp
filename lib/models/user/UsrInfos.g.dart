// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsrInfos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsrInfos _$UsrInfosFromJson(Map<String, dynamic> json) => UsrInfos(
      status: json['status'] as String,
      response: UsrInfo.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UsrInfosToJson(UsrInfos instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

UsrInfo _$UsrInfoFromJson(Map<String, dynamic> json) => UsrInfo(
      ph_num: json['ph_num'] as String,
      mail: json['mail'] as String,
      pst_addr: json['pst_addr'] as String,
      rd_addr: json['rd_addr'] as String,
      det_addr: json['det_addr'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UsrInfoToJson(UsrInfo instance) => <String, dynamic>{
      'ph_num': instance.ph_num,
      'mail': instance.mail,
      'pst_addr': instance.pst_addr,
      'rd_addr': instance.rd_addr,
      'det_addr': instance.det_addr,
      'name': instance.name,
    };

import 'package:json_annotation/json_annotation.dart';

part 'UsrInfos.g.dart';
@JsonSerializable()
class UsrInfos {
  final String status;
  final UsrInfo response;

  UsrInfos({required this.status, required this.response});

  factory UsrInfos.fromJson(Map<String, dynamic> json) =>  _$UsrInfosFromJson(json);

  Map<String, dynamic> toJson() => _$UsrInfosToJson(this);
}

@JsonSerializable()
class UsrInfo{
  final String ph_num;
  final String mail;
  final String pst_addr;
  final String rd_addr;
  final String? det_addr;
  final String name;

  UsrInfo({required this.ph_num, required this.mail
    , required this.pst_addr, required this.rd_addr, required this.det_addr, required this.name});

  factory UsrInfo.fromJson(Map<String, dynamic> json) =>  _$UsrInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UsrInfoToJson(this);
}

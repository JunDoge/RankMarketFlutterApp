import 'package:json_annotation/json_annotation.dart';

part 'RptHistorys.g.dart';
@JsonSerializable()
class RptHistorys {
  final String status;
  final List<RptHistory> response;

  RptHistorys({required this.status, required this.response});

  factory RptHistorys.fromJson(Map<String, dynamic> json) =>  _$RptHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$RptHistorysToJson(this);
}

@JsonSerializable()
class RptHistory{
  final String img;
  final String rpt_id;
  final String rpt_des;

  final String rpt_type;

  RptHistory({required this.img, required this.rpt_id, required this.rpt_des, required this.rpt_type});

  factory RptHistory.fromJson(Map<String, dynamic> json) =>  _$RptHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RptHistoryToJson(this);
}
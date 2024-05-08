import 'package:json_annotation/json_annotation.dart';

part 'ReviewHistorys.g.dart';
@JsonSerializable()
class ReviewHistorys {
  final String status;
  final List<ReviewHistory> response;

  ReviewHistorys({required this.status, required this.response});

  factory ReviewHistorys.fromJson(Map<String, dynamic> json) =>  _$ReviewHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewHistorysToJson(this);
}

@JsonSerializable()
class ReviewHistory{
  final int prd_id;
  final String img;
  final String revDes;
  final int rate_scr;
  ReviewHistory({required this.prd_id, required this.img, required this.revDes, required this.rate_scr});

  factory ReviewHistory.fromJson(Map<String, dynamic> json) =>  _$ReviewHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewHistoryToJson(this);

}
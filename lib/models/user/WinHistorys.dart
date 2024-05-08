import 'package:json_annotation/json_annotation.dart';

part 'WinHistorys.g.dart';
@JsonSerializable()
class WinHistorys {
  final String status;
  final List<WinHistory> response;

  WinHistorys({required this.status, required this.response});

  factory WinHistorys.fromJson(Map<String, dynamic> json) =>  _$WinHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$WinHistorysToJson(this);
}

@JsonSerializable()
class WinHistory{
  final String img;
  final int? win_price;
  final int prd_id;
  final String? win_dtm;
  final int sell_price;
  final int high_price;
  final String title;
  final int status;


  WinHistory({required this.img, required this.win_price, required this.prd_id, required this.title,
  required this.sell_price, required this.high_price, required this.win_dtm, required this.status});

  factory WinHistory.fromJson(Map<String, dynamic> json) =>  _$WinHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$WinHistoryToJson(this);
}
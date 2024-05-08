import 'package:json_annotation/json_annotation.dart';

part 'PrdMgmts.g.dart';
@JsonSerializable()
class PrdMgmts {
  final String status;
  final List<PrdMgmt> response;

  PrdMgmts({required this.status, required this.response});

  factory PrdMgmts.fromJson(Map<String, dynamic> json) =>  _$PrdMgmtsFromJson(json);

  Map<String, dynamic> toJson() => _$PrdMgmtsToJson(this);
}

@JsonSerializable()
class PrdMgmt{
  final List<String> imgs;
  final int prd_id;
  final String title;
  final int sell_price;
  final int high_price;
  final int ieast_price;
  final String end_dtm;
  final String status;
  final int bid_price;
  final int bid_cnt;
  PrdMgmt({required this.imgs, required this.prd_id, required this.title, required this.sell_price,
    required this.high_price, required this.ieast_price, required this.end_dtm, required this.status,
  required this.bid_cnt, required this.bid_price});


  factory PrdMgmt.fromJson(Map<String, dynamic> json) =>  _$PrdMgmtFromJson(json);

  Map<String, dynamic> toJson() => _$PrdMgmtToJson(this);
}
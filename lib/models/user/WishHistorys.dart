
import 'package:json_annotation/json_annotation.dart';

part 'WishHistorys.g.dart';
@JsonSerializable()
class WishHistorys{
  final String status;
  final List<WishHistory> response;

  WishHistorys({required this.status, required this.response});

  factory WishHistorys.fromJson(Map<String, dynamic> json) =>  _$WishHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$WishHistorysToJson(this);
}

@JsonSerializable()
class WishHistory{
  final String img;
  final int bid_price;
  final String end_dtm;
  final String title;
  final int prd_id;
  final int high_price;
  final int ieast_price;




  WishHistory({required this.img, required this.bid_price, required this.title,
  required this.end_dtm, required this.prd_id, required this.ieast_price, required this.high_price});

  factory WishHistory.fromJson(Map<String, dynamic> json) =>  _$WishHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$WishHistoryToJson(this);

}
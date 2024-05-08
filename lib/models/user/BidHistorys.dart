import 'package:json_annotation/json_annotation.dart';

part 'BidHistorys.g.dart';
@JsonSerializable()
class BidHistorys {
  final String status;
  final List<BidHistory> response;

  BidHistorys({required this.status, required this.response});

  factory BidHistorys.fromJson(Map<String, dynamic> json) =>  _$BidHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$BidHistorysToJson(this);
}

@JsonSerializable()
class BidHistory{
  final String img;
  final String bid_dtm;
  final int bid_price;
  final int prd_id;
  final String end_dtm;
  final int sell_price;
  final int high_price;
  final int ieast_price;
  final String title;
  final String status;



  BidHistory({required this.img, required this.bid_dtm, required this.bid_price,
      required this.prd_id, required this.end_dtm, required this.high_price, required this.ieast_price,
  required this.sell_price, required this.status, required this.title });

  factory BidHistory.fromJson(Map<String, dynamic> json) =>  _$BidHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$BidHistoryToJson(this);
}


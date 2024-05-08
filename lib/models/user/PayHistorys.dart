import 'package:json_annotation/json_annotation.dart';

part 'PayHistorys.g.dart';
@JsonSerializable()
class PayHistorys {
  final String status;
  final List<PayHistory> response;

  PayHistorys({required this.status, required this.response});

  factory PayHistorys.fromJson(Map<String, dynamic> json) =>  _$PayHistorysFromJson(json);

  Map<String, dynamic> toJson() => _$PayHistorysToJson(this);
}

@JsonSerializable()
class PayHistory{
  final String img;
  final String title;
  final int win_price;
  final String? pay_dtm;
  final bool pay_diff;
  final int prd_id;
  PayHistory({required this.img, required this.title, required this.win_price,
  required this.pay_diff, required this.pay_dtm, required this.prd_id});

  factory PayHistory.fromJson(Map<String, dynamic> json) =>  _$PayHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PayHistoryToJson(this);

}
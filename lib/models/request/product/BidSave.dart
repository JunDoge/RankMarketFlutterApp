
import 'package:json_annotation/json_annotation.dart';

part 'BidSave.g.dart';
@JsonSerializable()
class BidSave{
  final int prd_id;
  final int ieastPrice;
  final int high_price;
  BidSave({required this.prd_id, required this.ieastPrice, required this.high_price});
  factory BidSave.fromJson(Map<String, dynamic> json) =>  _$BidSaveFromJson(json);

  Map<String, dynamic> toJson() => _$BidSaveToJson(this);
}
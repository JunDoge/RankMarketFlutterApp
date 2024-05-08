import 'package:json_annotation/json_annotation.dart';

part 'ProductDetail.g.dart';


@JsonSerializable()
class ProductDetails {
  final String status;
  final ProductDetail response;

  ProductDetails({required this.status,required this.response});

  factory ProductDetails.fromJson(Map<String, dynamic> json) =>  _$ProductDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsToJson(this);
}

@JsonSerializable()
class  ProductDetail {
  final int prd_id;
  final List<String> imgs;
  final String title;
  final int sell_price;
  final int high_price;
  final int ieast_price;
  final int bid_price;
  final String des;
  final String? significant;
  final String end_dtm;

  ProductDetail({required this.prd_id, required this.title, required this.imgs,
    required this.sell_price, required this.high_price, required this.ieast_price,
    required this.bid_price, required this.des,required this.end_dtm, required this.significant});

  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}


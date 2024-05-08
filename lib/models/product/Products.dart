import 'package:json_annotation/json_annotation.dart';

part 'Products.g.dart';


@JsonSerializable()
class Products {
  final String status;
  final List<Product> response;

  Products({required this.status,required this.response});

  factory Products.fromJson(Map<String, dynamic> json) =>  _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}

@JsonSerializable()
class  Product {
  final String img;
  final String title;
  final int prd_id;
  final int sell_price;
  final bool wish;
  final String end_dtm;

  Product({required this.img, required this.title, required this.prd_id, required this.sell_price,
    required this.wish, required this.end_dtm});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}


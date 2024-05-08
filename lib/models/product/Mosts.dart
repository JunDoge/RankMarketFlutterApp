import 'package:json_annotation/json_annotation.dart';

part 'Mosts.g.dart';


@JsonSerializable()
class Mosts {
  final String status;
  final List<Most> response;

  Mosts({required this.status,required this.response});

  factory Mosts.fromJson(Map<String, dynamic> json) =>  _$MostsFromJson(json);

  Map<String, dynamic> toJson() => _$MostsToJson(this);
}

@JsonSerializable()
class Most{
  final List<String> img;
  final String title;
  final int ieast_price;
  final int prd_id;
  final int high_price;
  Most({required this.img,required this.title,required this.ieast_price,
    required this.prd_id, required this.high_price});

  factory Most.fromJson(Map<String, dynamic> json) =>  _$MostFromJson(json);

  Map<String, dynamic> toJson() => _$MostToJson(this);
}
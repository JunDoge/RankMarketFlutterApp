import 'package:json_annotation/json_annotation.dart';

part 'Popular.g.dart';


@JsonSerializable()
class Populars {
  final String status;
  final List<Popular> response;

  Populars({required this.status,required this.response});

  factory Populars.fromJson(Map<String, dynamic> json) =>  _$PopularsFromJson(json);

  Map<String, dynamic> toJson() => _$PopularsToJson(this);
}

@JsonSerializable()
class  Popular {
  final String img;
  final String title;
  final int ieast_price;
  final int high_price;
  final int prd_id;

  Popular({required this.img, required this.title, required this.prd_id, required this.ieast_price, required this.high_price});

  factory Popular.fromJson(Map<String, dynamic> json) => _$PopularFromJson(json);

  Map<String, dynamic> toJson() => _$PopularToJson(this);
}


import 'package:json_annotation/json_annotation.dart';

part 'RankingChecks.g.dart';


@JsonSerializable()
class RankingChecks {
  final String status;
  final RankingCheck response;

  RankingChecks({required this.status,required this.response});

  factory RankingChecks.fromJson(Map<String, dynamic> json) =>  _$RankingChecksFromJson(json);

  Map<String, dynamic> toJson() => _$RankingChecksToJson(this);
}


@JsonSerializable()
class RankingCheck {
  final String rank;
  final int price;
  RankingCheck({required this.rank,required this.price});

  factory RankingCheck.fromJson(Map<String, dynamic> json) =>  _$RankingCheckFromJson(json);

  Map<String, dynamic> toJson() => _$RankingCheckToJson(this);
}
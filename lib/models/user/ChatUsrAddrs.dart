import 'package:json_annotation/json_annotation.dart';

part 'ChatUsrAddrs.g.dart';
@JsonSerializable()
class ChatUsrAddrs {
  final String status;
  final List<ChatUsrAddr> response;

  ChatUsrAddrs({required this.status, required this.response});

  factory ChatUsrAddrs.fromJson(Map<String, dynamic> json) =>  _$ChatUsrAddrsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUsrAddrsToJson(this);
}

@JsonSerializable()
class ChatUsrAddr{
  final String buyer;
  final String seller;
  final int prd_id;
  final String? buyer_id;
  ChatUsrAddr({required this.buyer, required this.seller, required this.prd_id, required this.buyer_id});

  factory ChatUsrAddr.fromJson(Map<String, dynamic> json) =>  _$ChatUsrAddrFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUsrAddrToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'ChatMassages.g.dart';
@JsonSerializable()
class ChatMassages {
  final String status;
  final List<ChatMassage> response;

  ChatMassages({required this.status, required this.response});

  factory ChatMassages.fromJson(Map<String, dynamic> json) =>  _$ChatMassagesFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMassagesToJson(this);
}

@JsonSerializable()
class ChatMassage{
  final String chat_id;
  final String usr_id;
  final String msg;
  final DateTime cre_dtm;
  final int prd_id;
  ChatMassage({required this.chat_id, required this.usr_id, required this.msg
    , required this.cre_dtm, required this.prd_id});

  factory ChatMassage.fromJson(Map<String, dynamic> json) =>  _$ChatMassageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMassageToJson(this);

}

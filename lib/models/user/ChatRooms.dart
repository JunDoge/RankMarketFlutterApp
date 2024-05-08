import 'package:json_annotation/json_annotation.dart';

part 'ChatRooms.g.dart';
@JsonSerializable()
class ChatRooms {
  final String status;
  final ChatRoom response;

  ChatRooms({required this.status, required this.response});

  factory ChatRooms.fromJson(Map<String, dynamic> json) =>  _$ChatRoomsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomsToJson(this);
}
@JsonSerializable()
class ChatRoom{
  final String usr_id;
  final List<Chat> chatDto;
  ChatRoom({required this.usr_id, required this.chatDto});
  factory ChatRoom.fromJson(Map<String, dynamic> json) =>  _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
@JsonSerializable()
class Chat{
  final String chat_id;
  final String prd_title;
  Chat({required this.chat_id,required this.prd_title});
  factory Chat.fromJson(Map<String, dynamic> json) =>  _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatRooms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRooms _$ChatRoomsFromJson(Map<String, dynamic> json) => ChatRooms(
      status: json['status'] as String,
      response: ChatRoom.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRoomsToJson(ChatRooms instance) => <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      usr_id: json['usr_id'] as String,
      chatDto: (json['chatDto'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'usr_id': instance.usr_id,
      'chatDto': instance.chatDto,
    };

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      chat_id: json['chat_id'] as String,
      prd_title: json['prd_title'] as String,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chat_id': instance.chat_id,
      'prd_title': instance.prd_title,
    };

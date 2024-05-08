import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shop_app/repository/user/UserRepository.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map_screen.dart';

class ChatScreen extends StatefulWidget {
  static String routName = "/Test";
  final String chat_id;
  final String usr_id;
  const ChatScreen({Key? key, required this.chat_id, required this.usr_id}): super(key: key);

  @override
  _ChatAppState createState() => _ChatAppState();
}



class _ChatAppState extends State<ChatScreen> with AutomaticKeepAliveClientMixin<ChatScreen> {

  @override
  bool get wantKeepAlive => true;



  final storage = const FlutterSecureStorage();
  String? token;
  StompClient? stompClient;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final userRepository = UserRepository(Dio());
  int currentPage = 0;
  bool isLoading = false;
  String? mapUrl;

  @override
  void initState() {
    print("initState 문제임");
    super.initState();
    initializeToken();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose 호출");
  }


  _chatMapUrl(String url, String time){
    setState(() {
      mapUrl = url;
      setState(() {
        _handleSubmitted('거래시간: $time');
        _handleSubmitted('$mapUrl');
      });
    });
  }

  _loadMap(BuildContext context) async {
    final token = await storage.read(key: "token");
    final chatUsrAddrs = await userRepository.getChatUsrAddrs(token!, widget.chat_id);
    print("dddd ${widget.usr_id}");

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MapScreen(chatUsrAddrs: chatUsrAddrs, onLocationSelected: (LatLng location) {}, usr_id: widget.usr_id, chatMapUrl: _chatMapUrl,),
      ),
    );
    print("mapUrl $mapUrl");


  }




  _loadMore() async {
    print("loadMore 문제임");
    print("실행은 되니? $currentPage");
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      String chat_id = widget.chat_id;
      final chatHistory = await userRepository.getChatMessages(token!,currentPage,chat_id);
      setState(() {
        currentPage += 20;
        isLoading = false;
      });
      List<ChatMessage> tempMessages = [];
      chatHistory.response.forEach((message) {
        ChatMessage chatMessage = ChatMessage(
          text: message.msg,
          isSentByUser: message.usr_id == widget.usr_id ? true : false,
          dateTime: message.cre_dtm,
        );
        tempMessages.add(chatMessage);
      });
      _messages.addAll(tempMessages);
    }
  }

  Future<void> initializeToken() async {
    print("init 문제임");
    token = await storage.read(key: "token");
    print("여기가 chatId임 ${widget.chat_id}");
    if (token != null) {
      print("token $token");
      stompClient = StompClient(
        config: StompConfig(
          url: 'ws://1.251.115.6:8089/mypage/chatroom/${widget.chat_id}',
          onConnect: (StompFrame connectFrame) {
            print('Connected to server');
            stompClient!.subscribe(
              destination: '/sub/chatroom/${widget.chat_id}',
              callback: (StompFrame frame) {
                if(frame.body != null){
                  final newMessage = jsonDecode(frame.body!);
                  DateTime dateTime = DateTime.parse(newMessage['cre_dtm']);
                  bool isSentByUser = false;

                  if(newMessage['usr_id'] == widget.usr_id){
                    isSentByUser = true;
                  }
                  var message = ChatMessage(
                    text: newMessage['msg'].toString(),
                    isSentByUser: isSentByUser,
                    dateTime: dateTime,
                  );

                  setState(() {
                    _messages.insert(0,message);
                  });

                } else {
                  print("frame.body is null");
                }
              },
            );
          },
          onDisconnect: (StompFrame disconnectFrame) {
            print('Disconnected from server');
          },
          onStompError: (StompFrame errorFrame) {
            print('Error: ${errorFrame.body}');
          },
          stompConnectHeaders: {'Authorization': token!},
        ),
      );
      stompClient!.activate();
    }
  }

  void sendMessage(String message) {
    print("send 문제임");
    if (message.isNotEmpty) {
      final data = {
        'chat_id': widget.chat_id,
        'usr_id': widget.usr_id,
        'msg': message,
        'cre_dtm': DateTime.now().toIso8601String(),
      };

      final String jsonData = jsonEncode(data);

      stompClient?.send(
        destination: '/pub/mypage/chatroom/${widget.chat_id}',
        body: jsonData,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 가상 키보드 숨기기
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("채팅방"),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                  controller: _scrollController, // ScrollController를 추가합니다.
                ),
              ),
              const Divider(height: 1.0),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).cardColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.location_on, color: Colors.orange),
              onPressed: (){
                setState(() {
                  _loadMap(context);
                });

              },
            ),
            Flexible(
              child: TextField(
                textInputAction: TextInputAction.send,
                controller: _textController,
                onSubmitted: (String text) {
                  _handleSubmitted(_textController.text);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  hintText: "Send a message",
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.orange),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    DateTime dateTime = DateTime.now();
    var message = ChatMessage(
      text: text,
      isSentByUser: true,
      dateTime: dateTime,
    );
    setState(() {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      });
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 800.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    sendMessage(text);
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final DateTime dateTime;
  const ChatMessage({
    Key? key,
    required this.text,
    required this.isSentByUser, required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (text.contains('https://map')) {
          if (await canLaunch(text)) {
            await launch(text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('링크를 열 수 없습니다.')),
            );
          }
        }
      },
      child:Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment:
            isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              if (isSentByUser)
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              if (!isSentByUser)
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
            ],
          )
      ),
    );
  }
}

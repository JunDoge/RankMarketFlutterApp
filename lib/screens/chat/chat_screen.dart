import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/user/ChatRooms.dart';
import '../../repository/user/UserRepository.dart';
import '../sign_in/sign_in_screen.dart';
import 'chat_room_screen.dart';

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class ChatMessageWidget extends StatelessWidget {
  final Chat chatRoom;

  const ChatMessageWidget({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        chatRoom.prd_title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      /*subtitle: Text(chatRoom.message, style: TextStyle(color: Colors.grey)),*/
    );
  }
}

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository(Dio());
    const storage = FlutterSecureStorage();
    return FutureBuilder(
        future: storage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data != null) {
            String token = snapshot.data!;
            Future<ChatRooms> chatRooms =
                userRepository.getChatRooms(snapshot.data!);
            return FutureBuilder(
                future: chatRooms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    ChatRooms chatRooms = snapshot.data as ChatRooms;

                    if (chatRooms.response.chatDto.isEmpty) {
                      return WillPopScope(
                          onWillPop: onWillPop,
                          child: const Scaffold(
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 16),
                                  Text(
                                    "채팅방이 없습니다.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }

                    return WillPopScope(
                        onWillPop: onWillPop,
                        child: Scaffold(
                          appBar: AppBar(
                            title: const Text(
                              '채팅',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 2,
                              ),
                            ),
                            automaticallyImplyLeading: false,
                            bottom: const PreferredSize(
                              preferredSize: Size.fromHeight(0),
                              child: Divider(
                                color: Colors.black26,
                                thickness: 1.0,
                              ),
                            ),
                          ),
                          body: ListView.builder(
                            itemCount: chatRooms.response.chatDto.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              chat_id: chatRooms.response
                                                  .chatDto[index].chat_id,
                                              usr_id:
                                                  chatRooms.response.usr_id),
                                        ),
                                      );
                                    },
                                    child: ChatMessageWidget(
                                        chatRoom:
                                            chatRooms.response.chatDto[index]),
                                  ),
                                  Divider(color: Colors.grey[200]),
                                ],
                              );
                            },
                          ),
                        ));
                  }
                });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const SignInScreen()));
              Navigator.pushNamed(context, SignInScreen.routeName);
            });
            return Container();
          }
        });
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      final snackBar = SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

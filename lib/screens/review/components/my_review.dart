import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/user/ReviewHistorys.dart';

import '../../../repository/user/UserRepository.dart';
import '../../no_product_page.dart';
import '../../sign_in/sign_in_screen.dart';

class MyReview extends StatefulWidget {
  const MyReview({Key? key}) : super(key: key);

  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  late Future<ReviewHistorys?> _reviewHistorysFuture;
  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();
  String? token;

  @override
  void initState() {
    super.initState();
    _reviewHistorysFuture = _fetchreviewHistorys();
  }

  Future<ReviewHistorys?> _fetchreviewHistorys() async {
    token = await storage.read(key: 'token');
    if (token != null) {
      return userRepository.getMyReviewHistorys(token!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });
      return null;
    }
  }

  void ReviewDelete(int index) {
    setState(() {
      _reviewHistorysFuture.then((reviewHistorys) {
        if (reviewHistorys != null) {
          List<int> prd_ids = [reviewHistorys.response[index].prd_id];
          userRepository.reviewDelete(prd_ids, token!);
          reviewHistorys.response.removeAt(index);
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('리뷰가 삭제되었습니다.'),
        duration: Duration(milliseconds: 1000), // 스낵바가 화면에 표시되는 시간 (1초)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReviewHistorys?>(
      future: _reviewHistorysFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.response.isEmpty) {
          return const NoProductPage(msg: "리뷰내역이 없습니다.");
        } else {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
            itemCount: snapshot.data!.response.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 78,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.network(
                              "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${snapshot.data!.response[index].img}",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10, height: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              snapshot.data!.response[index].revDes,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 0; i < snapshot.data!.response[index].rate_scr; i++)
                                  const Icon(Icons.star, color: Colors.yellow),
                                for (int i = snapshot.data!.response[index].rate_scr; i < 5; i++)
                                  const Icon(Icons.star_border, color: Colors.yellow),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: SizedBox(), // 왼쪽 공간을 채우기 위한 Expanded 위젯
                            ),
                            PopupMenuButton<int>(
                              color: Colors.white,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        ReviewDelete(index);
                                      });
                                    },
                                    title: const Text('리뷰삭제'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[200]),
                ],
              );
            },
          );

        }
      },
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/user/ReviewHistorys.dart';

import '../../../repository/user/UserRepository.dart';
import '../../no_product_page.dart';
import '../../sign_in/sign_in_screen.dart';

class ReviewByBuyer extends StatelessWidget {
  const ReviewByBuyer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = UserRepository(Dio());
    Future<ReviewHistorys>? reviewHistorys;

    const storage = FlutterSecureStorage();
    return FutureBuilder(
        future: storage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data != null) {
            String token = snapshot.data!;
            reviewHistorys = userRepository.getBuyerReviewHistorys(token);
            return FutureBuilder(
                future: reviewHistorys,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    if (kDebugMode) {
                      print('Error: ${snapshot.error}');
                    }
                    return Text('Error: ${snapshot.error}');
                  } else {
                    ReviewHistorys reviewList = snapshot.data as ReviewHistorys;
                    if (reviewList.response.isEmpty) {
                      return const NoProductPage(msg:"내가 쓴 글 리뷰내역이 없습니다.");
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: reviewList.response.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 88,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F6F9),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Image.network(
                                            "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${reviewList.response[index].img}"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          reviewList.response[index].revDes,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            for (int i = 0;
                                                i <
                                                    reviewList.response[index]
                                                        .rate_scr;
                                                i++)
                                              const Icon(Icons.star,
                                                  color: Colors.yellow),
                                            for (int i = reviewList
                                                    .response[index].rate_scr;
                                                i < 5;
                                                i++)
                                              const Icon(Icons.star_border,
                                                  color: Colors.yellow),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.grey[200])
                            ],
                          );
                        });
                  }
                });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            });
            return Container();
          }
        });
  }
}

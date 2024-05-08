import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/components/product_card3.dart';
import 'package:shop_app/models/user/BidHistorys.dart';
import 'package:shop_app/repository/user/UserRepository.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../parameter/product_details_arguments.dart';
import '../details/details_screen.dart';
import '../no_product_page.dart';

class BidHistory extends StatefulWidget {
  static String routeName = "/bidHistory";

  const BidHistory({Key? key}) : super(key: key);

  @override
  _BidHistoryState createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  final userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();
  String? token;
  late Future<BidHistorys?> _bidHistorysFuture;

  @override
  void initState() {
    super.initState();
    _bidHistorysFuture = _fetchBidHistorys();
  }

  Future<BidHistorys?> _fetchBidHistorys() async {
    token = await storage.read(key: 'token');
    if (token != null) {
      return userRepository.getBidHistory(token!);
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

  void ProductDelete(int index) {
    setState(() {
      _bidHistorysFuture.then((bidHistorys) {
        if (bidHistorys != null) {
          bidHistorys.response.removeAt(index);
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('상품이 삭제되었습니다.'),
        duration: Duration(milliseconds: 1000), // 스낵바가 화면에 표시되는 시간 (1초)
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BidHistorys?>(
      future: _bidHistorysFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.response.isEmpty) {
          return const NoProductPage(msg: "입찰내역이 없습니다.");
        } else {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return ProductCard3(
                            bidHistory: snapshot.data!.response[index],
                            token: token!,
                            onPress: () => Navigator.pushNamed(
                              context,
                              DetailsScreen.routeName,
                              arguments: ProductDetailsArguments(prd_id: snapshot.data!.response[index].prd_id),
                            ),
                            onDelete: () => ProductDelete(index),
                          );

                        },
                        childCount: snapshot.data!.response.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}


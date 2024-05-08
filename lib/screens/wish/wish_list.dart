import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/user/WishHistorys.dart';
import 'package:shop_app/screens/wish/components/wish_model.dart';

import '../../components/product_card5.dart';
import '../../parameter/product_details_arguments.dart';
import '../../repository/user/UserRepository.dart';
import '../details/components/top_rounded_container.dart';
import '../details/details_screen.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key});

  static String routeName = "/wishHistorys";

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final UserRepository userRepository = UserRepository(Dio());
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    
    
    return FutureBuilder(
      future: storage.read(key: "token"),
      builder: (
          BuildContext context,
          AsyncSnapshot<String?> snapshot,
          ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final token = snapshot.data!;
          final Future<WishHistorys> wishHistorys =
          userRepository.getWishHistory(token);
          return FutureBuilder(
            future: wishHistorys,
            builder: (context, AsyncSnapshot<WishHistorys> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Error: ${snapshot.error}');
                }
                return Text('Error: ${snapshot.error}');
              }else if (snapshot.data == null || snapshot.data!.response.isEmpty) {
                return const NoProductPage(msg: "찜 상품이 없습니다.");
              }  else {
                final WishHistorys wishHistory = snapshot.data!;
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "찜 목록",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return ProductCard5(
                                  wishHistory: wishHistory.response[index],
                                  onPress: () => Navigator.pushNamed(
                                    context,
                                    DetailsScreen.routeName,
                                    arguments: ProductDetailsArguments(
                                      prd_id:
                                      wishHistory.response[index].prd_id,
                                    ),
                                  ),
                                );
                              },
                              childCount: wishHistory.response.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Consumer<WishModel>(
                    builder: (context, wishProvider, child) {
                      return TopRoundedContainer(
                        color: Colors.white,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (wishProvider.prdIds.isNotEmpty) {
                                  print(wishProvider.prdIds);
                                  await userRepository.changeWish(
                                      token, wishProvider.prdIds);
                                  setState(() {
                                    for(int prdId in wishProvider.prdIds){
                                      wishProvider.removeFromCart(prdId);
                                    }

                                  });
                                }
                              },
                              child: Text("삭제"),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          });
          return Container();
        }
      },
    );
  }
}


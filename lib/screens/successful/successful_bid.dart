import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/components/product_card4.dart';
import 'package:shop_app/models/user/WinHistorys.dart';

import '../../parameter/product_details_arguments.dart';
import '../../repository/user/UserRepository.dart';
import '../details/details_screen.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';

//낙찰내역
class SuccessfulBid extends StatelessWidget {
  const SuccessfulBid({Key? key}) : super(key: key);

  static String routeName = "/winHistorys";

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository(Dio());
    const storage = FlutterSecureStorage();
    return FutureBuilder(
        future: storage.read(key: "token"),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }


          if (snapshot.hasData && snapshot.data != null) {
            Future<WinHistorys> winHistorys =
                userRepository.getWinHistorys(snapshot.data!);
            return FutureBuilder(
                future: winHistorys,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    WinHistorys winHistorys = snapshot.data as WinHistorys;

                    if (winHistorys.response.isEmpty) {
                      return const NoProductPage(msg: "낙찰내역이 없습니다.");
                    }
                    
                    return Scaffold(
                      body: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            itemCount: winHistorys.response.length,
                            itemBuilder: (context, index) => ProductCard4(
                              winHistory: winHistorys.response[index],
                              onPress: () => Navigator.pushNamed(
                                context,
                                DetailsScreen.routeName,
                                arguments:
                                ProductDetailsArguments(prd_id: winHistorys.response[index].prd_id),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                });
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
            return Container();
          }
        });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/user/PayHistorys.dart';

import '../../main.dart';
import '../../repository/user/UserRepository.dart';
import '../cart/cart_screen.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';

class PayDemo extends StatefulWidget {
  const PayDemo({Key? key}) : super(key: key);

  @override
  _PaysDemoState createState() => _PaysDemoState();
}
// 결제하는쪽 -> 웹에서는 상품을 선택하는거 화면이 반이고 결제 위젯이 반 차지
class _PaysDemoState extends State<PayDemo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository(Dio());
    const storage = FlutterSecureStorage();

    return FutureBuilder(
        future: storage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            String token = snapshot.data!;
            Future<PayHistorys>? winhistorys =
                userRepository.getPayHistorys(token,0);
            return FutureBuilder(
              future: winhistorys,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  PayHistorys payHistory = snapshot.data as PayHistorys;

                  if (payHistory.response.isEmpty) {
                    return const NoProductPage(msg: "결제내역이 없습니다.");
                  }


                  return Scaffold(
                      appBar: AppBar(
                        title: const Text(
                          "결제",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                      body: ListView.builder(
                        itemCount: payHistory.response.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Ink.image(
                                image: NetworkImage(
                                    payHistory.response[index].img),
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.orange),
                                      foregroundColor: Colors.black,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: const Text('쇼핑 계속하기'),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MyApp()),
                                              (route) => false,
                                        );
                                      });

                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      side: const BorderSide(
                                          color: Colors.orange),
                                      foregroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: const Text('메인페이지로'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ));
                }
              },
            );
          } else {
            return const SignInScreen();
          }
        });
  }
}

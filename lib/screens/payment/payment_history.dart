import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/user/PayHistorys.dart';

import '../../repository/user/UserRepository.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/cart_card.dart';

class PaymentHistory extends StatefulWidget {
  static String routeName = "/payHistorys";

  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _CartScreenState();
}

class _CartScreenState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository(Dio());
    const storage = FlutterSecureStorage();

    return FutureBuilder(
      future: storage.read(key : "token"),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }


        if (snapshot.hasData && snapshot.data != null) {
          String token = snapshot.data!;
          Future<PayHistorys>? payhistorys = userRepository.getPayHistorys(token,0);

          return FutureBuilder(
            future: payhistorys,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                PayHistorys payHistorys = snapshot.data as PayHistorys;
                if (payHistorys.response.isEmpty) {
                  return const NoProductPage(msg: "결제내역이 없습니다.");
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Column(
                      children: [
                        const Text(
                          "결제 내역",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "${payHistorys.response.length} items",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: payHistorys.response.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                key: Key(payHistorys.response[index].pay_dtm.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    payHistorys.response.removeAt(index);
                                  });
                                },
                                background: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      SvgPicture.asset("assets/icons/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: CartCard(payHistorys: payHistorys.response[index]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }else{

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          });
          return Container();
        }
      },
    );
  }
}

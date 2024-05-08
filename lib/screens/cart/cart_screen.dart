import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/user/PayHistorys.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/cart_card.dart';
import 'components/cart_model.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartModel cartProvider = Provider.of<CartModel>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = UserRepository(Dio());
    Future<PayHistorys>? carts;

    const storage = FlutterSecureStorage();
    return FutureBuilder(
      future: storage.read(key: 'token'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData && snapshot.data != null) {
          String token = snapshot.data!;
          carts = userRepository.getPayHistorys(token, 1);
          return FutureBuilder(
            future: carts,
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
                PayHistorys cart = snapshot.data as PayHistorys;
                if (cart.response.isEmpty) {
                  return const NoProductPage(msg: "결제 할 상품이 없습니다.");
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Column(
                      children: [
                        const Text(
                          "장바구니",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "${cart.response.length} items",
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
                            itemCount: cart.response.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Dismissible(
                                  key: Key(cart.response[index].prd_id.toString()),
                                  direction: DismissDirection.endToStart,
                                  child: CartCard(
                                    cart: cart.response[index],
                                    checkboxStateCallback: (isSelected, winPrice, title) {
                                      if (isSelected) {
                                        cartProvider.addToCart(cart.response[index].prd_id, winPrice, title);
                                      } else {
                                        cartProvider.removeFromCart(cart.response[index].prd_id, winPrice, title);
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        CheckoutCard(),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          });
          return Container();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/last_seen_product.dart';

import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastBackPressed;

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      final snackBar = SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              SpecialOffers(),
              DiscountBanner(),
              PopularProducts(),
              LastSeen_product(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
        ),
    );
  }
}


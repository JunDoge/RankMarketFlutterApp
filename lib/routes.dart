
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/403error/403error_screen.dart';
import 'package:shop_app/screens/payment/payment_history.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/screens/successful/successful_bid.dart';

import 'screens/bid/bid_history.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(prdNm: null),
  DetailsScreen.routeName: (context) =>  const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ErrorScreen.routeName: (context) => const ErrorScreen(),
  BidHistory.routeName: (context) => const BidHistory(),
  PaymentHistory.routeName : (context) => const PaymentHistory(),
  SuccessfulBid.routeName : (context) => const SuccessfulBid(),

};

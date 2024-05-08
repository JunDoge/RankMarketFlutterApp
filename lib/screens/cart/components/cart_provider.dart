import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';

class CartProvider extends ChangeNotifierProvider<CartModel> {
  CartProvider({
    required Create<CartModel> create,
    Widget? child,
  }) : super(create: create, child: child);

  static CartModel value(BuildContext context, {bool listen = false}) {
    return Provider.of<CartModel>(context, listen: listen);
  }
}

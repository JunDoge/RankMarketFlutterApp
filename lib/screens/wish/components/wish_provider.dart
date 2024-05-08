import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/wish/components/wish_model.dart';

class WishProvider extends ChangeNotifierProvider<WishModel> {
  WishProvider({
    required Create<WishModel> create,
    Widget? child,
  }) : super(create: create, child: child);

  static WishModel value(BuildContext context, {bool listen = false}) {
    return Provider.of<WishModel>(context, listen: listen);
  }
}

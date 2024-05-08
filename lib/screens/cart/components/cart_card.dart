import 'package:flutter/material.dart';
import 'package:shop_app/models/user/PayHistorys.dart';
import 'package:shop_app/parameter/korea_price.dart';

import '../../../constants.dart';
import 'cart_model.dart';
import 'cart_provider.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.checkboxStateCallback,
  }) : super(key: key);

  final PayHistory cart;
  final Function(bool, int, String) checkboxStateCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 88,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                      "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${cart.img}"),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: CurrencyUtil.currencyFormat(cart.win_price),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ),
        CheckBoxWidget(
          cart: cart,
          checkboxStateCallback: checkboxStateCallback,
        ),
      ],
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  final PayHistory cart;
  final Function(bool, int, String) checkboxStateCallback;

  const CheckBoxWidget({
    Key? key,
    required this.cart,
    required this.checkboxStateCallback,
  }) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  late bool _isCheckProduct;
  late CartModel cartProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = CartProvider.value(context);
    _isCheckProduct = cartProvider.prdIds.contains(widget.cart.prd_id);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: const BorderSide(color: Colors.black38),
      activeColor: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      value: _isCheckProduct,
      onChanged: (value) {
        setState(() {
          _isCheckProduct = value!;
          widget.checkboxStateCallback(_isCheckProduct, widget.cart.win_price.toInt(), widget.cart.title);
        });
      },
    );
  }
}

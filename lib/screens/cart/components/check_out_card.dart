import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../parameter/korea_price.dart';
import '../../../toss.dart';
import 'cart_model.dart';
class CheckoutCard extends StatelessWidget {
  const CheckoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cartProvider, child) {
        int total_price = cartProvider.totalPrice;
        List<int> prd_ids = cartProvider.prdIds;
        List<int> prd_price = cartProvider.price;
        List<String> title = cartProvider.title;
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -15),
                blurRadius: 20,
                color: const Color(0xFFDADADA).withOpacity(0.15),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("총 상품 금액 ${CurrencyUtil.currencyFormat(total_price)}", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("결제 수수료 ${CurrencyUtil.currencyFormat(total_price ~/ 10)}", style: TextStyle(fontSize: 16)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset("assets/icons/receipt.svg"),
                    ),
                    Spacer(),
                    Text("결제 금액 ${CurrencyUtil.currencyFormat(total_price + (total_price ~/ 10))}", style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if(total_price > 0){
                            String msg;
                            if(prd_ids.length == 1){
                              msg = title.first;
                            }else{
                              msg = "${title.first} 외 ${prd_ids.length}";
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentWidgetExamplePage(prd_ids: prd_ids, total_price: total_price, prd_price : prd_price, msg: msg, title : title),
                              ),
                            );
                          }

                        },
                        child: const Text("결제하기"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

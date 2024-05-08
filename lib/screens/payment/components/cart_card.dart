import 'package:flutter/material.dart';
import 'package:shop_app/models/user/PayHistorys.dart';
import 'package:shop_app/parameter/korea_price.dart';

import '../../../constants.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.payHistorys,
  }) : super(key: key);

  final PayHistory payHistorys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    Row(
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
              child: Image.network("https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${payHistorys.img}"),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payHistorys.title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "\₩${CurrencyUtil.currencyFormat(payHistorys.win_price)}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            const SizedBox(height: 8), // 추가된 텍스트와의 간격을 위해
            Text(
              (payHistorys.pay_dtm != null ? '결제 일자: ${payHistorys.pay_dtm}' : '결제대기'),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],

        ),
     ],
     ),
        Divider(color: Colors.grey[200]),
      ],
    );
  }
}

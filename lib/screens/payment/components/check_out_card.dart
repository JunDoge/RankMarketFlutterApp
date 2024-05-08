import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      // height: 174,
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
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 오른쪽으로 정렬
              children: [
                Text("총 상품 금액 \₩100000", style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 오른쪽으로 정렬
              children: [
                Text("결제 수수료 \₩1000", style: TextStyle(fontSize: 16)),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8), // 가로 줄에 양 옆 여백 추가
              child: Divider(), // 가로 줄 추가
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 오른쪽으로 정렬
                  children: [
                    Text("결제 수수료 \₩101000", style: TextStyle(fontSize: 16)),
                  ],
                ),
                // const Expanded(
                //   child: Text.rich(
                //     TextSpan(
                //       text: "상품 금액: ",
                //       children: [
                //         TextSpan(
                //           text: "\₩337.15000",
                //           style: TextStyle(fontSize: 16, color: Colors.black),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // const Expanded(
                //   child: Text.rich(
                //     TextSpan(
                //       text: "Total:\n",
                //       children: [
                //         TextSpan(
                //           text: "\₩337.15",
                //           style: TextStyle(fontSize: 16, color: Colors.black),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("결제하기"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

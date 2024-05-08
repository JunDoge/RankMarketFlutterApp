import 'package:flutter/material.dart';
import 'package:shop_app/models/user/WinHistorys.dart';
import 'package:shop_app/screens/review/review_screen.dart';

import '../constants.dart';
import '../parameter/korea_price.dart';
import '../screens/report/report_screen.dart';
import '../screens/report/write_report.dart';
import '../screens/review/write_review.dart';
import '../toss.dart';


class ProductCard4 extends StatelessWidget {
  const ProductCard4({
    Key? key,
    this.width = 0,
    this.aspectRetio = 0.02,
    required this.winHistory,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final WinHistory winHistory;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    bool isStatus1 = winHistory.status == 1;
    bool isStatus2 = winHistory.status == 2;
    bool isStatus3 = winHistory.status == 3;
    bool isStatus4 = winHistory.status == 4;
    bool hasReviewButton = isStatus2 || isStatus3;

    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2.6,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.01,
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                          "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${winHistory.img}"),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        winHistory.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "시작가 ${CurrencyUtil.currencyFormat(winHistory.sell_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "최고가 ${CurrencyUtil.currencyFormat(winHistory.high_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "판매가 ${CurrencyUtil.currencyFormat(winHistory.win_price!)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isStatus1)
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    List<int> prd_ids = [winHistory.prd_id];
                    List<int> prd_price = [winHistory.win_price!];
                    List<String> titles = [winHistory.title];
                    String msg = winHistory.title;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentWidgetExamplePage(prd_ids: prd_ids, total_price: winHistory.win_price, prd_price :prd_price, msg: msg, title:titles ,),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.89,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '결제하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              if (isStatus2)
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportScreen()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.89,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '신고내역',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              if (isStatus3)
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Review()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.89,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '리뷰내역',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

              if (isStatus4)
                Expanded(child:
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  Complaint(prd_id: winHistory.prd_id)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '신고하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                ),
              if (isStatus4)
                Expanded(child:
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  Rating(prd_id: winHistory.prd_id)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '리뷰쓰기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                ),
            ],
          ),
          Divider(color: Colors.grey[350]),
        ],
      ),
    );
  }
}


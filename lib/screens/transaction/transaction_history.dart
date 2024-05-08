import 'package:flutter/material.dart';

import '../bid/bid_history.dart';
import '../successful/successful_bid.dart';

class ReviewDemo2 extends StatefulWidget {
  const ReviewDemo2({Key? key}) : super(key: key);

  @override
  _ReviewDemoState createState() => _ReviewDemoState();
}

class _ReviewDemoState extends State<ReviewDemo2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> menuItems = ["입찰내역", "낙찰내역"];
    return DefaultTabController(
      length: menuItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '거래내역',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          bottom: TabBar(
            tabs: List.generate(
              menuItems.length,
                  (index) => Tab(
                text: menuItems[index],
              ),
            ),
            unselectedLabelColor: Colors.black38,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            // isScrollable: true,
          ),
        ),
        body: TabBarView(
          key: _formKey,
          children: const [BidHistory(), SuccessfulBid()],
        ),
      ),
    );
  }
}

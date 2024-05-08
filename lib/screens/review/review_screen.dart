import 'package:flutter/material.dart';

import 'components/my_review.dart';
import 'components/review_buyer.dart';


class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  _ReviewDemoState createState() => _ReviewDemoState();
}

class _ReviewDemoState extends State<Review> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> menuItems = ["내가 쓴 리뷰내역", "내가 쓴 글 리뷰내역"];
    return DefaultTabController(
      length: menuItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '리뷰내역',
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
          children: const [MyReview(), ReviewByBuyer()],
        ),
      ),
    );
  }
}

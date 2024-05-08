import 'package:flutter/material.dart';
import 'package:shop_app/models/product/ProductDetail.dart';
import 'package:shop_app/parameter/korea_price.dart';

import '../../../constants.dart';

class ProductDescription extends StatefulWidget {
  final ProductDetail productDetails;
  final GestureTapCallback? pressOnSeeMore;
  const ProductDescription({
    Key? key,
    required this.productDetails,
    this.pressOnSeeMore,
  }) : super(key: key);
  @override
  State<ProductDescription> createState() => ProductDescriptionState();
}

class ProductDescriptionState extends State<ProductDescription> {
  late int _bidPrice;

  @override
  void initState() {
    super.initState();
    _bidPrice = widget.productDetails.bid_price == 0
        ? widget.productDetails.sell_price
        : widget.productDetails.bid_price;
  }

  void updateBidPrice(int price) {
    setState(() {
      _bidPrice += price;
    });
  }

  @override
  Widget build(BuildContext context) {
    var productDetail = widget.productDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            productDetail.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 48,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            "시작가격 ${CurrencyUtil.currencyFormat(productDetail.sell_price)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            "현재 입찰된 가격 ${CurrencyUtil.currencyFormat(_bidPrice)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            "최고 가격 ${CurrencyUtil.currencyFormat(productDetail.high_price)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 64,
            ),
            child: Text("상세 정보", style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            productDetail.des,
            maxLines: 20,
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text("특이사항", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            productDetail.significant ?? '없음',
            maxLines: 20,
          ),
        ),
      ],
    );
  }
}

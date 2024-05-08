import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/product/Popular.dart';
import '../parameter/korea_price.dart';

class PopularCard extends StatelessWidget {
  const PopularCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.popular,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Popular popular;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${popular.img}'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              popular.title,
              style:  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 13),
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyUtil.currencyFormat(popular.high_price),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
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

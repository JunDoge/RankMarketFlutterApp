import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/product/Products.dart';
import '../parameter/korea_price.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late ImageProvider _imageProvider;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _imageProvider = NetworkImage('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/' + widget.product.img);
    _loadImage();
  }

  void _loadImage() async {
    await precacheImage(_imageProvider, context);
    setState(() {
      _isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTap: widget.onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: widget.aspectRetio,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isImageLoaded ? Image(image: _imageProvider) : CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.title,
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyUtil.currencyFormat(widget.product.sell_price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            Text(widget.product.end_dtm),
          ],
        ),
      ),
    );
  }
}

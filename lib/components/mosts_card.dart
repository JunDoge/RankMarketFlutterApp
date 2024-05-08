import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/product/Mosts.dart';
import '../parameter/korea_price.dart';

class MostsCard extends StatefulWidget {
  const MostsCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.mosts,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Most mosts;
  final VoidCallback onPress;

  @override
  _MostsCardState createState() => _MostsCardState();
}

class _MostsCardState extends State<MostsCard> {
  late ImageProvider _imageProvider;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadImage() async {
    _imageProvider = NetworkImage('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.mosts.img[0]}');
    await precacheImage(_imageProvider, context);
    setState(() {
      _isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadImage(); // 이미지 로드를 build() 메서드에서 호출

    final theme = Theme.of(context);
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
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    if (!_isImageLoaded)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    Image(image: _imageProvider),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.mosts.title,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 13),
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyUtil.currencyFormat(widget.mosts.high_price),
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



import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/product/Products.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../constants.dart';
import '../parameter/korea_price.dart';

class ProductCard6 extends StatefulWidget {
  final Product product;
  final VoidCallback onPress;

  ProductCard6({required this.product, required this.onPress});

  @override
  _ProductCard6State createState() => _ProductCard6State();
}

class _ProductCard6State extends State<ProductCard6> {
  late Timer _timer;
  late Duration _timeRemaining;
  late DateTime _endDateTime;
  late bool _wish;
  late ImageProvider _imageProvider;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _wish = widget.product.wish;
    DateFormat format = DateFormat("yy/MM/dd HH:mm:ss");
    _endDateTime = format.parse(widget.product.end_dtm);
    _timeRemaining = _endDateTime.difference(DateTime.now());
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage();
  }

  void _loadImage() async {
    _imageProvider = NetworkImage('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.product.img}');
    await precacheImage(_imageProvider, context);
    setState(() {
      _isImageLoaded = true;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _endDateTime.difference(DateTime.now());
        if (_timeRemaining <= Duration.zero) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeRemainingStr = _timeRemaining <= Duration.zero
        ? "경매 종료"
        : "남은 시간 ${_timeRemaining.inDays}일 ${_timeRemaining.inHours.remainder(24)}시간 ${_timeRemaining.inMinutes.remainder(60)}분 ${_timeRemaining.inSeconds.remainder(60)}초";

    return GestureDetector(
      onTap: widget.onPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 3.5,
              ),
              child: AspectRatio(
                aspectRatio: 1.01,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isImageLoaded ? Image(image: _imageProvider) : CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "현재가 ${CurrencyUtil.currencyFormat(widget.product.sell_price)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeRemainingStr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () async {
                        final userRepository = UserRepository(Dio());
                        const storage = FlutterSecureStorage();
                        String? token = await storage.read(key: 'token');
                        List<int> prd_ids = [widget.product.prd_id];
                        if (token != null) {
                          await userRepository.changeWish(token, prd_ids);
                          setState(() {
                            _wish = !_wish;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: _wish ? kPrimaryColor.withOpacity(0.15) : kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Heart_Icon_2.svg",
                          colorFilter: ColorFilter.mode(
                            _wish ? const Color(0xFFFF4848) : const Color(0xFFDBDEE4),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

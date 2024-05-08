import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/user/WishHistorys.dart';
import 'package:shop_app/screens/wish/components/wish_model.dart';
import 'package:shop_app/screens/wish/components/wish_provider.dart';

import '../constants.dart';
import '../parameter/korea_price.dart';



class ProductCard5 extends StatefulWidget {
  final double width, aspectRetio;
  final WishHistory wishHistory;
  final VoidCallback onPress;

  const ProductCard5({
    Key? key,
    this.width = 0,
    this.aspectRetio = 0.02,
    required this.wishHistory,
    required this.onPress,
  }) : super(key: key);

  @override
  _ProductCard5State createState() => _ProductCard5State();
}

class _ProductCard5State extends State<ProductCard5> {
  Timer? _timer;
  late Duration _timeRemaining;
  late DateTime _endDateTime;

  @override
  void initState() {
    super.initState();
    DateFormat format = DateFormat("yy/MM/dd HH:mm:ss");
    _endDateTime = format.parse(widget.wishHistory.end_dtm);
    _timeRemaining = _endDateTime.difference(DateTime.now());
    _startTimer();
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeRemainingStr = _timeRemaining <= Duration.zero
        ? "경매 종료"
        : "남은시간 ${_timeRemaining.inDays}일 ${_timeRemaining.inHours.remainder(24)}시간 ${_timeRemaining.inMinutes.remainder(60)}분 ${_timeRemaining.inSeconds.remainder(60)}초";

    return GestureDetector(
      onTap: widget.onPress,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3.3,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.wishHistory.img}",
                      ),
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
                        widget.wishHistory.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "시작가 ${CurrencyUtil.currencyFormat(widget.wishHistory.bid_price)}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "입찰가 ${CurrencyUtil.currencyFormat(widget.wishHistory.bid_price)}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      "최고가 ${CurrencyUtil.currencyFormat(widget.wishHistory.high_price)}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      timeRemainingStr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24, // 원하는 크기로 조정
                child: CheckBoxWidget(
                  wishHistory: widget.wishHistory,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[200]),
        ],
      ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  final WishHistory wishHistory;

  const CheckBoxWidget({
    Key? key,
    required this.wishHistory,
  }) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  late bool _isCheckProduct;
  late WishModel wishProvider;

  @override
  void initState() {
    super.initState();
    wishProvider = WishProvider.value(context);
    _isCheckProduct = wishProvider.prdIds.contains(widget.wishHistory.prd_id);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: BorderSide(color: Colors.black38),
      activeColor: Colors.orange,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      value: _isCheckProduct,
      onChanged: (value) {
        setState(() {
          _isCheckProduct = value!;
          if (_isCheckProduct) {
            setState(() {
              wishProvider.addToCart(widget.wishHistory.prd_id);
            });

          } else {
            setState(() {
              wishProvider.removeFromCart(widget.wishHistory.prd_id);
            });

          }
        });
      },
    );
  }
}

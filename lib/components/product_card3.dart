import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/user/BidHistorys.dart';
import 'package:shop_app/repository/product/ProductRepository.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../constants.dart';
import '../parameter/korea_price.dart';

class ProductCard3 extends StatefulWidget {
  const ProductCard3(
      {Key? key,
      this.width = 0,
      this.aspectRetio = 0.02,
      required this.bidHistory,
      required this.onPress,
      required this.token,
      required this.onDelete})
      : super(key: key);

  final double width, aspectRetio;
  final BidHistory bidHistory;
  final VoidCallback onPress;
  final String token;
  final void Function() onDelete;

  @override
  _ProductCard3State createState() => _ProductCard3State();
}

class _ProductCard3State extends State<ProductCard3> {
  Timer? _timer;
  late Duration _timeRemaining;
  late DateTime _endDateTime;
  int bid_price = 0;
  bool isStatusFinished = false;
  void productUpdate() {
      bid_price += widget.bidHistory.ieast_price;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('입찰되었습니다.')),
    );
  }

  @override
  void initState() {
    super.initState();
    DateFormat format = DateFormat("yy/MM/dd HH:mm:ss");
    _endDateTime = format.parse(widget.bidHistory.end_dtm);
    _timeRemaining = _endDateTime.difference(DateTime.now());
    isStatusFinished = _timeRemaining <= Duration.zero;
    _startTimer();
    bid_price = widget.bidHistory.bid_price;
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

  isStatusFinish(){
    setState(() {
      isStatusFinished = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    String timeRemainingStr = _timeRemaining <= Duration.zero
        ? "경매 종료"
        : "남은시간 ${_timeRemaining.inDays}일 ${_timeRemaining.inHours.remainder(24)}시간 ${_timeRemaining.inMinutes.remainder(60)}분 ${_timeRemaining.inSeconds.remainder(60)}초";
    ProductRepository productRepository = ProductRepository(Dio());
    UserRepository userRepository = UserRepository(Dio());

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
                    maxWidth: MediaQuery.of(context).size.width / 2.6,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                          "https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.bidHistory.img}"),
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
                        widget.bidHistory.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "시작가 ${CurrencyUtil.currencyFormat(widget.bidHistory.sell_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "최고가 ${CurrencyUtil.currencyFormat(widget.bidHistory.high_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "나의 입찰 ${CurrencyUtil.currencyFormat(bid_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      timeRemainingStr,
                      style: const TextStyle(
                        fontSize: 13,
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
            // mainAxisAlignment: MainAxisAlignment.spaceAround, // 버튼들 사이에 공간을 추가합니다.
            children: [
              TextButton(
                onPressed: () async {
                  List<int> prd_ids = [widget.bidHistory.prd_id];
                  userRepository.bidDel(widget.token, prd_ids);
                  widget.onDelete();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // 배경색 추가
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '취소',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0),
              TextButton(
                onPressed: () async {
                  if (!isStatusFinished) {
                    if ((widget.bidHistory.sell_price +
                            (widget.bidHistory.ieast_price * 2)) <
                        widget.bidHistory.high_price) {

                      setState(() {
                        productUpdate();
                        if(widget.bidHistory.high_price <= bid_price){
                          isStatusFinish();
                        }

                      });
                      await productRepository.bidSave(
                        widget.bidHistory.prd_id,
                        widget.bidHistory.ieast_price,
                        widget.bidHistory.high_price,
                        widget.token,
                      );

                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // 배경색 추가
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                      '입찰하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              isStatusFinished ? Colors.grey : Colors.black)),
                ),
              ),
            ],
          ),
          SizedBox(height: 0),
          Divider(color: Colors.grey[350]), // 선 추가
        ],
      ),
    );
  }
}

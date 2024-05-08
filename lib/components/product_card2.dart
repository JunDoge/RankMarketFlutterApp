import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/repository/product/ProductRepository.dart';
import 'package:shop_app/screens/product_update/product_update.dart';

import '../constants.dart';
import '../models/user/PrdMgmts.dart';
import '../parameter/korea_price.dart';

final List<String> _themeMode = <String>[
  '판매중',
  '입찰 종료',
  '수정',
  '삭제',
];

class ProductCard2 extends StatefulWidget {
  const ProductCard2({
    Key? key,
    this.width = 0,
    this.aspectRetio = 0.02,
    required this.prdMgmt,
    required this.onPress,
    required this.token,
    required this.onDelete,
  }) : super(key: key);

  final double width, aspectRetio;
  final PrdMgmt prdMgmt;
  final String token;
  final VoidCallback onPress;
  final void Function() onDelete;

  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  Timer? _timer;
  late Duration _timeRemaining;
  late DateTime _endDateTime;
  ProductRepository productRepository = ProductRepository(Dio());
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();
    DateFormat format = DateFormat("yy/MM/dd HH:mm:ss");
    _endDateTime = format.parse(widget.prdMgmt.end_dtm);
    _timeRemaining = _endDateTime.difference(DateTime.now());
    _startTimer();
    _selectedTheme = status();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _endDateTime.difference(DateTime.now());
        print(_timeRemaining);
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

  String status() {
    if (_timeRemaining <= Duration.zero) {
      return "판매 종료";
    } else {
      return "판매중";
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeRemainingStr = _timeRemaining <= Duration.zero
        ? "경매 종료"
        : "남은 시간 ${_timeRemaining.inDays}일 ${_timeRemaining.inHours.remainder(24)}시간 ${_timeRemaining.inMinutes.remainder(60)}분 ${_timeRemaining.inSeconds.remainder(60)}초";

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
                    maxWidth: MediaQuery.of(context).size.width / 2.7,
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
                        'https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.prdMgmt.imgs[0]}',
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
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
                        widget.prdMgmt.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "시작가  ${CurrencyUtil.currencyFormat(widget.prdMgmt.sell_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "입찰가 ${CurrencyUtil.currencyFormat(widget.prdMgmt.bid_price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "최고가 ${CurrencyUtil.currencyFormat(widget.prdMgmt.high_price)}",
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
          _buildThemeSelectionContainer(),
          SizedBox(height: 7),
          Divider(color: Colors.grey[350]),
        ],
      ),
    );
  }

  Widget _buildThemeSelectionContainer() {
    bool isStatusFinished = _selectedTheme == '판매 종료' && _timeRemaining <= Duration.zero;

    return GestureDetector(
      onTap: isStatusFinished ? null : _showThemeSelectionModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _selectedTheme!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isStatusFinished ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isStatusFinished ? Colors.grey : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectionModal() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: _themeMode.map((String value) {
              print(widget.prdMgmt.bid_price);
              if (value == '입찰 종료' && widget.prdMgmt.bid_price == 0) {
                return const SizedBox.shrink();
              } else {
                return ListTile(
                  title: Text(value, textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                    _handleThemeSelection(value);
                  },
                );
              }
            }).toList(),
          ),
        );
      },
    );
  }

  void _handleThemeSelection(String selectedValue) {
    if (_timeRemaining <= Duration.zero) {
      setState(() {
        _selectedTheme = '판매 종료';
      });
      return;
    }

    setState(() {
      if (selectedValue == '입찰 종료') {
        _handleBidEnd();
        _selectedTheme = '판매 종료';
      } else {
        _selectedTheme = selectedValue;
      }

      if (selectedValue == '수정') {
        _handleEdit();
      } else if (selectedValue == '삭제') {
        _handleDelete();
      }
    });
  }

  void _handleBidEnd() async {
    if (widget.prdMgmt.bid_price != 0) {
      await productRepository.bidEnd(widget.token, widget.prdMgmt.prd_id);
    }
    setState(() {
      _timeRemaining = Duration.zero;
    });
    _timer!.cancel();
  }

  void _handleEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Update(prd_id: widget.prdMgmt.prd_id),
      ),
    );
  }

  void _handleDelete() async {
    await productRepository.prdDel(widget.token, widget.prdMgmt.prd_id);
    setState(() {
      widget.onDelete();
    });
  }
}

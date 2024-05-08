import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart/components/cart_model.dart';

import 'main.dart';

String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return "${formatter.format(number)} 원";
}

class Receipt extends StatefulWidget {
  const Receipt({Key? key,  required this.total_price, required this.title}) : super(key: key);
  final int total_price;
  final List<String> title;
  @override
  _ReceipttScreenState createState() => _ReceipttScreenState();
}

class _ReceipttScreenState extends State<Receipt> {
  final _formKey = GlobalKey<FormState>();

  late CartModel cartProvider = Provider.of<CartModel>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // 배경색을 주황색으로 설정했어요.
      appBar: AppBar(
        title: const Text(
          '영수증',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: MyWidget(title: widget.title , total_price: widget.total_price,cartProvider : cartProvider ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key, required this.title, required this.total_price, required this.cartProvider}) : super(key: key);
  final int total_price;
  final List<String> title;
  final CartModel cartProvider;
  _StateMyWidget createState() => _StateMyWidget();
}

class _StateMyWidget extends State<MyWidget> {

  @override
  Widget build(BuildContext context) {

    print("title : ${widget.title.isEmpty}");
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너를 숨김
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: ZigZagClipper(), // ZigZagClipper는 사용자 정의 클리퍼로, 지그재그 패턴을 생성합니다.
              child: Container(
                color: Colors.grey[200], // 지그재그 영역의 색상
                height: 600, // 지그재그 영역의 높이
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.topCenter, // 상단 중앙 정렬
              child: Padding(
                padding: EdgeInsets.only(top: 50), // 상단으로부터의 거리를 조절하기 위한 패딩
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 컨텐츠에 맞게 Column의 크기를 최소화
                  children: <Widget>[ const Text(
                    "결제 완료!",
                    style: TextStyle(
                      fontSize: 24, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 폰트 굵기
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                    SizedBox(height: 120), // 텍스트 사이의 간격
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 내의 항목들을 양끝으로 정렬합니다.
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 50.0), // 왼쪽에 패딩 추가
                          child: Text(
                            "결제코드",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 50.0), // 오른쪽에 패딩 추가
                          child: Text(
                            "20240315116",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 내의 항목들을 양끝으로 정렬합니다.
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0), // 왼쪽에 패딩 추가
                          child: Text(
                            "상품명",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 50.0), // 오른쪽에 패딩 추가
                          child:
                          // Text(
                          //   widget.title,
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 시작 부분에 정렬
                          children: widget.title.map((title) {
                            return Text(
                              title,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            );
                          }).toList(), // map 함수를 사용하여 각 항목을 Text 위젯으로 변환 후, toList()로 리스트로 변환
                        ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 내의 항목들을 양끝으로 정렬합니다.
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0), // 왼쪽에 패딩 추가
                          child: Text(
                            "결제금액",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 50.0), // 오른쪽에 패딩 추가
                          child: Text(
                            formatNumber(widget.total_price),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold, // 볼드체로 설정
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 130), // 버튼 위의 간격을 위해 추가
                    Center( // 중앙 정렬을 위해 Center 위젯 사용
                      child: Container(
                        width: 250, // 버튼의 너비 설정
                        height: 50, // 버튼의 높이 설정
                        child: ElevatedButton(
                          onPressed: () {

                            if(widget.cartProvider.prdIds.isNotEmpty){
                              for(int prdId in widget.cartProvider.prdIds){
                                int i=0;
                                widget.cartProvider.removeFromCart(prdId, widget.cartProvider.price[i], widget.cartProvider.title[i]);
                                i++;
                              }
                            }

                            setState(() {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MyApp()),
                                    (Route<dynamic> route) => false, // 모든 이전 화면을 제거하고 PaymentHistory 화면으로 이동
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // 버튼의 배경색을 하얀색으로 설정
                            // 모서리 둥글게 처리를 위한 설정도 여기에 포함될 수 있습니다.
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // 버튼의 모서리를 둥글게 처리
                            ),
                          ),
                          child: const Text(
                            "메인페이지", // 버튼 내 텍스트
                            style: TextStyle(
                              color: Colors.black, // 텍스트 색상
                              fontSize: 16, // 텍스트 크기
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 20;

    while (x < size.width) {
      x += increment;
      y = (y == size.height) ? size.height * .97 : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

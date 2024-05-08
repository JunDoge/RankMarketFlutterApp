import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toss Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentMethod(title: 'Toss Payment'),
    );
  }
}

class PaymentMethod extends StatefulWidget {
  PaymentMethod({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PaymentMethod> {
  int amount = 15000;
  bool couponApplied = false;

  void applyDiscount(bool checked) {
    setState(() {
      couponApplied = checked;
      if (checked) {
        amount -= 5000;
      } else {
        amount += 5000;
      }
    });
  }

  void requestPayment() {
    // 토스 결제 서버와 통신하는 코드를 여기에 작성합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("상품 정보"),
          Text("토스 티셔츠"),
          Text("결제 금액: ${amount}원"),
          CheckboxListTile(
            title: Text("5,000원 할인받기"),
            value: couponApplied,
            onChanged: (bool? value) {
              applyDiscount(value ?? false);
            },
          ),
          Divider(),
          Text("결제 방법"),
          // 결제 방법을 표시하는 위젯을 여기에 추가합니다.
          Divider(),
          Text("약관 동의"),
          // 약관 동의를 표시하는 위젯을 여기에 추가합니다.
          ElevatedButton(
            onPressed: requestPayment,
            child: Text("결제하기"),
          ),
        ],
      ),
    );
  }
}

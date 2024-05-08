import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/receipt.dart';
import 'package:shop_app/repository/user/UserRepository.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

import 'main.dart';

class PaymentWidgetExamplePage extends StatefulWidget {
  final prd_ids;
  final total_price;
  final prd_price;
  final msg;
  final List<String> title;
  const PaymentWidgetExamplePage({super.key, required this.prd_ids, required this.total_price, required this.prd_price, required this.msg, required this.title});

  @override
  State<PaymentWidgetExamplePage> createState() {
    return _PaymentWidgetExamplePageState();
  }
}

class _PaymentWidgetExamplePageState extends State<PaymentWidgetExamplePage> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;


  @override
  void initState() {
    super.initState();

    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: "dd1hCIxuTOflUMDhkjg7G",
    );

    _paymentWidget
        .renderPaymentMethods(
        selector: 'methods',
        amount: Amount(value: widget.total_price, currency: Currency.KRW, country: "KR"),
        options: RenderPaymentMethodsOptions(variantKey: "DEFAULT"))
        .then((control) {
      _paymentMethodWidgetControl = control;
    });

    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {

    final int total_price = widget.total_price;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PaymentMethodWidget(
                    paymentWidget: _paymentWidget,
                    selector: 'methods',
                  ),
                  AgreementWidget(paymentWidget: _paymentWidget, selector: 'agreement'),
                  ElevatedButton(
                    onPressed: () async {
                      final paymentResult = await _paymentWidget.requestPayment(
                        paymentInfo: const PaymentInfo(
                          orderId: '5yaL0eNEnAlSEg5aOeNST',
                          orderName: '랭크마켓',
                        ),
                      );
                      if (paymentResult.success != null) {
                          UserRepository userRepository = UserRepository(Dio());
                          const storage = FlutterSecureStorage();
                          String? token = await storage.read(key: "token");
                          await userRepository.paySave(widget.prd_ids, widget.prd_price, widget.msg, token!);

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Receipt(
                            total_price: total_price, title : widget.title)));

                      } else if (paymentResult.fail != null) {
                        setState(() {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                                (route) => false,
                          );
                        });
                      }
                    },
                    child: const Text('결제하기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

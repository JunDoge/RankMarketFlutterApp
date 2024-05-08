import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/screens/report/report_screen.dart';

import '../../repository/user/UserRepository.dart';


final Map<int, String> _themeMode = {
  1: '사전고지한 상품정보와 상이',
  2: '주문취소 시 환불 거부',
  3: '가품의심',
  4: '안전거래 사칭 등 결제 관련 사기',
  5: '개인정보 관련 피해',
  6: '거래 당사자 간 연락 지연',
  7: '사용불가 제품',
  8: '무단 이미지 도용',
  9: '기타의견',
};


String selectedTheme = '사전고지한 상품정보와 상이';

class Complaint extends StatefulWidget {
  final prd_id;
  const Complaint({super.key, required this.prd_id});

  @override
  State<Complaint> createState() => _AutofillDemoState();
}

class _AutofillDemoState extends State<Complaint> {
  final _formKey = GlobalKey<FormState>();
  String? des;
  int report_id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신고',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            )),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: [
                  ...[
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Wrap(
                                children: _themeMode.entries.map((entry) {
                                  int key = entry.key;
                                  String value = entry.value;
                                  return ListTile(
                                    title: Text(value,
                                        textAlign: TextAlign.center),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedTheme = value;
                                        report_id = key;
                                        print("ddd $report_id");
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                                selectedTheme,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            onSaved: (newValue) => des = newValue,
                            textInputAction: TextInputAction.next,
                            maxLines: 7,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(28)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(28)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintText: '신고 내용을 적어주세요.',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: '',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ].expand(
                        (widget) => [
                      widget,
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            print("dkdkdkdkd");
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black38),
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async{
                            const storage = FlutterSecureStorage();
                            String? token = await storage.read(key: "token");
                            print("ㅇㅇㅇㅇ $report_id");
                            if (_formKey.currentState!.validate() && report_id > 0 && token != null) {
                              _formKey.currentState!.save();
                              UserRepository userRepository = UserRepository(Dio());
                              print("ssss $report_id");
                              await userRepository.reportSave(report_id.toString(), des!, widget.prd_id, token);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportScreen(),
                                ),
                              );
                            }
                          },
                          child: Text('저장'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            side: BorderSide(color: Colors.orange),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../main.dart';
import '../../repository/user/UserRepository.dart';

class AutofillDemo extends StatefulWidget {
  const AutofillDemo( {super.key,  this.refreshProfile});
  final refreshProfile;
  @override
  State<AutofillDemo> createState() => _AutofillDemoState();
}

class _AutofillDemoState extends State<AutofillDemo> {
  String? token;

  final _formKey = GlobalKey<FormState>();
  bool showVerificationField = false;
  bool isPhoneNumberReadOnly = false;
  bool changePhone = false;
  bool changeCode = false;
  bool changeName = false;
  bool changeAddr = false;
  bool isNotCode = false;
  String? name;
  String? ph_num;
  String? ph_code;
  String? post_code;
  String? adress;
  String? detail_adress;
  UserRepository userRepository = UserRepository(Dio());
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: "token");
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      });
    }
  }

  void _searchAddress(BuildContext context) async {
    Kpostal? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => KpostalView(),
      ),
    );

    if (model != null) {
      post_code = model.postCode ?? '';
      _postcodeController.value = TextEditingValue(
        text: post_code!,
      );

      adress = model.address ?? '';
      _addressController.value = TextEditingValue(
        text: adress!,
      );
    }
  }

  Future<bool> onWillPop() async {
    widget.refreshProfile();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('내 정보',
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
                        // const Text('This sample demonstrates autofill. '),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  name = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                  hintText: '여기에 닉네임을 입력하세요',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: '닉네임',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () async {
                                if (name != null) {
                                  List<String> updateColumn = ["usrNm"];
                                  List<String> updateValue = [name!];
                                  await userRepository.usrUpdate(
                                      updateColumn, updateValue, token!);
                                  await storage.write(
                                      key: "usrNm", value: name);
                                  setState(() {
                                    changeName = true;
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black38),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                '변경',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (changeName)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '변경 완료되었습니다.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  ph_num = value;
                                },
                                readOnly: isPhoneNumberReadOnly,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                  hintText: '여기에 전화번호를 입력하세요',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  labelText: '전화번호',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () async {
                                if (ph_num != null) {
                                  bool result = await userRepository
                                      .validatePhone(token!, ph_num!);
                                  if (result) {
                                    setState(() {
                                      showVerificationField = true;
                                      isPhoneNumberReadOnly = true;
                                    });
                                  } else {
                                    // 머시꺵이 할거임
                                  }
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black38),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                '인증',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (showVerificationField)
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    ph_code = value;
                                  },
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(28)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(28)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    hintText: '여기에 인증번호를 입력하세요',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    labelText: '인증번호',
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () async {
                                  if (ph_code != null) {
                                    bool result =
                                        await userRepository.validatePhoneCode(
                                            token!, ph_code!, ph_num!);
                                    if (result) {
                                      List<String> updateColumn = ["phNum"];
                                      List<String> updateValue = [ph_num!];
                                      await userRepository.usrUpdate(
                                          updateColumn, updateValue, token!);
                                      setState(() {
                                        changeCode = true;
                                        isNotCode = false;
                                      });
                                    } else {
                                      print("인증번호가 틀림");
                                      setState(() {
                                        changeCode = false;
                                        isNotCode = true;
                                      });
                                    }
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.black38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  '확인',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (changeCode)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                child: Text(
                                  '인증 완료되었습니다.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),

                        if (isNotCode)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                child: Text(
                                  '인증 번호 틀렸습니다.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _postcodeController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                  hintText: '여기에 우편번호를 입력하세요',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: '주소',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                ),
                                autofillHints: [AutofillHints.postalCode],
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => _searchAddress(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black38),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                '주소검색',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: _addressController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                            hintText: '여기에 도로명 주소를 입력하세요',
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: '도로명 주소',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                          ),
                          autofillHints: [AutofillHints.countryName],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  detail_adress = value;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                  hintText: '여기에 상세 주소를 입력하세요',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: '상세 주소',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                ),
                                autofillHints: [AutofillHints.countryCode],
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () async {
                                if (post_code != null && adress != null) {
                                  List<String> updateColumn = [
                                    "pstAddr",
                                    "rdAddr"
                                  ];
                                  List<String> updateValue = [
                                    post_code!,
                                    adress!
                                  ];
                                  if (detail_adress != null) {
                                    updateColumn.add("detAddr");
                                    updateValue.add(detail_adress!);
                                  }
                                  await userRepository.usrUpdate(
                                      updateColumn, updateValue, token!);

                                  setState(() {
                                    changeAddr = true;
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black38),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                '변경',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (changeAddr)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                child: Text(
                                  '변경 완료되었습니다.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await userRepository.usrDelete(token!);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                      setState(() {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MyApp()),
                                              (route) => false,
                                        );
                                      });

                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                side: BorderSide(color: Colors.white),
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                              ),
                              child: const Text('계정탈퇴',
                                  style: TextStyle(color: Colors.white)),
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
        ));
  }
}

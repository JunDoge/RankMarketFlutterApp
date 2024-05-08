import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/parameter/korea_price.dart';
import 'package:shop_app/repository/product/ProductRepository.dart';
import 'package:shop_app/screens/403error/403error_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../main.dart';
import 'category.dart';
import 'currency_input_formatter.dart';

class Upload extends StatefulWidget {
  static String routeName = "/upload";

  @override
  _AutofillDemoState createState() => _AutofillDemoState();
}

class _AutofillDemoState extends State<Upload> {




  DateTime? _lastBackPressed;
  bool _isRankBlank =false;
  String? token;

  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  List<XFile?> multiImageForAI = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> imagesForAI = []; // 가져온 사진들을 보여주기 위한 변수

  String? title;
  int? sell_price;
  String? des;
  String? significant;
  String? rank;
  int? high_price;
  String? text_high_price;



  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedCategory3;
  int? _selectedCategory4;


  ProductRepository productRepository = ProductRepository(Dio());



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






  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      final snackBar = SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _showFirstModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text('삼성'),
                onTap: () {
                  Navigator.pop(context); // 첫 번째 모달 닫기
                  setState(() {
                    _showSecondModal(context, '삼성');
                  });
                },
              ),
              ListTile(
                title: Text('아이폰'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showSecondModal(context, '아이폰');
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSecondModal(BuildContext context, String First) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        List<Widget> modelOptions = [];

        if (First == '삼성') {
          modelOptions = [
            ListTile(
              title: Text('갤럭시노트 시리즈'),
              onTap: () {
                Navigator.pop(context);
                _selectedCategory = '갤럭시노트 시리즈';
                setState(() {
                  _showThirdGaluxyModal(context, '갤럭시노트 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('갤럭시S 시리즈'),
              onTap: () {
                _selectedCategory = '갤럭시S 시리즈';
                Navigator.pop(context);
                setState(() {
                  _showThirdGaluxyModal(context, '갤럭시S 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('갤럭시Z 시리즈'),
              onTap: () {
                _selectedCategory = '갤럭시Z 시리즈';
                Navigator.pop(context);
                setState(() {
                  _showThirdGaluxyModal(context, '갤럭시Z 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('갤럭시A 시리즈'),
              onTap: () {
                _selectedCategory = '갤럭시A 시리즈';
                Navigator.pop(context);
                setState(() {
                  _showThirdGaluxyModal(context, '갤럭시A 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('갤럭시J 시리즈'),
              onTap: () {
                _selectedCategory = '갤럭시J 시리즈';
                Navigator.pop(context);
                setState(() {
                  _showThirdGaluxyModal(context, '갤럭시J 시리즈');
                });
              },
            ),
          ];
        } else if (First == '아이폰') {
          modelOptions = [
            ListTile(
              title: Text('iPhone15 시리즈'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'iPhone15 시리즈';
                  _showThirdiPhoneModal(context, 'iPhone15 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('iPhone14 시리즈'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'iPhone14 시리즈';
                  _showThirdiPhoneModal(context, 'iPhone14 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('iPhone13 시리즈'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'iPhone13 시리즈';
                  _showThirdiPhoneModal(context, 'iPhone13 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('iPhone12 시리즈'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'iPhone12 시리즈';
                  _showThirdiPhoneModal(context, 'iPhone12 시리즈');
                });
              },
            ),
            ListTile(
              title: Text('iPhone11 시리즈'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory = 'iPhone11 시리즈';
                  _showThirdiPhoneModal(context, 'iPhone11 시리즈');
                });
              },
            ),
          ];
        }
        return Container(
          height: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: modelOptions,
          ),
        );
      },
    );
  }

  void _showThirdGaluxyModal(BuildContext context, String Second) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        List<Widget> modelOptions = [];

        if (Second == '갤럭시노트 시리즈') {
          modelOptions = [
            ListTile(
              title: Text('갤럭시노트 20 Ultra'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 20 Ultra';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 20'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 20';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 10 Plus'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 10 Plus';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 10'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 10';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 9'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 9';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 8'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 8';
                });
              },
            ),
            ListTile(
              title: Text('갤럭시노트 5'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = '갤럭시노트 5';
                });
              },
            ),
          ];
        } else if (Second == '갤럭시S 시리즈') {
          modelOptions = [
            ListTile(
              title: Text("갤럭시 S23 Ultra"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S23 Ultra";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S23 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S23 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S23"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S23";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S23 FE"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S23 FE";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S22 Ultra"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S22 Ultra";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S22 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S22 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S22"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S22";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S21 Ultra"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S21 Ultra";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S21 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S21 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S21"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S21";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S20 Ultra"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S20 Ultra";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S20 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S20 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S20"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S20";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S20 FE 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S20 FE 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S10 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S10 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S10"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S10";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S10 E"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S10 E";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S9 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S9 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S9"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S9";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S8 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S8 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 S8"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 S8";
                });
              },
            ),
          ];
        } else if (Second == '갤럭시Z 시리즈') {
          modelOptions = [
            ListTile(
              title: Text("갤럭시 Z 폴드 5 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 폴드 5 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 플립 5 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 플립 5 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 폴드 4 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 폴드 4 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 폴드 3 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 폴드 3 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 플립 4 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 플립 4 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 플립 3 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 플립 3 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z 폴드 2 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z 폴드 2 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z플립 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z플립 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 Z플립 LTE"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 Z플립 LTE";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 폴드"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 폴드";
                });
              },
            ),
          ];
        } else if (Second == '갤럭시A 시리즈') {
          modelOptions = [
            ListTile(
              title: Text("갤럭시 A53"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A53";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A34 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A34 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A33 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A33 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A24"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A24";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A23"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A23";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A13"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A13";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 퀀텀4"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 퀀텀4";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 퀀텀3"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 퀀텀3";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 퀀텀2"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 퀀텀2";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A52S"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A52S";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A42"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A42";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 JUMP 3"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 JUMP 3";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 JUMP 2"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 JUMP 2";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 JUMP"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 JUMP";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 버디2"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 버디2";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 버디"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 버디";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A12"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A12";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A90 5G"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A90 5G";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A80"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A80";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A71"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A71";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A51"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A51";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A31"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A31";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A21S"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A21S";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A50"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A50";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A40"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A40";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A30"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A30";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A9 PRO"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A9 PRO";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A9"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A9";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 A5 2017"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 A5 2017";
                });
              },
            ),
          ];
        } else if (Second == '갤럭시J 시리즈') {
          modelOptions = [
            ListTile(
              title: Text("갤럭시 J4 Plus"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 J4 Plus";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 J6"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 J6";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 J7 2017"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 J7 2017";
                });
              },
            ),
            ListTile(
              title: Text("갤럭시 J3 2017"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedCategory3 = "갤럭시 J3 2017";
                });
              },
            ),
          ];
        }
        return Container(
          height: 900,
          child: ListView(
            children: modelOptions,
          ),
        );
      },
    );
  }

  void _showThirdiPhoneModal(BuildContext context, String Second) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> modelOptions = [];

          if (Second == 'iPhone15 시리즈') {
            modelOptions = [
              ListTile(
                title: Text('iPhone 15 Pro Max'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 =
                    'iPhone 15 Pro Max';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 15 Pro'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 15 Pro';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 15 Plus'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 15 Plus';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 15'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 15';
                  });
                },
              ),
            ];
          } else if (Second == 'iPhone14 시리즈') {
            modelOptions = [
              ListTile(
                title: Text('iPhone 14 Pro Max'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 =
                    'iPhone 14 Pro Max';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 14 Pro'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 14 Pro';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 14 Plus'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 14 Plus';
                  });
                },
              ),
              ListTile(
                title: Text('iPhone 14'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = 'iPhone 14';
                  });
                },
              ),
            ];
          } else if (Second == 'iPhone13 시리즈') {
            modelOptions = [
              ListTile(
                title: Text("iPhone 13 Pro Max"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 =
                    "iPhone 13 Pro Max";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 13 Pro"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 13 Pro";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 13"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 13";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 13 Mini"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 13 Mini";
                  });
                },
              ),
            ];
          } else if (Second == 'iPhone12 시리즈') {
            modelOptions = [
              ListTile(
                title: Text("iPhone 12 Pro Max"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 =
                    "iPhone 12 Pro Max";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 12"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 12";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 12 Mini"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 12 Mini";
                  });
                },
              ),
            ];
          } else if (Second == 'iPhone11 시리즈') {
            modelOptions = [
              ListTile(
                title: Text("iPhone 11 Pro Max"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 =
                    "iPhone 11 Pro Max";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 11 Pro"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 11 Pro";
                  });
                },
              ),
              ListTile(
                title: Text("iPhone 11"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory3 = "iPhone 11";
                  });
                },
              ),
            ];
          }
          return Container(
            height: 240,
            child: ListView(
              children: modelOptions,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('상품 등록',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
                          _showFirstModal(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCategory3 ?? '제품명',
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // 여기에 텍스트 추가
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'AI 외관 검사 *',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold), // 원하는 스타일을 적용하세요.
                            ),
                          ),
                          Row(
                            children: [
                              //카메라로 촬영하기
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 3, right: 9, top:10, bottom: 9),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: IconButton(
                                        onPressed: () async {
                                          image = await picker.pickImage(
                                              source: ImageSource.camera,
                                              preferredCameraDevice:
                                              CameraDevice.rear);
                                          //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
                                          if (image != null) {
                                            setState(() {
                                              imagesForAI.add(image);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          size: 30,
                                          color: Colors.black,
                                        ))),
                              ),
                              //갤러리에서 가져오기
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 4, right: 9, top:10, bottom: 9),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: IconButton(
                                        onPressed: () async {
                                          multiImageForAI =
                                          await picker.pickMultiImage();
                                          setState(() {
                                            imagesForAI.addAll(multiImageForAI);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                          color: Colors.black,
                                        ))),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _selectedCategory3 != null
                                        ? () async {
                                      if (kDebugMode) {
                                        print(_selectedCategory3);
                                      }

                                      var formData = FormData();

                                      for (var image in imagesForAI) {
                                        formData.files.add(MapEntry(
                                          "images",
                                          await MultipartFile.fromFile(
                                              image!.path,
                                              filename: image.name),
                                        ));
                                      }

                                      formData.fields.add(MapEntry(
                                          "cat_id", CategoryValues.getKey(_selectedCategory!, _selectedCategory3!)));

                                      print(_selectedCategory3!);
                                      print(_selectedCategory!);
                                      print(CategoryValues.getKey(_selectedCategory!, _selectedCategory3!));

                                      var rankingChecks =
                                      await productRepository
                                          .rankingCheck(
                                          token!, formData);

                                      setState(() {
                                        high_price =
                                            rankingChecks.response.price;
                                        text_high_price =  CurrencyUtil.currencyFormat(rankingChecks.response.price).toString();
                                        rank =
                                            rankingChecks.response.rank;
                                        _isRankBlank =
                                            true;
                                      });

                                      if (kDebugMode) {
                                        print(
                                            rankingChecks.response.rank);
                                        print(
                                            rankingChecks.response.price);
                                      }
                                    }
                                        : null,

                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return Colors
                                                .white70; // 비활성화 상태일 때의 배경색
                                          }
                                          return Colors.orange; // 기본 배경색
                                        },
                                      ),
                                      shape: MaterialStateProperty.resolveWith<
                                          OutlinedBorder>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  5), // 비활성화 상태일 때 모서리를 더 네모나게
                                            );
                                          }
                                          return RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4.0), // 기본 모서리 둥글기
                                          );
                                        },
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(50, 55)),
                                    ),
                                    child: const Text('검사시작',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                            childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
                            mainAxisSpacing: 10, //수평 Padding
                            crossAxisSpacing: 10, //수직 Padding
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < imagesForAI.length) {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(
                                                imagesForAI[index]!
                                                    .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                            )))),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                            maxWidth: 10, maxHeight: 10),
                                        icon: const Icon(Icons.close,
                                            color: Colors.white, size: 15),
                                        onPressed: () {
                                          setState(() {
                                            imagesForAI
                                                .remove(imagesForAI[index]);
                                          });
                                        },
                                      ))
                                ],
                              );
                            } else {
                              // 이미지가 없는 경우
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 15),
                              );
                            }
                          },
                        ),
                      ),
                      // _isRankBlank 값이 false이면 Text 위젯을 보여줌
                      if (_isRankBlank)
                        Align(
                          alignment: Alignment.centerLeft,

                        child: Text(
                          '고객님의 휴대폰 등급은 $rank급 입니다.',
                          style: const TextStyle(fontSize: 20),
                        ),
                        ),
                      // _isRankBlank 값이 true이면 아무것도 표시하지 않음
                      if (!_isRankBlank) const SizedBox(height: 20),
                      Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '추가 상품 사진',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold), // 원하는 스타일을 적용하세요.
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 3, right: 9, top:10, bottom: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: IconButton(
                                        onPressed: () async {
                                          image = await picker.pickImage(
                                              source: ImageSource.camera);
                                          if (image != null) {
                                            setState(() {
                                              images.add(image);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          size: 30,
                                          color: Colors.black,
                                        ))),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin: const EdgeInsets.only(left: 4, right: 9, top:10, bottom: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: IconButton(
                                        onPressed: () async {
                                          multiImage =
                                          await picker.pickMultiImage();
                                          setState(() {
                                            images.addAll(multiImage);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                          color: Colors.black,
                                        ))),
                              ),
                              Expanded(
                                child: Container(), // 빈 Container로 공간을 차지합니다.
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                            childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
                            mainAxisSpacing: 10, //수평 Padding
                            crossAxisSpacing: 10, //수직 Padding
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(images[index]!
                                              .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                          )))),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.close,
                                          color: Colors.white, size: 15),
                                      onPressed: () {
                                        setState(() {
                                          images.remove(images[index]);
                                        });
                                      },
                                    ))
                              ],
                            );
                          },
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "제목 *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onSaved: (newValue) => title = newValue,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              hintText: '제목을 입력해주세요',
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(
                                      10) // Border color when enabled
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            autofillHints: const [AutofillHints.givenName],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "시작가 *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onSaved: (newValue) {
                              if (newValue != null) {
                                String sanitizedValue = newValue.replaceAll(',', ''); // 쉼표 제거
                                sell_price = int.tryParse(sanitizedValue) ?? 0; // 숫자로 변환 후 할당, 실패 시 기본값으로 0 사용

                              }
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters : [CurrencyInputFormatter()],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              hintText: '시작가를 입력해주세요',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.black38),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            autofillHints: const [AutofillHints.familyName],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "예상가",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            readOnly: true,
                            // initialValue:  text_high_price,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              // hintText: '예상가',
                              hintStyle:  text_high_price != null
                                  ? const TextStyle(color: Colors.black)
                                  : const TextStyle(color: Colors.grey),
                              hintText: text_high_price ?? "예상가",
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            autofillHints: const [AutofillHints.familyName],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "입찰가격 선택 *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),


                          DropdownButtonHideUnderline(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black38),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {},
                          child: DropdownButton<int>(
                            value: _selectedCategory4,
                            isExpanded: true,
                            onChanged: (int? value) {
                              if (value != null &&
                                  value != _selectedCategory4) {
                                setState(() {
                                  _selectedCategory4 = value;
                                });
                              }
                            },
                            items: const [
                              DropdownMenuItem<int>(
                                value: 1000,
                                child: Text("1000"),
                              ),
                              DropdownMenuItem<int>(
                                value: 5000,
                                child: Text("5000"),
                              ),
                              DropdownMenuItem<int>(
                                value: 10000,
                                child: Text("10000"),
                              ),
                            ],
                            hint: const Text('입찰 시작 가격 선택'),
                          ),
                        ),
                      ),
                      ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "특이사항 *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onSaved: (newValue) => significant = newValue,
                            maxLines: null,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              hintText: '특이사항을 입력해주세요',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.black38),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.orange),
                                // Maintain the same color for focused border
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "상품 상세 정보  *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onSaved: (newValue) => des = newValue,
                            maxLines: 5,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10),
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.orange),
                                // Maintain the same color for focused border
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(width: 20),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  print(sell_price);
                                  print(rank);
                                  print(high_price);
                                  print(significant);
                                  print(title);
                                  print(_selectedCategory3);
                                  print(_selectedCategory4);
                                  print(des);


                                  try {
                                    if (images.isNotEmpty && rank != null) {
                                      var formData = FormData();

                                      for (var image in images) {
                                        formData.files.add(MapEntry(
                                          "images",
                                          await MultipartFile.fromFile(
                                              image!.path,
                                              filename: image.name),
                                        ));
                                      }

                                      formData.fields.add(MapEntry("cat_id",
                                          CategoryValues.getKey(_selectedCategory!, _selectedCategory3!) + rank!));

                                      formData.fields
                                          .add(MapEntry("title", title!));

                                      formData.fields.add(MapEntry(
                                          "sel_prc", sell_price!.toString()));
                                      formData.fields.add(MapEntry(
                                          "high_prc", high_price!.toString()));

                                      formData.fields.add(MapEntry(
                                          "iseat_price",
                                          _selectedCategory4!.toString()));

                                      formData.fields
                                          .add(MapEntry("des", des!));

                                      formData.fields.add(MapEntry(
                                          "significant", significant!));

                                      productRepository.upload(
                                          token!, formData);
                                    }
                                  } catch (e) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ErrorScreen()),
                                    );
                                  }

                                  setState(() {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyApp()),
                                          (route) => false,
                                    );
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                side: const BorderSide(color: Colors.orange),
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: const Text('등록하기'),
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
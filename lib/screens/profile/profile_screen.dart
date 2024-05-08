import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/screens/review/review_screen.dart';

import '../../main.dart';
import '../payment/payment_history.dart';
import '../product_management/products_screen2.dart';
import '../report/report_screen.dart';
import '../sign_in/sign_in_screen.dart';
import '../transaction/transaction_history.dart';
import '../usr_update/autofill.dart';
import '../wish/wish_list.dart';
import 'components/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime? _lastBackPressed;
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      const snackBar = SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }

  refreshProfile() {
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: storage.read(key: "usrNm"),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        var usrNm = snapshot.data ?? "로그인 해주세요";

        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "프로필",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "고객 이름",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            usrNm,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: buildLoginMenu(context, snapshot.data),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "개인정보수정",
                          "assets/icons/User_Icon.svg",
                          AutofillDemo(refreshProfile:  refreshProfile),
                        ),
                      ),
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "상품 관리",
                          "assets/icons/Parcel.svg",
                          const ProductManagement(),
                        ),
                      ),
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "거래 내역",
                          "assets/icons/Bill_Icon.svg",
                          const ReviewDemo2(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "결제 내역",
                          "assets/icons/pay.svg",
                          const PaymentHistory(),
                        ),
                      ),
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "후기",
                          "assets/icons/review.svg",
                          const Review(),
                        ),
                      ),
                      Expanded(
                        child: buildProfileMenu(
                          context,
                          "신고",
                          "assets/icons/report1.svg",
                          const ReportScreen(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: buildProfileMenu(
                          context,
                          "찜 목록",
                          "assets/icons/Heart_Icon.svg",
                          const WishList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildProfileMenu(
      BuildContext context,
      String text,
      String icon,
      Widget? page,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: ProfileMenu(
        text: text,
        icon: icon,
        press: () {
          if (page != null) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => page,
            ));
          }
        },
      ),
    );
  }

  Widget buildLoginMenu(BuildContext context, String? usrNm) {
    return ListTile(
      onTap: () {
        if (usrNm == null) {
          // 로그인 화면으로 이동
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignInScreen()));
        } else {
          // 로그아웃 확인 모달 띄우기
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('로그아웃'),
                content: const Text('정말로 로그아웃 하시겠습니까?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('아니오'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('네'),
                    onPressed: () {
                      const storage = FlutterSecureStorage();
                      storage.delete(key: "token");
                      storage.delete(key: "usrNm");
                      setState(() {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                              (route) => false,
                        );
                      });
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      leading: usrNm == null
          ? SvgPicture.asset("assets/icons/Login.svg")
          : SvgPicture.asset("assets/icons/Log_out.svg"),
      title: SizedBox(
        child: Text(
          usrNm == null ? '로그인' : '로그아웃',
        ),
      ),
    );
  }

}

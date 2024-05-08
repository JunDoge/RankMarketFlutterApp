import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/screens/sign_in/components/google_login.dart';
import 'package:shop_app/screens/sign_in/components/naver_login.dart';

import '../../components/sign_form.dart';
import '../../main.dart';
import 'components/kakao_login.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  String _message =  "어서오세요";
  final KakaoLogin kakaoLogin = KakaoLogin();
  final NaverLogin naverLogin = NaverLogin();
  final GoogleLogin googleLogin = GoogleLogin();
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _message));
  }

  final storage = const FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_message),
                  const Text(
                    "소셜 계정으로 로그인",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignForm(),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            // 버튼 눌렸을 때
                            await kakaoLogin.login(context);
                            String? loginSuccess = await storage.read(key: 'token');
                            if (loginSuccess != null) {
                              setState(() {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()),
                                      (route) => false,
                                );
                              });
                            } else {
                              setState(()  {
                                _message = "토큰이없습니다.";
                              });
                            }

                          },
                          icon: SvgPicture.asset(
                              'assets/icons/kakao_button.svg')),
                      IconButton(
                          onPressed: () async {
                            // 버튼 눌렸을 때
                            await naverLogin.login(context);
                            String? loginSuccess = await storage.read(key: 'token');
                            if (loginSuccess != null) {
                              setState(() {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()),
                                      (route) => false,
                                );
                              });
                            } else {
                              setState(()  {
                                _message = "토큰이없습니다.";
                              });
                            }
                          },
                          icon: SvgPicture.asset(

                              'assets/icons/naver_button.svg')),
                      IconButton(
                          onPressed: () async {
                            // 버튼 눌렸을 때
                            await googleLogin.login(context);
                            String? loginSuccess = await storage.read(key: 'token');
                            if (loginSuccess != null) {
                              setState(() {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()),
                                      (route) => false,
                                );
                              });
                            } else {
                              setState(()  {
                                _message = "토큰이없습니다.";
                              });
                            }
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/google_button.svg')),
                    ],
                  ),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

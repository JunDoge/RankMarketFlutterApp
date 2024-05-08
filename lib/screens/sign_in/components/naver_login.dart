import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../../../models/user/UserToken.dart';
import '../../../parameter/sign_up_arguments.dart';
import '../../sign_up/sign_up_screen.dart';
import 'firebase_token.dart';

class NaverLogin {
  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    NaverLoginResult _result = await FlutterNaverLogin.logIn();
    String id = _result.account.id;

    print("이메일 =================================$_result");
    String? token = await FirebaseService.getFirebaseToken();
    UserToken userToken =
    await userRepository.getUser(_result.account.email,token!);
    String tokenFromHeader = 'Bearer ${userToken.token}';

    if(userToken.response.mail == null) {

      await storage.write(key: 'token', value: tokenFromHeader);
      await storage.write(key: 'usrNm', value: userToken.response.usrNm);
    } else {
      Navigator.pushNamed(
          context,
          SignUpScreen.routeName,
          arguments: SignUpArguments(token: tokenFromHeader,
              mail: _result.account.email,
              usrNm: _result.account.name)
      );
    }
  }
}
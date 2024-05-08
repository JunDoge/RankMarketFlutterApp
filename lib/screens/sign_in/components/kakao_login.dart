import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shop_app/models/user/UserToken.dart';
import 'package:shop_app/parameter/sign_up_arguments.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../../sign_up/sign_up_screen.dart';
import 'firebase_token.dart';

class KakaoLogin {
  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        User user = await UserApi.instance.me();
        String? token = await FirebaseService.getFirebaseToken();
        UserToken userToken =
        await userRepository.getUser(user.kakaoAccount?.email as String, token!);
        String tokenFromHeader = 'Bearer ${userToken.token}';

        if(userToken.response.mail == null) {

          await storage.write(key: 'token', value: tokenFromHeader);
          await storage.write(key: 'usrNm', value: userToken.response.usrNm);
        } else {
          Navigator.pushNamed(
              context,
              SignUpScreen.routeName,
              arguments: SignUpArguments(token: tokenFromHeader,
                  mail: user.kakaoAccount!.email!,
                  usrNm: user.kakaoAccount!.profile!.nickname!)
          );
        }

      } catch (error) {
        print("에러임ㅋㅋ $error");
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();
        String? token = await FirebaseService.getFirebaseToken();
        UserToken userToken =
        await userRepository.getUser(user.kakaoAccount?.email as String, token!);
        String tokenFromHeader = 'Bearer ${userToken.token}';

        if(userToken.response.mail == null) {

          await storage.write(key: 'token', value: tokenFromHeader);
          await storage.write(key: 'usrNm', value: userToken.response.usrNm);
        }  else {
          Navigator.pushNamed(
              context,
              SignUpScreen.routeName,
              arguments: SignUpArguments(token: tokenFromHeader,
                  mail: user.kakaoAccount!.email!,
                  usrNm: user.kakaoAccount!.profile!.nickname!)
          );
        }

      } catch (error) {
        print("에러임ㅋㅋ $error");
      }
    }
  }
}
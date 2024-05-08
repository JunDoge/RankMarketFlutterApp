import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../../../models/user/UserToken.dart';
import '../../../parameter/sign_up_arguments.dart';
import '../../sign_up/sign_up_screen.dart';
import 'firebase_token.dart';

class GoogleLogin {
  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  Future<void> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      String? token = await FirebaseService.getFirebaseToken();
      UserToken userToken =
      await userRepository.getUser(googleSignInAccount!.email, token!);
      String tokenFromHeader = 'Bearer ${userToken.token}';

      if (userToken.response.mail == null) {
        await storage.write(key: 'token', value: tokenFromHeader);
        await storage.write(key: 'usrNm', value: userToken.response.usrNm);

      } else {
        Navigator.pushNamed(
            context,
            SignUpScreen.routeName,
            arguments: SignUpArguments(token: tokenFromHeader,
                mail: googleSignInAccount!.email,
                usrNm: googleSignInAccount!.displayName!));
      }
    } catch (error) {
      print(error);
      throw Exception('Google Sign-In failed');
    }
  }
}


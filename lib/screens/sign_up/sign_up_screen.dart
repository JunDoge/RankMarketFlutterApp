import 'package:flutter/material.dart';

import '../../parameter/sign_up_arguments.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/sign_up_form.dart';

//회원가입
class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    if(routeSettings != null) {
      SignUpArguments args = routeSettings.arguments as SignUpArguments;
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "회원가입",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    SignUpForm(signUpArguments: args),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      });
      return Container();
    }


  }
}
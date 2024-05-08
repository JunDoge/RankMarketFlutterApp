import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Container(
          width: MediaQuery.of(context).size.width / 3, // 버튼의 너비를 고정
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                color: kPrimaryColor,
                width: 22,
                height: 25,
              ),
              const SizedBox(width: 20),
              const SizedBox(height: 5),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

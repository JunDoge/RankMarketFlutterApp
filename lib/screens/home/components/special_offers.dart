import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric( vertical: 10),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1.0,
          ),
          items: const [
            SpecialOfferCard(
              image: 'assets/images/mainSlice1.png',
              title: "실시간 스마트 경매",
              des: "AI가 실시간으로 휴대폰을 진단,\n 최고가 판매를 보장합니다",
            ),
            SpecialOfferCard(
              image: 'assets/images/mainSlice2.png',
              title: "신뢰성 높은 중고 거래",
              des: "고급 AI 판정 기술을 사용해,\n 적절한 인증 등급을\n 측정해드립니다.",

            ),
            SpecialOfferCard(
              image: 'assets/images/splash_2.png',
              title: "안심 직거래 서비스",
              des: "등급을 표시하여 안심하고\n 믿을 수 있는 직거래 서비스를 \n 제공합니다.",
            ),
          ],
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.title,
    required this.image,
    required this.des,
  }) : super(key: key);

  final String title, image, des;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 400 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [

            Container(
              width: 180,
              height: 150,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "$title",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "\n\n$des\n\n",
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/product/Popular.dart' as Pop;  // 별칭 추가

import '../../../components/popular_card.dart';
import '../../../parameter/product_details_arguments.dart';
import '../../../repository/product/ProductRepository.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productRepository = ProductRepository(Dio());

    return FutureBuilder<Pop.Populars>(  // 별칭 사용
      future: productRepository.getPopular(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Popular = snapshot.data;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "경매 인기 상품",
                  press: () {
                    Navigator.pushNamed(context, ProductsScreen.routeName);
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      Popular!.response.length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Builder( // Builder 위젯 사용
                            builder: (BuildContext context) {
                              return Column(
                                children: [
                                  PopularCard(
                                    popular: Popular.response[index],
                                    onPress: () => Navigator.pushNamed(
                                      context,
                                      DetailsScreen.routeName,
                                      arguments: ProductDetailsArguments(prd_id: Popular.response[index].prd_id),
                                    ),
                                  ),

                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 20),
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}


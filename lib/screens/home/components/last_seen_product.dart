import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/mosts_card.dart';

import '../../../models/product/Mosts.dart';
import '../../../parameter/product_details_arguments.dart';
import '../../../repository/product/ProductRepository.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class LastSeen_product extends StatelessWidget {
  const LastSeen_product({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productRepository = ProductRepository(Dio());

    return FutureBuilder<Mosts>(  // 별칭 사용
      future: productRepository.getMosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final mosts = snapshot.data;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "최근 등록된 상품",
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
                      mosts!.response.length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Builder( // Builder 위젯 사용
                            builder: (BuildContext context) {
                              return Column(
                                children: [
                                  MostsCard(
                                    mosts: mosts.response[index],
                                    onPress: () => Navigator.pushNamed(
                                      context,
                                      DetailsScreen.routeName,
                                      arguments: ProductDetailsArguments(prd_id: mosts.response[index].prd_id),
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


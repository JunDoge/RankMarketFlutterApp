import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/product/ProductDetail.dart';

import '../../parameter/product_details_arguments.dart';
import '../../repository/product/ProductRepository.dart';
import '../home/components/search_field.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  static String routeName = "/details";

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  ProductDetails? productDetails;
  String? token;
  bool _isBidEnabled = false;
  int bid_price = 0;
  int ieast_price = 0;
  final GlobalKey<ProductDescriptionState> _productDescriptionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadProductDetails() async {
    final routeSettings = ModalRoute.of(context)?.settings;
    final arguments = routeSettings?.arguments as ProductDetailsArguments?;
    final productRepository = ProductRepository(Dio());
    if (arguments != null) {
      productDetails =
          await productRepository.getProductDetail(arguments.prd_id);
      bid_price = productDetails!.response.bid_price;
      ieast_price = productDetails!.response.ieast_price;
      _bidStatus();
    }
  }

  _loadToken() async {
    const storage = FlutterSecureStorage();
    token = await storage.read(key: "token");
    _loadProductDetails();
  }

  _bidStatus() {
    setState(() {
      bid_price += ieast_price;
      _isBidEnabled = productDetails!.response.high_price >= bid_price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFF5F6F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            title: const SearchField(),
          ),
          body: productDetails != null
              ? ListView(
                  children: [
                    ProductImages(product: productDetails!.response),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ProductDescription(
                            key: _productDescriptionKey,
                            productDetails: productDetails!.response,
                            pressOnSeeMore: () {},
                          ),
                          const TopRoundedContainer(
                            color: Color(0xFFF6F7F9),
                            child: Column(
                              children: [
                                // ColorDots(product: product),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
          bottomNavigationBar: productDetails != null
              ? TopRoundedContainer(
                  color: Colors.white,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (token != null && _isBidEnabled) {
                            setState(() {
                              productDetails!.response.bid_price;
                              _bidStatus();
                            });
                            print("ㅋㅋㅋㅋ $_isBidEnabled");
                            await ProductRepository(Dio()).bidSave(
                              productDetails!.response.prd_id,
                              productDetails!.response.ieast_price,
                              productDetails!.response.high_price,
                              token!,
                            );
                            _productDescriptionKey.currentState?.updateBidPrice(
                                productDetails!.response.ieast_price);

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (token != null || _isBidEnabled || DateTime.now().isAfter(DateTime.parse(productDetails!.response.end_dtm)))
                              ? null
                              : Colors.grey,
                        ),
                        child: Text(
                            "입찰하기 (${productDetails!.response.ieast_price})"),
                      ),
                    ),
                  ),
                )
              : null,
        ));
  }
}

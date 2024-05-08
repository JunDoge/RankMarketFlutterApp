import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/product/Products.dart' as prd;
import 'package:shop_app/screens/home/components/search_field.dart';

import '../../components/product_card6.dart';
import '../../parameter/product_details_arguments.dart';
import '../../repository/product/ProductRepository.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  static String routeName = "/products";
  final String? prdNm;

  const ProductsScreen({required this.prdNm});
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  DateTime? _lastBackPressed;

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    // if (_lastBackPressed == null || now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
    //   _lastBackPressed = now;
    //   final snackBar = SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   return Future.value(false);
    // }
    return Future.value(true);
  }

  final productRepository = ProductRepository(Dio());
  final items = <prd.Product>[];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      final product = await productRepository.getProduct(currentPage,token, widget.prdNm);
      setState(() {
        items.addAll(product.response);
        currentPage += 20;
        isLoading = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const SearchField(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = items[index];
                      return ProductCard6(
                        product: item,
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments: ProductDetailsArguments(prd_id: item.prd_id),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
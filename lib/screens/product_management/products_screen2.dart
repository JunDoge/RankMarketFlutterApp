import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/components/product_card2.dart';
import 'package:shop_app/models/user/PrdMgmts.dart';

import '../../parameter/product_details_arguments.dart';
import '../../repository/user/UserRepository.dart';
import '../details/details_screen.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  static String routeName = "/productMangement";
  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  late Future<PrdMgmts> _prdMgmtsFuture;
  late String _token;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        _token = token;
        _prdMgmtsFuture = UserRepository(Dio()).getPrdMgmts(token);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });
    }
  }

  void _deleteProduct(int index) {
    setState(() {
      // Modify the list in the state
      _prdMgmtsFuture.then((prdMgmts) {
        prdMgmts.response.removeAt(index);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('상품이 삭제되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prdMgmtsFuture,
      builder: (BuildContext context, AsyncSnapshot<PrdMgmts> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          PrdMgmts prdMgmt = snapshot.data!;
          if (prdMgmt.response.isEmpty) {
            return const NoProductPage(msg: "쓴 글이 없습니다.");
          }

          return ProductManagementBody(
            prdMgmt: prdMgmt,
            token: _token,
            onDelete: _deleteProduct,
          );
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print("${snapshot.error}");
          }
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(); // You can return a loading widget here if needed
        }
      },
    );
  }
}

class ProductManagementBody extends StatelessWidget {
  const ProductManagementBody({
    Key? key,
    required this.prdMgmt,
    required this.token,
    required this.onDelete,
  }) : super(key: key);

  final PrdMgmts prdMgmt;
  final String token;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("상품관리", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return ProductCard2(
                      prdMgmt: prdMgmt.response[index],
                      token: token,
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(
                          prd_id: prdMgmt.response[index].prd_id,
                        ),
                      ),
                      onDelete: () => onDelete(index),
                    );
                  },
                  childCount: prdMgmt.response.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/repository/product/ProductRepository.dart';
import 'package:shop_app/screens/403error/403error_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../main.dart';
import '../../models/product/ProductDetail.dart';

class Update extends StatefulWidget {
  static String routeName = "/update";
  final int prd_id;

  Update({required this.prd_id});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  XFile? image;
  List<XFile?> multiImage = [];
  List<XFile?> images = [];

  String? token;
  String? title;
  String? des;
  String? significant;
  int? _selectedCategory4;

  ProductRepository productRepository = ProductRepository(Dio());
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  ProductDetails? productDetails;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadProductDetails();
  }

  _loadToken() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: "token");
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });
    }
  }

  _loadProductDetails() async {
    final productRepository = ProductRepository(Dio());
    productDetails = await productRepository.getProductDetail(widget.prd_id);
    setState(() {
      _selectedCategory4 = productDetails?.response.ieast_price;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadToken();
    _loadProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '상품 수정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: productDetails == null
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "제목 *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: productDetails?.response.title,
                  onSaved: (newValue) => title = newValue,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                    hintText: '제목을 입력해주세요',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  autofillHints: [AutofillHints.givenName],
                ),
                SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "입찰가격 선택 *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black38),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {},
                    child: DropdownButton<int>(
                      value: _selectedCategory4,
                      isExpanded: true,
                      onChanged: (int? value) {
                        if (value != null && value != _selectedCategory4) {
                          setState(() {
                            _selectedCategory4 = value;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1000,
                          child: Text("1000"),
                        ),
                        DropdownMenuItem<int>(
                          value: 5000,
                          child: Text("5000"),
                        ),
                        DropdownMenuItem<int>(
                          value: 10000,
                          child: Text("10000"),
                        ),
                      ],
                      hint: Text('입찰 시작 가격 선택'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "특이사항 *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: productDetails?.response.significant,
                      onSaved: (newValue) => significant = newValue,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                        hintText: '특이사항을 입력해주세요',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "상품 상세 정보  *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: productDetails?.response.des,
                      onSaved: (newValue) => des = newValue,
                      maxLines: 5,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        hintText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          _formKey.currentState!.save();

                          print(significant);
                          print(title);
                          print(des);
                          print(_selectedCategory4);
                          try {
                            var formData = FormData();

                            for (var image in images) {
                              formData.files.add(MapEntry(
                                "imgs",
                                await MultipartFile.fromFile(
                                  image!.path,
                                  filename: image.name,
                                ),
                              ));
                            }
                           if (_formKey.currentState!.validate() && _selectedCategory4 != null) {
                                 _formKey.currentState!.save();
                                 formData.fields.add(MapEntry("title", title!));

                                 formData.fields.add(MapEntry(
                                   "ieast_prc",
                                   _selectedCategory4!.toString(),
                                 ));

                                 formData.fields.add(MapEntry("des", des!));

                                 formData.fields.add(MapEntry("significant", significant!));

                                 formData.fields.add(MapEntry("prd_id", widget.prd_id.toString()));
                                 productRepository.prdUpdate(token!, formData);
                           }


                          } catch (e) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ErrorScreen(),
                              ),
                            );
                          }

                          setState(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                                  (route) => false,
                            );
                          });

                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text('등록하기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

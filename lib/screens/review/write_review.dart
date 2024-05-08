import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/screens/review/review_screen.dart';

import '../../repository/user/UserRepository.dart';

class Rating extends StatefulWidget {
  final prd_id;

  const Rating({super.key, required this.prd_id});

  @override
  State<Rating> createState() => _AutofillDemoState();
}

class _AutofillDemoState extends State<Rating> {
  final _formKey = GlobalKey<FormState>();
  int rate = 0;
  String? des;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 후기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            )),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: [
                  ...[
                    // const Text('This sample demonstrates autofill. '),

                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        rate = rating.toInt();
                        print(rate);
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            onSaved: (newValue) => des = newValue,
                            textInputAction: TextInputAction.next,
                            maxLines: 7,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintText: '거래 후기를 적어주세요.',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: '',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ].expand(
                    (widget) => [
                      widget,
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black38),
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            const storage = FlutterSecureStorage();
                            String? token = await storage.read(key: "token");
                            if (_formKey.currentState!.validate() &&
                                rate > 0 &&
                                token != null) {
                              _formKey.currentState!.save();
                              UserRepository userRepository =
                                  UserRepository(Dio());
                              await userRepository.reviewSave(
                                  rate, des!, widget.prd_id, token);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Review(),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                          child: Text('저장'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

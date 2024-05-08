import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shop_app/models/user/UserToken.dart';
import 'package:shop_app/parameter/sign_up_arguments.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../sign_in/components/firebase_token.dart';

class SignUpForm extends StatefulWidget {
  final SignUpArguments signUpArguments;

  const SignUpForm({Key? key, required this.signUpArguments}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class SignUpModal extends StatefulWidget {
  const SignUpModal({Key? key}) : super(key: key);

  @override
  _SignUpModalState createState() => _SignUpModalState();
}




class _SignUpModalState extends State<SignUpModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          style: TextStyle(fontSize: 18),
          '이미 회원가입된 회원입니다'),
      content: const Text(
          style: TextStyle(fontSize: 14),
          '이미 가입된 전화번호입니다. 로그인하거나 다른 번호로 회원가입해주세요.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 모달 닫기
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp() ));
            setState(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
              );
            });

          },
          child: Text('확인'),
        ),
      ],
    );
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? mail;
  String? name;
  String? birthday;
  String? phone_number;
  String? phone_code;
  String? detailAddress;
  DateTime? selectedDate;
  String? postcode;
  String? baseAdress;
  bool validate = false;
  bool validateCode = false;
  bool isNotCode = false;
  final List<String?> errors = [];
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
  TextEditingController();
  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();
  Map<String, String> formData = {};



  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void _searchAddress(BuildContext context) async {
    Kpostal? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => KpostalView(),
      ),
    );

    if (model != null) {
      postcode = model.postCode ?? '';
      _postcodeController.value = TextEditingValue(
        text: postcode!,
      );
      formData['postcode'] = postcode!;

      baseAdress = model.address ?? '';
      _addressController.value = TextEditingValue(
        text: baseAdress!,
      );
      formData['address'] = baseAdress!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.signUpArguments.usrNm,
            onSaved: (newValue) => name = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null; // validator가 값을 올바르게 반환하도록 수정
            },
            decoration:  InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              hintText: '닉네임을 입력하세요',
              hintStyle: const TextStyle(color: Colors.grey),
              labelText: '닉네임',
              labelStyle: TextStyle(color: Colors.grey[700]),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),


          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              labelStyle:  TextStyle(color: Colors.grey[700]),
              labelText: "생년월일",
              hintStyle:  selectedDate != null
                  ? const TextStyle(color: Colors.black)
                  : const TextStyle(color: Colors.grey),
              hintText: selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : "생년월일을 입력하세요",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  // datePicker를 통해 날짜를 선택
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != selectedDate) {
                    // 날짜를 선택한 경우 상태를 업데이트하고 onSaved에 저장
                    setState(() {
                      selectedDate = pickedDate;
                    });
                    // onSaved에 선택한 날짜를 저장
                    _formKey.currentState?.save();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: widget.signUpArguments.mail,
            readOnly: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              }
              return null;
            },
            decoration:  InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              hintStyle: const TextStyle(color: Colors.grey),
              // labelText: '닉네임',
              labelStyle: TextStyle(color: Colors.grey[700]),
              labelText: "이메일",
              hintText: "이메일을 입력하세요",
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      onSaved: (newValue) => phone_number = newValue,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          phone_number = value;
                          if (value.isNotEmpty) {
                            removeError(error: kPhoneNumberNullError);
                          }
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kPhoneNumberNullError);
                          return "";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        // floatingLabelBehavior: FloatingLabelBehavior.auto,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        labelText: "전화번호",
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintText: "전화번호를 입력하세요",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(width:5 ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('확인',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      print(widget.signUpArguments.token);
                      if (phone_number != null) {
                        bool validateResult =
                        await userRepository.validatePhone(
                            widget.signUpArguments.token, phone_number!);
                        if(validateResult){
                          setState(() {
                            validate = validateResult;
                          });
                        }else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SignUpModal(); // 위에서 만든 모달을 띄웁니다.
                            },
                          );
                        }


                        print("validate $validate");
                      }
                    },
                  ),
                ],
              ),
              if (validate) ...[
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onSaved: (newValue) => phone_code = newValue,
                        onChanged: (value) {
                          setState(() {
                            phone_code = value;
                            if (value.isNotEmpty) {
                              removeError(error: kPassNullError);
                            }
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: kPassNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          labelText: "인증번호",
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "인증번호를 입력하세요",
                        ),
                      ),
                    ),

                    const SizedBox(width:5),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('확인',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () async {
                        print(widget.signUpArguments.token);
                        if (phone_code != null) {
                          bool validateResult =
                          await userRepository.validatePhoneCode(
                              widget.signUpArguments.token,
                              phone_code!,
                              phone_number!);

                          setState(() {
                            if(validateResult){
                              validateCode = validateResult;
                              isNotCode = false;
                            }else{
                              isNotCode = true;
                              validateCode = validateResult;
                            }

                          });

                          print("validateCode $validateCode");
                        }
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (validateCode)
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    '인증 완료되었습니다.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),

          if(isNotCode)
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    '인증 번호 틀렸습니다.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _postcodeController,
                  decoration:  InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: '우편번호',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    labelText: '우편번호',
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 5), // 우편번호와 주소 검색 버튼 사이 여백 조절
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => _searchAddress(context),
                child: Container(
                  child: const Text('주소검색',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // 여백 조절
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _addressController,
                decoration:  InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: '기본주소',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  labelText: '기본주소',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20), // 기본주소와 상세주소 사이 여백 조절
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _addressDetailController,
                decoration:  InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: '상세주소 입력하세요',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  labelText: '상세주소',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && validateCode) {
                _formKey.currentState!.save();
                print(phone_number);
                print(postcode);
                print(baseAdress);
                String selectedDateString = selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : "";

                String? deviceToken = await FirebaseService.getFirebaseToken();
                UserToken userToken = await userRepository.signUp(
                    widget.signUpArguments.mail,
                    name!,
                    selectedDateString,
                    phone_number!,
                    postcode!,
                    baseAdress!,
                    detailAddress,
                    widget.signUpArguments.token,
                    deviceToken!);

                String tokenFromHeader = 'Bearer ${userToken.token}';
                await storage.write(key: 'token', value: tokenFromHeader);
                await storage.write(
                    key: 'usrNm', value: userToken.response.usrNm);


                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false,
                  );
                });
              }
            },
            child: const Text("회원가입"),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';

class ErrorScreen extends StatefulWidget {
  static String routeName = "/error";
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  _ErrorScreen createState() => _ErrorScreen();
}

class _ErrorScreen extends State<ErrorScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("403 error"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, size: 35),
            const Text("요청하신 페이지에 접근권한이 없습니다. ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700, height: 3)),
            const Text("연결하려는 페이지에 접근권한이 없어 접근이 거부되었습니다."),
            const Text("서비스 이용에 불편을 드려 죄송합니다.", style: TextStyle(height: 3),),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                },
                  child: const Text('이전페이지로'),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromARGB(238, 238, 238, 238),
                      side: BorderSide(color: Color.fromARGB(238, 238, 238, 238),),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),

                ),
                SizedBox(width: 16),
                OutlinedButton(onPressed: (){
                  setState(() {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                          (route) => false,
                    );
                  });
                },
                  child: const Text('메인페이지로'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    side: BorderSide(color: Colors.orange),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

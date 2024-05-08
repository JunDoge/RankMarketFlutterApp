import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/user/RptHistorys.dart';
import 'package:shop_app/screens/report/report.dart';
import '../../repository/user/UserRepository.dart';
import '../no_product_page.dart';
import '../sign_in/sign_in_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  static String routeName = "/reportHistorys";
  final storage = const FlutterSecureStorage();
  late Future<RptHistorys?> _rptHistorysFuture;
  String? token;
  UserRepository userRepository = UserRepository(Dio());

  @override
  void initState() {
    super.initState();
    _rptHistorysFuture = _fetchRptHistorys();
  }

  void rptDelete(int index) {
    setState(() {
      _rptHistorysFuture.then((bidHistorys) {
        if (bidHistorys != null) {
          bidHistorys.response.removeAt(index);
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('신고가 취소 되었습니다.'),
        duration: Duration(milliseconds: 1000), // 스낵바가 화면에 표시되는 시간 (1초)
      ),
    );
  }

  Future<RptHistorys?> _fetchRptHistorys() async {
    token = await storage.read(key: 'token');
    if (token != null) {
      return userRepository.getRptHistorys(token!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RptHistorys?>(
        future: _rptHistorysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.response.isEmpty) {
            return const NoProductPage(msg: "신고내역이 없습니다.");
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  '신고',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.response.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ReportHistory(
                    rptHistory: snapshot.data!.response[index],
                    onDelete: () => rptDelete(index),
                  ),
                ),
              ),
            );
          }
        });
  }
}

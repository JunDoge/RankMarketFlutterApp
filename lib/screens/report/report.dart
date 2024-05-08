import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/user/RptHistorys.dart';
import 'package:shop_app/repository/user/UserRepository.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory(
      {Key? key, required this.rptHistory, required this.onDelete})
      : super(key: key);
  final RptHistory rptHistory;
  final void Function() onDelete;

  @override
  _ReportHistoryState createState() => _ReportHistoryState();

}


class _ReportHistoryState extends State<ReportHistory>{
  static const reportType = {
    1: '사전고지한 상품정보와 상이',
    2: '주문취소 시 환불 거부',
    3: '가품의심',
    4: '안전거래 사칭 등 결제 관련 사기',
    5: '개인정보 관련 피해',
    6: '거래 당사자 간 연락 지연',
    7: '사용불가 제품',
    8: '무단 이미지 도용',
    9: '기타의견'
  };

  UserRepository userRepository = UserRepository(Dio());
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:Column(
        children: [
          SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/${widget.rptHistory.img}'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reportType.containsKey(int.parse(widget.rptHistory.rpt_type)) ? reportType[int.parse(widget.rptHistory.rpt_type)]! : 'Unknown',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.rptHistory.rpt_des,
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Spacer(),
                    PopupMenuButton<int>(
                      color: Colors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              String? token = await storage.read(key: "token");
                              List<int> rpt_ids = [int.parse(widget.rptHistory.rpt_id)];
                              await userRepository.rptCancle(token!, rpt_ids);
                              setState(() {
                                widget.onDelete();
                              });
                            },
                            title: Text('취소'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
          SizedBox(height: 5),
          Divider(color: Colors.grey[200]),
        ],
      ),
    );
  }
}

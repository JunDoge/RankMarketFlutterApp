import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = const AndroidInitializationSettings('app_icon');



  var initializationSettings = InitializationSettings(
      android: androidSetting,
  );
  await notifications.initialize(
    initializationSettings,

  );
}


showNotification(String? title, String? content) async {

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );


  notifications.show(
      1,
      title,
      content,
      NotificationDetails(android: androidDetails)
  );
}
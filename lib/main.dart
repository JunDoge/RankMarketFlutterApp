import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart/components/cart_model.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/wish/components/wish_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'notification.dart';
import 'routes.dart';
import 'theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(nativeAppKey: 'e0c555f3688f9f7744a0f4dfdffcdf5a');
  HttpOverrides.global = MyHttpOverrides();
  AuthRepository.initialize(appKey: '7d9c214980c8735a695834e3e4821a88');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => WishModel()),
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initNotification();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title;
      String? content = message.notification?.body;
      print("Received notification: $title, $content");
      showNotification(title, content);
    });
    // removeTokenOnStart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

/*
  void removeTokenOnStart() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await storage.delete(key: 'usrNm');
  }
*/




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      initialRoute: InitScreen.routeName,
      routes: routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.maxConnectionsPerHost = 10000000000; // 이 값을 원하는 숫자로 변경해주세요.
    return client;
  }
}

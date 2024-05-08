import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String?> getFirebaseToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
  }
}
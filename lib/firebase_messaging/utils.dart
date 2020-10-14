import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart'; // ライブラリのインポート
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';

void setUpFCM() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isFcmSetupDone = prefs.getBool('isFcmSetupDone');
  if (isFcmSetupDone != null) {
    return;
  }
  prefs.setBool('isFcmSetupDone', true);
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print("Push Messaging token: $token");
    registerDeviseToken(token);
  });
}

void registerDeviseToken(fcmToken) async {
  final String jwt = await AuthenticationUtility.getMyJwt();
  // const baseUrl = 'http://localhost:8000';
  const url = BASE_URL + '/api/firebase_messaging/register/';
  print(jwt);
  print(fcmToken);
  final response = await http
      .post(url, body: jsonEncode({'device_token': fcmToken}), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'JWT ' + jwt,
  });
  print('fcm register');
  print(response.statusCode);
  print(jsonDecode(utf8.decode(response.bodyBytes)));
}

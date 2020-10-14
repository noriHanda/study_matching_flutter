import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.dark,
            title: Text(
              'プライバシーポリシー',
              style: TextStyle(color: Colors.white),
            )),
        body: SafeArea(
            top: false,
            child: WebView(
                initialUrl:
                    'https://studymatching.net/privacy_policy/privacypolicy.html'))); // httpsでないと表示できないらしいので、ここの指定は必ずhttps
  }
}

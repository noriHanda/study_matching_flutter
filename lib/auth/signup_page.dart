import 'package:flutter/material.dart';
import 'package:study_matching/auth/signup_form.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text('新規アカウント作成')),
        body: SafeArea(
            top: false, child: SingleChildScrollView(child: SignupForm())));
  }
}

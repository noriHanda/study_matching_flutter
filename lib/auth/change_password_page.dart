import 'package:flutter/material.dart';
import 'package:study_matching/auth/change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(appBar: AppBar(brightness: Brightness.dark,title: Text('ログイン')), body: LoginForm());
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text('パスワード変更')),
        body: SafeArea(top: false, child: ChangePasswordForm()));
  }
}

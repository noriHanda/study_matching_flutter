import 'package:flutter/material.dart';
import 'package:study_matching/auth/login_form.dart';
import 'package:study_matching/auth/password_reset_page.dart';
import 'package:study_matching/auth/signup_page.dart';
import 'package:study_matching/kiyaku_page.dart';
import 'package:study_matching/privacy_policy_page.dart';
import 'package:study_matching/login_help_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text('ログイン')),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                LoginForm(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        child: Text(
                          'ログインできない場合',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginHelpPage(),
                              settings: RouteSettings(name: 'LoginHelpPage'),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                        'ログインと同時に以下の「利用規約」と「プライバシーポリシー」に同意した扱いとなりますのでご注意ください。')),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('利用規約'),
                          color: Colors.white,
                          shape: Border(
                            top: BorderSide(color: Colors.lightBlue),
                            left: BorderSide(color: Colors.lightBlue),
                            right: BorderSide(color: Colors.lightBlue),
                            bottom: BorderSide(color: Colors.lightBlue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KiyakuPage(),
                                settings: RouteSettings(name: 'KiyakuPage'),
                              ),
                            );
                          }),
                      RaisedButton(
                          child: Text('プライバシーポリシー'),
                          color: Colors.white,
                          shape: Border(
                            top: BorderSide(color: Colors.lightBlue),
                            left: BorderSide(color: Colors.lightBlue),
                            right: BorderSide(color: Colors.lightBlue),
                            bottom: BorderSide(color: Colors.lightBlue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage()));
                          })
                    ]),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: RaisedButton(
                        child: Text('パスワードをお忘れの場合'),
                        color: Colors.white,
                        shape: Border(
                          top: BorderSide(color: Colors.lightBlue),
                          left: BorderSide(color: Colors.lightBlue),
                          right: BorderSide(color: Colors.lightBlue),
                          bottom: BorderSide(color: Colors.lightBlue),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PasswordResetPage(),
                              settings:
                                  RouteSettings(name: 'PasswordResetPage'),
                            ),
                          );
                        })),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: RaisedButton(
                    child: Text('新規アカウント作成'),
                    color: Colors.white,
                    shape: Border(
                      top: BorderSide(color: Colors.lightBlue),
                      left: BorderSide(color: Colors.lightBlue),
                      right: BorderSide(color: Colors.lightBlue),
                      bottom: BorderSide(color: Colors.lightBlue),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                          settings: RouteSettings(name: 'SingupPage'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ))));
  }
}

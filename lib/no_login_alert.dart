import 'package:flutter/material.dart';
import 'package:study_matching/auth/login_page.dart';

noLoginAlert(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text("閉じる"),
    onPressed: () => Navigator.pop(context),
  );
  Widget continueButton = FlatButton(
      child: Text("ログイン・サインアップ"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(),
              settings: RouteSettings(name: 'LoginPage')),
        );
      });

  AlertDialog alert = AlertDialog(
    title: Text("この操作を行うにはログインを完了させてください"),
    content:
        Text("北大支給のメールアドレスを使ってサインアップ・ログインすることで他のユーザーとチャットしたり、募集を出したりできます！"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => alert,
  );
}

import 'package:flutter/material.dart';

class PasswordResetEmailHelpPage extends StatelessWidget {
  PasswordResetEmailHelpPage({this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('確認'),
          brightness: Brightness.dark,
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(16),
                child: Text('$email 宛にパスワード再設定用メールを送信しました。'
                    /*'\nメールに含まれる再設定用リンクを開き、パスワードリセットWebページに進んでください。'*/)),
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 0.0, right: 16.0),
              child: Text('どうしてもログインできない場合は、スタマチ運営まで。\n\n'
                  'メール: cs.studymatching@gmail.com\n'
                  '公式Twitter: @MatchingStudy\n\n\n'),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RaisedButton(
                  child: Text('ログイン（メール確認後）'),
                  onPressed: () {
                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                '迷惑メールボックスも\n' 'チェック！',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationThickness: 0.3,
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class ConfirmationEmailHelpPage extends StatelessWidget {
  ConfirmationEmailHelpPage({this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('本登録メールの確認'),
          brightness: Brightness.dark,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(1),
              child: Image.asset(
                'assets/icon/icon_android.png',
                width: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  'ユーザー登録ありがとうございます。 $email 宛に本登録用メールを送信しました。メールに含まれる本登録用リンクを開き、登録を完了させてください。'),
            ),
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
                  color: Colors.white,
                  shape: Border(
                    top: BorderSide(color: Colors.blue),
                    left: BorderSide(color: Colors.blue),
                    right: BorderSide(color: Colors.blue),
                    bottom: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80),
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

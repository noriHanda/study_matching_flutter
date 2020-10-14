import 'package:flutter/material.dart';

class LoginHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          'ログインできない場合',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('メールからの本登録処理は完了していますか？\n\n'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
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
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: Text('メールアドレスをもう一度入力してみて、\n'
                '問題が解決しない場合、運営へお問い合わせください。\n\n'
                'メール: cs.studymatching@gmail.com\n'
                '公式Twitter: @MatchingStudy'),
          ),
        ],
      ),
    );
  }
}

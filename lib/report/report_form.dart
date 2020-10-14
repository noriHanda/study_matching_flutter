import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/report/report_api.dart';
import 'package:study_matching/tag/my_tag_bloc.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';

class ReportForm extends StatefulWidget {
  ReportForm({@required this.offererId});
  final int offererId;

  @override
  _ReportFormState createState() => _ReportFormState(reportedUserId: offererId);
}

class _ReportFormState extends State<ReportForm> {
  _ReportFormState({@required this.reportedUserId});
  final _userApi = UserApi();
  final reportedUserId;
  bool isSubmitting = false;
  bool isSuccess;

  MyTagBloc myTagBloc;
  TextEditingController contentInputController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    contentInputController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context);

    bloc.fetchAndSetUser();

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('不適切なユーザーの報告'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: bloc.user,
                      initialData: bloc.user.value,
                      builder: (context, userSnapshot) {
                        final User user = userSnapshot.data;
                        if (user != null && user.username != null) {
                          return Container(
                              child: Text(
                            "報告者様のユーザーネーム：" + user.username + " 様",
                            style: TextStyle(fontSize: 18),
                          ));
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                      future: _userApi.fetchUser(reportedUserId),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          final UserResult reportedUserResult =
                              userSnapshot.data;
                          if (reportedUserResult.statusCode != 200) {
                            return CircularProgressIndicator();
                          } else {
                            final reportedUser = reportedUserResult.user;
                            return Container(
                              child: Text(
                                '報告するユーザー：' + reportedUser.username,
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }
                        }
                      }),
                ),
                Container(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Text(
                      '具体的な内容：',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 0, 0, 60)),
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    maxLines: 10,
                    controller: contentInputController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '内容を入力してください';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  child: Text(
                      '※ お急ぎのご用件はスタマチ公式Twitter(@MatchingStudy)にダイレクトメッセージをご送信ください。\n'),
                ),
                RaisedButton(
                    child: Text('送信'),
                    color: Colors.white,
                    shape: Border(
                      top: BorderSide(color: Colors.lightBlue),
                      left: BorderSide(color: Colors.lightBlue),
                      right: BorderSide(color: Colors.lightBlue),
                      bottom: BorderSide(color: Colors.lightBlue),
                    ),
                    splashColor: Colors.lightBlue,
                    onPressed: () async {
                      isSuccess = await sendReport(
                          contentInputController.toString(), reportedUserId);
                      showReportResultDialog();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showReportResultDialog() {
    if (isSuccess) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("確認"),
                content: Text("報告しました。"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("確認"),
                content: Text("報告内容の送信に失敗しました。通信環境の良い場所でもう一度送信ボタンを押して下さい。"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
  }
}

Future<bool> sendReport(String reportContent, int reportedUserId) async {
  final reportApi = ReportApi();
  final result = await reportApi.create(
      reportedUserId: reportedUserId.toString(), reportContent: reportContent);
  return result;
}

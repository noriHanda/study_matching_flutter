import 'package:flutter/material.dart';
import 'package:study_matching/auth/authentication_api.dart';
import 'package:study_matching/auth/password_reset_email_help_page.dart';
import 'package:study_matching/common/form_validators.dart';
import 'package:study_matching/common/ui/load_indicator.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController(text: "");

  String errorMessage = '';
  bool isLoadIndicatorVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(brightness: Brightness.dark, title: Text('パスワードリセット')),
        body: SafeArea(
            top: false,
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            errorMessage != ''
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red),
                                    )))
                                : Container(),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                    'パスワードリセットしたいアカウントのメールアドレスを入力してください。')),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'email',
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailInputController,
                                        validator: validateEmail))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                  child: RaisedButton(
                                onPressed: () async {
                                  // Validate will return true if the form is valid, or false if
                                  // the form is invalid.
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoadIndicatorVisible = true;
                                    });
                                    final SendingPasswordResetEmailResult
                                        result = await this.submit();
                                    setState(() {
                                      isLoadIndicatorVisible = false;
                                    });
                                    if (result.isSuccess) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordResetEmailHelpPage(
                                                  email: emailInputController
                                                      .text),
                                          settings: RouteSettings(
                                              name:
                                                  'PasswordResetEmailHelpPage'),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        errorMessage = result.errorMessage;
                                      });
                                    }
                                  }
                                },
                                child: Text('送信'),
                                color: Colors.white,
                                shape: Border(
                                  top: BorderSide(color: Colors.lightBlue),
                                  left: BorderSide(color: Colors.lightBlue),
                                  right: BorderSide(color: Colors.lightBlue),
                                  bottom: BorderSide(color: Colors.lightBlue),
                                ),
                                splashColor: Colors.lightBlue,
                              )),
                            ),
                          ]))),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadIndicator(
                        visible: isLoadIndicatorVisible,
                      )))
            ])));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailInputController.dispose();
    super.dispose();
  }

  Future<SendingPasswordResetEmailResult> submit() async {
    return AuthenticationApi.sendPasswordResetEmail(emailInputController.text);
  }
}

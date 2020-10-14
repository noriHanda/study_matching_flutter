import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:study_matching/auth/authentication_api.dart';
import 'package:study_matching/auth/confirmation_email_help_page.dart';
import 'package:study_matching/common/form_validators.dart';
import 'package:study_matching/common/ui/load_indicator.dart';

class SignupForm extends StatefulWidget {
  @override
  SignupFormState createState() {
    // TODO: implement createState
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  // This widget is the root of your application.
  final _formKey = GlobalKey<FormState>();
  FocusNode _idFocus;
  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  FocusNode _passwordConfFocus;

  bool isLoadIndicatorVisible = false;
  String errorMessage = '';

  TextEditingController userIdInputController = TextEditingController(text: "");
  TextEditingController passwordInputController =
      TextEditingController(text: "");
  TextEditingController rePasswordInputController =
      TextEditingController(text: "");
  TextEditingController emailInputController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _idFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _passwordConfFocus = FocusNode();
  }

  String validateUsername(String value) {
    final result = validateEmpty(value);
    if (result != null) {
      return result;
    }
    if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return null;
    } else {
      return 'ユーザIDには英数字のみ利用できます。';
    }
  }

  String validateConfirmPassword(String value) {
    final result = validateEmpty(value);
    if (result != null) {
      return result;
    }
    if (value == passwordInputController.text) {
      return null;
    } else {
      return '確認用パスワードが一致していません。';
    }
  }

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(focusNode: _idFocus),
          KeyboardAction(focusNode: _emailFocus),
          KeyboardAction(focusNode: _passwordFocus),
          KeyboardAction(focusNode: _passwordConfFocus),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
      height: 600,
      child: KeyboardActions(
        config: _keyboardActionsConfig(context),
        child: Stack(children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ユーザID（英数字）',
                            ),
                            focusNode: _idFocus,
                            controller: userIdInputController,
                            validator: validateUsername))),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'メールアドレス(hokudai.ac.jp で終わるアドレスのみ使用できます)',
                            ),
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailInputController,
                            validator: validateEmail))),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'パスワード',
                            ),
                            obscureText: true,
                            focusNode: _passwordFocus,
                            controller: passwordInputController,
                            validator: validateEmpty))),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'パスワード（確認）',
                            ),
                            obscureText: true,
                            focusNode: _passwordConfFocus,
                            controller: rePasswordInputController,
                            validator: validateConfirmPassword))),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('パスワードは以下の条件を満たすようご設定ください。\n'
                        '・半角で英数字の両方を含めた８文字以上\n')),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: RaisedButton(
                    onPressed: () async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, we want to show a Snackbar
                        //Scaffold.of(context)
                        //    .showSnackBar(SnackBar(content: Text('Processing Data')));
                        setState(() {
                          isLoadIndicatorVisible = true;
                        });
                        final result = await this.submit();
                        setState(() {
                          isLoadIndicatorVisible = false;
                        });
                        if (result.isSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmationEmailHelpPage(
                                  email: emailInputController.text),
                              settings: RouteSettings(
                                  name: 'ConfirmationEmailHelpPage'),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage = result.errorMessage;
                          });
                        }
                      }
                    },
                    child: Text('新規作成'),
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
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('')),
              ],
            ),
          ),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: LoadIndicator(
                    visible: isLoadIndicatorVisible,
                  )))
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    userIdInputController.dispose();
    _idFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfFocus.dispose();

    super.dispose();
  }

  Future<SignupResult> submit() async {
    final result = await AuthenticationApi.signup(
        username: userIdInputController.text,
        email: emailInputController.text,
        password: passwordInputController.text,
        rePassword: rePasswordInputController.text);
    return result;
  }
}

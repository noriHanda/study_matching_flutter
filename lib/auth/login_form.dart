import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/auth/authentication_api.dart';
import 'package:study_matching/common/ui/load_indicator.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  // This widget is the root of your application.
  final _formKey = GlobalKey<FormState>();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  String errorMessage = '';
  bool isLoadIndicatorVisible = false;

  TextEditingController emailOrUsernameInputController =
      TextEditingController(text: "");
  TextEditingController detailsInputController =
      TextEditingController(text: "");

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(
            focusNode: _usernameFocus,
          ),
          KeyboardAction(focusNode: _passwordFocus),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
      height: 300,
      child: KeyboardActions(
        config: _keyboardActionsConfig(context),
        child: Stack(children: <Widget>[
          Form(
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
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Center(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ユーザ名またはメールアドレス',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _usernameFocus,
                      controller: emailOrUsernameInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                    ))),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'メールアドレスはhokudai.ac.jpで終わるものをご入力ください',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                      ),
                      focusNode: _passwordFocus,
                      controller: detailsInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                    ))),
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
                        final loginResult = await this.submit();
                        setState(() {
                          isLoadIndicatorVisible = false;
                        });
                        if (loginResult.isFailure) {
                          setState(() {
                            errorMessage = loginResult.errorMessage;
                          });
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text('ログイン'),
                    color: Colors.white,
                    shape: Border(
                      top: BorderSide(color: Colors.lightBlue),
                      left: BorderSide(color: Colors.lightBlue),
                      right: BorderSide(color: Colors.lightBlue),
                      bottom: BorderSide(color: Colors.lightBlue),
                    ),
                  )),
                ),
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
    emailOrUsernameInputController.dispose();
    detailsInputController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  Future<LoginResult> submit() async {
    return AuthenticationApi.login(
        emailOrUsernameInputController.text, detailsInputController.text,
        (JwtTokenMap tokenMap) {
      final AuthBloc bloc = Provider.of(context);
      bloc.setUserJwt.add(tokenMap.access);
    });
  }
}

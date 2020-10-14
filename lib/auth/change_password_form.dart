import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/base_url.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  ChangePasswordFormState createState() => ChangePasswordFormState();
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  // This widget is the root of your application.
  final _formKey = GlobalKey<FormState>();
  final _currentPWFocus = FocusNode();
  final _newPWFocus = FocusNode();
  final _newPWConfFocus = FocusNode();

  TextEditingController currentPasswordInputController =
      TextEditingController(text: "");
  TextEditingController newPasswordInputController =
      TextEditingController(text: "");
  TextEditingController newPasswordConfirmInputController =
      TextEditingController(text: "");

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(focusNode: _currentPWFocus),
          KeyboardAction(focusNode: _newPWFocus),
          KeyboardAction(focusNode: _newPWConfFocus),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
      height: 500,
      child: KeyboardActions(
        config: _keyboardActionsConfig(context),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 3, // space between underline and text
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.lightBlue, // Line colour here
                          width: 1.0, // Underline width
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Text(
                      "パスワード変更",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black, // Text colour here
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '現在のパスワード',
                    ),
                    focusNode: _currentPWFocus,
                    controller: currentPasswordInputController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                  ))),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '新しいパスワード',
                    ),
                    focusNode: _newPWFocus,
                    controller: newPasswordInputController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                  ))),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '新しいパスワード（確認用）',
                    ),
                    focusNode: _newPWConfFocus,
                    controller: newPasswordConfirmInputController,
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
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      final bloc = Provider.of<AuthBloc>(context);
                      this.submit(bloc);
                    }
                  },
                  child: Text('Submit'),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    currentPasswordInputController.dispose();
    newPasswordInputController.dispose();
    newPasswordConfirmInputController.dispose();
    super.dispose();
  }

  void submit(AuthBloc bloc) async {
    if (bloc.userJwt.value != null) {
      final url = BASE_URL + '/api/auth/users/set_password/';
      var response = await http.post(
        url,
        body: {
          'new_password': newPasswordInputController.text,
          're_new_password': newPasswordConfirmInputController.text,
          'current_password': currentPasswordInputController.text
        },
        headers: {HttpHeaders.authorizationHeader: 'JWT ' + bloc.userJwt.value},
      );
      if (response.statusCode == 204) {
        Navigator.of(context).pop();
      } else {
        final snackBar =
            SnackBar(content: Text('パスワードの変更に失敗しました。${response.body}'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
      print(response.statusCode);
    }
    return null;
  }
}

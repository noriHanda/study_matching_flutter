import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/user/user_api.dart';

class ProfileDescriptionEditPage extends StatefulWidget {
  @override
  _ProfileDescriptionEditPage createState() => _ProfileDescriptionEditPage();
}

class _ProfileDescriptionEditPage extends State<ProfileDescriptionEditPage> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionInputController = TextEditingController();
  final userApi = UserApi();

  // ProfileBloc bloc;
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authBloc = Provider.of<AuthBloc>(context);
    _descriptionInputController.text = authBloc.user.value.description;
    return Scaffold(
      appBar: AppBar(title: Text('プロフィール編集'), brightness: Brightness.dark),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'プロフィール',
                      ),
                      controller: _descriptionInputController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 10,
                    ))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: RaisedButton(
                    onPressed: () async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        final isSuccess = await submit();
                        if (isSuccess) {
                          await authBloc.fetchAndSetUser();
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text('更新'),
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
      ),
    );
  }

  @override
  void dispose() {
    _descriptionInputController.dispose();
    super.dispose();
  }

  Future<bool> submit() async {
    final userResult = await userApi.updateUser(
        authBloc.user.value.id, {'intro': _descriptionInputController.text});
    if (userResult.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

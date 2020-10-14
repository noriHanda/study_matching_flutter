import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/user_review/user_review_api.dart';
import 'package:study_matching/user_review/user_review_page_arguments.dart';

class UserReviewPage extends StatefulWidget {
  @override
  _UserReviewPageState createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  final _formKey = GlobalKey<FormState>();

  final _reviewTextInputController = TextEditingController();
  final userReviewApi = UserReviewApi();

  AuthBloc authBloc;

  String rating = '5';
  List<String> dropdownValueList = ['1', '2', '3', '4', '5'];

  String revieweeId;
  String revieweeUserName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as UserReviewPageArguments;
    revieweeUserName = arguments.revieweeUserName;
    revieweeId = arguments.reviewee;
    authBloc = Provider.of<AuthBloc>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('レビュー投稿'), brightness: Brightness.dark),
        body: SafeArea(
            top: false,
            child: Column(children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '$revieweeUserName へのレビュー投稿',
                          style: Theme.of(context).textTheme.subtitle2,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                            child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'レビュー文',
                          ),
                          controller: _reviewTextInputController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 5,
                        ))),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          'レーティング',
                          style: Theme.of(context).textTheme.subtitle2,
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                        child: DropdownButton<String>(
                          value: rating,
                          onChanged: (String newValue) {
                            setState(() {
                              rating = newValue;
                            });
                          },
                          items: dropdownValueList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                          child: RaisedButton(
                        onPressed: () async {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            final userReviewResult = await submit();

                            if (userReviewResult.statusCode == 201) {
                              final snackBar =
                                  SnackBar(content: Text('レビューを投稿しました！'));
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            } else {
                              if (userReviewResult.errorCode ==
                                  'A_USER_CANNOT_CREATE_MULTIPLE_REVIEWS_FOR_ONE_USER') {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'レビューの投稿に失敗しました。同じユーザに複数回レビューはできません。'));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'レビューの投稿に失敗しました。入力内容をご確認の上、再度投稿してください。'));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            }
                          }
                        },
                        child: Text('投稿'),
                      )),
                    ),
                  ],
                ),
              )
            ])));
  }

  @override
  void dispose() {
    _reviewTextInputController.dispose();
    super.dispose();
  }

  Future<UserReviewResult> submit() async {
    if (revieweeId != null) {
      final userReviewResult = await userReviewApi.create(
          reviewee: revieweeId,
          text: _reviewTextInputController.text,
          rating: rating);
      return userReviewResult;
    } else {
      return UserReviewResult(
          statusCode: null, errorCode: null, userReview: null);
    }
  }
}

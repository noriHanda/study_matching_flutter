import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/chat_post_bloc.dart';
import 'package:study_matching/chat/talk_list_bloc.dart';
import 'package:study_matching/common/ui/load_indicator.dart';

class ChatForm extends StatefulWidget {
  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  final _formKey = GlobalKey<FormState>();

  final _chatFocus = FocusNode();

  final _sentenceInputController = TextEditingController();

  ChatPostBloc bloc;
  AuthBloc authBloc;
  bool isLoadIndicatorVisible = false;

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(focusNode: _chatFocus),
        ],
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ChatPostBloc>(context);
    authBloc = Provider.of<AuthBloc>(context);
    // Build a Form widget using the _formKey we created above
    return StreamBuilder(
        stream: authBloc.user,
        builder: (context, authUserSnapshot) {
          if (!authUserSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final authUserId = authUserSnapshot.data.id;
          return Column(
            children: <Widget>[
              _textForm(authUserId),
              _autoInputButtons(),
              LoadIndicator(
                visible: isLoadIndicatorVisible,
              ),
            ],
          );
        });
  }

  Widget _autoInputButtons() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: RaisedButton(
                child: Text("最初の挨拶"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  _sentenceInputController.text =
                      "こんにちは。始めまして。\n〇〇という募集が気になったのでチャットしました！";
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: RaisedButton(
                child: Text("日程・場所調整"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  _sentenceInputController.text = "〇日△時にXXで会ってみませんか？";
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textForm(int authUserId) {
    return Container(
      height: 330,
      child: KeyboardActions(
        config: _keyboardActionsConfig(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '詳細',
                  ),
                  controller: _sentenceInputController,
                  focusNode: _chatFocus,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      return null;
                    }
                  },
                  maxLines: 6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoadIndicatorVisible = true;
                      });
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final isSuccess = await this.submit(authUserId);
                      if (isSuccess) {
                        final talkListBloc = Provider.of<TalkListBloc>(context);
                        talkListBloc.fetchAllTalks(bloc.chat.value.id);
                      } else {
                        final snackBar = SnackBar(
                          content: Text(
                            '送信に失敗しました。もう一度送信してください。',
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      setState(() {
                        isLoadIndicatorVisible = false;
                      });
                    }
                  },
                  child: Text('送信'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sentenceInputController.dispose();
    super.dispose();
  }

  Future<bool> submit(int userId) async {
    if (bloc.chat.value != null) {
      final chatApi = ChatApi();
      final sentence = _sentenceInputController.text;
      final talkResult = await chatApi.postTalk(
          bloc.chat.value.id, userId, sentence, authBloc.userJwt.value);
      print(talkResult.statusCode);
      if (talkResult.statusCode == 200) {
        _sentenceInputController.text = '';
        return true;
      }
    }
    return false;
  }
}

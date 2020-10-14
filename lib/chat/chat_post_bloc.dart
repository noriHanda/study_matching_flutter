import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/chat/chat.dart';
import 'package:study_matching/chat/chat_api.dart';

class ChatPostBloc {
  BehaviorSubject<Chat> _chatController = BehaviorSubject<Chat>.seeded(null);
  StreamSink<Chat> get setChatData => _chatController.sink;
  ValueObservable<Chat> get chat => _chatController.stream;

  // PublishSubject<Chat> _chatPostController = BehaviorSubject<Chat>();
  // StreamSink<Chat> get postTalk => _chatPostController.sink;

  final chatApi = ChatApi();

  dispose() {
    _chatController.close();
    // _chatPostController.close();
  }
}

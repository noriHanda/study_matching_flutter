import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/talk.dart';

class TalkListBloc {
  BehaviorSubject<List<Talk>> _talkListController =
      BehaviorSubject<List<Talk>>.seeded([]);
  StreamSink<List<Talk>> get setTalkListData => _talkListController.sink;
  ValueObservable<List<Talk>> get talks => _talkListController.stream;

  final chatApi = ChatApi();

  void fetchAllTalks(int chatId) async {
    final jwt = await AuthenticationUtility.getMyJwt();
    final result = await chatApi.fetchAllTalk(chatId, jwt);
    if (result.statusCode == 200) {
      setTalkListData.add(result.talks);
    } else if (result.statusCode == 401) {
      setTalkListData.addError(401);
    } else {
      setTalkListData.add(null);
    }
  }

  dispose() {
    _talkListController.close();
  }
}

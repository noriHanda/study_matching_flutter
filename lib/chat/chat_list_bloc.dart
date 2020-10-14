import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/chat/chat_api.dart';
import 'package:study_matching/chat/chat_list_tile_data.dart';

class ChatListBloc {
  BehaviorSubject<List<ChatListTileData>> _chatListTileDataListController =
      BehaviorSubject<List<ChatListTileData>>.seeded(null);
  StreamSink<List<ChatListTileData>> get setCustomChatList =>
      _chatListTileDataListController.sink;
  ValueObservable<List<ChatListTileData>> get chatListTileDataList =>
      _chatListTileDataListController.stream;

  final chatApi = ChatApi();

  Future<void> fetchCustomChatList() async {
    try {
      final chatListTileDataList = await chatApi.fetchAllForChatListPage();
      setCustomChatList.add(chatListTileDataList);
    } catch (e) {
      setCustomChatList.addError(e.message);
    }
  }

  dispose() {
    _chatListTileDataListController.close();
  }
}

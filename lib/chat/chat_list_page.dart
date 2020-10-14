import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:study_matching/auth/auth_bloc.dart';
import 'package:study_matching/chat/chat_list_bloc.dart';
import 'package:study_matching/chat/chat_list_tile.dart';

class ChatListPage extends StatefulWidget {
  static const String name = 'トーク';
  static const Icon icon = Icon(Icons.chat);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  ChatListBloc chatListBloc;
  AuthBloc authBloc;
  bool _isChatDataLoading = false;

  Future<void> _onRefreshChatList() async {
    setState(() {
      _isChatDataLoading = true;
    });
    await chatListBloc.fetchCustomChatList();
    setState(() {
      _isChatDataLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = Provider.of<AuthBloc>(context);
    chatListBloc = Provider.of<ChatListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return buildChatList(context);
  }

  Widget buildChatList(BuildContext context) {
    initializeDateFormatting("ja_JP");
    if (authBloc.userJwt != null) {
      chatListBloc.fetchCustomChatList();
    }

    return StreamBuilder(
      initialData: chatListBloc.chatListTileDataList.value,
      stream: chatListBloc.chatListTileDataList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (_isChatDataLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return GestureDetector(
              onTap: _onRefreshChatList,
              child: Text(
                'なんらかのエラーにより、読み込みに失敗しました。画面をタップして、再度読み込みを行ってください。',
              ),
            );
          }
        }
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          final chatListTileDataList = snapshot.data;
          return RefreshIndicator(
            onRefresh: _onRefreshChatList,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: chatListTileDataList.length,
              itemBuilder: (context, index) =>
                  ChatListTile(chatListTileData: chatListTileDataList[index]),
            ),
          );
        }
      },
    );
  }
}

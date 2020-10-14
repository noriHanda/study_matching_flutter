import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_matching/chat/chat_list_tile_data.dart';
import 'package:study_matching/chat/chat_page.dart';

class ChatListTile extends StatelessWidget {
  final ChatListTileData chatListTileData;

  ChatListTile({@required this.chatListTileData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chat: chatListTileData.chat,
                chatPartner: chatListTileData.partner,
              ),
              settings: RouteSettings(name: 'ChatPage'),
            ),
          );
        },
        child: ListTile(
          leading: Column(children: <Widget>[
            Text(chatListTileData.partner.username),
            Expanded(
                child: CachedNetworkImage(
                    imageUrl: chatListTileData.partner.iconUrl ??
                        'http://design-ec.com/d/e_others_50/m_e_others_501.jpg')),
          ]),
          trailing: chatListTileData.unreadTalkCount > 0
              ? Container(
                  width: 24,
                  height: 24,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${chatListTileData.unreadTalkCount}',
                        style: TextStyle(color: Colors.white)),
                  ))
              : null,
          title: Text(
            chatListTileData.latestTalk.sentence,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          subtitle: Text(
              '${DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(chatListTileData.latestTalk.createdDate)}'),
        ));
  }
}

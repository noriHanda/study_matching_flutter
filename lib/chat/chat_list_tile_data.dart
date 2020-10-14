import 'package:study_matching/chat/chat.dart';
import 'package:study_matching/chat/talk.dart';
import 'package:study_matching/user/user.dart';

class ChatListTileData {
  ChatListTileData(
      {this.chat,
      this.partner,
      this.latestTalk,
      this.unreadTalkCount,
      this.createdDate});

  ChatListTileData.fromJson(Map<String, dynamic> json)
      : this.chat = Chat.fromJson(json['chat']),
        this.partner = User.fromJson(json['partner']),
        this.latestTalk = Talk.fromJson(json['latest_talk']),
        this.unreadTalkCount = json['chat_unread_talk_count'],
        this.createdDate = DateTime.parse(json['created_at']).toLocal();

  Chat chat;
  User partner;
  Talk latestTalk;
  int unreadTalkCount;
  DateTime createdDate;
}

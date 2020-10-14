import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/chat/chat.dart';
import 'package:study_matching/chat/chat_list_tile_data.dart';
import 'package:study_matching/chat/chat_unread_count.dart';
import 'package:study_matching/chat/talk.dart';

class ChatApi {
  Future<ChatResult> create(
      loginUserId, partnerUserId, String accessToken) async {
    print(loginUserId);
    print(partnerUserId);
    const url = BASE_URL + '/api/chats/';
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ' + accessToken,
      },
      body: jsonEncode({'user1': loginUserId, 'user2': partnerUserId}),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      final chat = Chat(
          id: body['id'],
          user1: body['user1'],
          user2: body['user2'],
          createdDate: DateTime.parse(body['created_at']).toLocal());
      print(chat);
      return ChatResult(statusCode: response.statusCode, chat: chat);
    } else {
      return ChatResult(statusCode: response.statusCode, chat: null);
    }
  }

  Future<TalkResult> postTalk(
      int chatId, int talkerId, String sentence, String accessToken) async {
    const url = BASE_URL + '/api/chat_utils/post_talk';
    var response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'JWT ' + accessToken,
        },
        body: jsonEncode(
            {'chat': chatId, 'talker': talkerId, 'sentence': sentence}));

    if (response.statusCode == 201) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      final talk = Talk.fromJson(body);
      print(talk);
      return TalkResult(statusCode: response.statusCode, talk: talk);
    } else {
      return TalkResult(statusCode: response.statusCode, talk: null);
    }
  }

  Future<TalkResult> fetchLatestTalk(int chatId, String accessToken) async {
    final url = BASE_URL + '/api/chat_utils/fetch_latest_talk?chat_id=$chatId';
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + accessToken},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      final talk = Talk.fromJson(body);
      print(talk);
      return TalkResult(statusCode: response.statusCode, talk: talk);
    } else {
      return TalkResult(statusCode: response.statusCode, talk: null);
    }
  }

  Future<TalkListResult> fetchAllTalk(int chatId, String accessToken) async {
    final url = BASE_URL + '/api/chat_utils/fetch_all_talk?chat_id=$chatId';
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + accessToken},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final talks = body.map((v) => Talk.fromJson(v)).toList();
      return TalkListResult(statusCode: response.statusCode, talks: talks);
    } else {
      return TalkListResult(statusCode: response.statusCode, talks: []);
    }
  }

  Future<ChatResult> fetchChatWithUserId(
      int partnerId, String accessToken) async {
    final url = BASE_URL +
        '/api/chat_utils/fetch_chat_with_user_id?partnerId=$partnerId';
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + accessToken},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      final chat = Chat(
          id: body['id'],
          user1: body['user1'],
          user2: body['user2'],
          createdDate: DateTime.parse(body['created_at']).toLocal());
      print(chat);
      return ChatResult(statusCode: response.statusCode, chat: chat);
    } else {
      return ChatResult(statusCode: response.statusCode, chat: null);
    }
  }

  Future<Chat> fetchOrCreateChatRoom(
      loginUserId, partnerUserId, String accessToken) async {
    Chat chat;
    final chatResult = await fetchChatWithUserId(partnerUserId, accessToken);
    chat = chatResult.chat;
    if (chat == null) {
      final chatResult = await create(loginUserId, partnerUserId, accessToken);
      chat = chatResult.chat;
    }
    return chat;
  }

  Future<int> fetchChatUnreadTotalCount() async {
    final url = BASE_URL + '/api/chat_utils/fetch_chat_unread_total_count/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return body['chat_unread_total_count'];
    } else {
      throw Exception('${response.statusCode}: すみません、エラーにより読み込めませんでした。');
    }
  }

  Future<bool> resetChatUnreadCount(int chatId) async {
    const url = BASE_URL + '/api/chat_utils/reset_chat_unread_count';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ' + jwt,
      },
      body: jsonEncode({
        'chatId': chatId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ChatListTileData>> fetchAllForChatListPage() async {
    final accessToken = await AuthenticationUtility.getMyJwt();
    final url = BASE_URL + '/api/chat_utils/fetch_chat_list_for_chat_list_page';
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + accessToken},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final chatListTileDataList =
          body.map((json) => ChatListTileData.fromJson(json)).toList();
      return chatListTileDataList;
    } else {
      print(response.statusCode);
      throw Exception('${response.statusCode}: すみません、エラーにより読み込めませんでした。');
    }
  }
}

class TalkListResult {
  TalkListResult({this.statusCode, this.talks});
  int statusCode;
  List<Talk> talks;
}

class TalkResult {
  TalkResult({this.statusCode, this.talk});
  int statusCode;
  Talk talk;
}

class ChatResult {
  ChatResult({this.statusCode, this.chat});
  int statusCode;
  Chat chat;
}

class ChatUnreadCountResult {
  ChatUnreadCountResult({this.statusCode, this.chatUnreadCount});
  int statusCode;
  ChatUnreadCount chatUnreadCount;
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/notice/notice.dart';

class NoticeApi {
  Future<List<Notice>> fetchMyNoticeList() async {
    final url = BASE_URL + '/api/notice_utils/fetch_my_notice_list/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final noticeList = body.map((v) => Notice.fromJson(v)).toList();
      return noticeList;
    } else {
      throw Exception('エラーにより取得できませんでした。');
    }
  }

  Future<bool> resetMyUnreadNoticeCount() async {
    final url = BASE_URL + '/api/notice_utils/reset_my_unread_notice_count/';
    final jwt = await AuthenticationUtility.getMyJwt();

    final response = await http
        .post(url, headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> fetchMyUnreadNoticeCount() async {
    final url = BASE_URL + '/api/notice_utils/fetch_my_unread_notice_count/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final unreadNoticeCount = body['unread_notice_count'];
      return unreadNoticeCount;
    } else {
      throw Exception('エラーにより取得できませんでした。');
    }
  }
}

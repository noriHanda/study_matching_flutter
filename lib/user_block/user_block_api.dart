import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/user_block/user_block.dart';

class UserBlockApi {
  Future<UserBlockResult> create({String blockedUserId}) async {
    const url = BASE_URL + '/api/user_blocks/';
    final jwt = await AuthenticationUtility.getMyJwt();

    var response = await http.post(
      url,
      body: {'blocked_user_id': blockedUserId},
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      print(body);
      final userBlock = UserBlock.fromJson(body);
      print(userBlock);
      return UserBlockResult(
          statusCode: response.statusCode, userBlock: userBlock);
    } else {
      return UserBlockResult(
          statusCode: response.statusCode,
          errorCode: body['errorCode'] as String,
          userBlock: null);
    }
  }

  Future<UserBlockListResult> fetchUserBlockList() async {
    final url = BASE_URL + '/api/user_block_utils/fetch_user_block_list';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final userBlockList = body
          .map((v) => UserBlock.fromJson(
                v,
              ))
          .toList();
      return UserBlockListResult(
          statusCode: response.statusCode, userBlockList: userBlockList);
    } else {
      return UserBlockListResult(
          statusCode: response.statusCode, userBlockList: null);
    }
  }

  Future<bool> unblock({String blockedUserId}) async {
    const url = BASE_URL + '/api/user_block_utils/unblock';
    final jwt = await AuthenticationUtility.getMyJwt();

    var response = await http.post(
      url,
      body: {'blocked_user_id': blockedUserId},
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class UserBlockResult {
  UserBlockResult({this.statusCode, this.userBlock, this.errorCode});
  int statusCode;
  String errorCode;
  UserBlock userBlock;
}

class UserBlockListResult {
  UserBlockListResult({this.statusCode, this.userBlockList});
  int statusCode;
  List<UserBlock> userBlockList;
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/user/user.dart';

class UserApi {
  Future<UserResult> fetchUser(int userId) async {
    final url = BASE_URL + '/api/users/$userId/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final user = User(
        id: body['id'],
        username: body['username'],
        iconUrl: body['icon']['thumbnail_url'],
        description: body['intro'],
        tags: (body['user_tags'].cast<int>()),
        faculty: body['faculty'],
        department: body['department'],
        grade: body['grade'],
      );
      return UserResult(statusCode: response.statusCode, user: user);
    } else {
      return UserResult(statusCode: response.statusCode, user: null);
    }
  }

  Future<UserResult> updateUserIcon(int userId, File file) async {
    final url = BASE_URL + '/api/users/$userId/';
    final jwt = await AuthenticationUtility.getMyJwt();
    final request = http.MultipartRequest("PATCH", Uri.parse(url));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'JWT ' + jwt,
    });
    request.files.add(http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: file.path, contentType: MediaType('image', 'jpeg')));
    final response = await request.send();
    dynamic userJson;
    if (response.statusCode == 200) {
      await for (var value in response.stream.transform(utf8.decoder)) {
        userJson = jsonDecode(value);
      }
      return UserResult(
          statusCode: response.statusCode,
          user: User(
              id: userJson['id'],
              username: userJson['username'],
              iconUrl: userJson['icon']['thumbnail_url'],
              description: userJson['intro'],
              tags: userJson['user_tags'].cast<int>()));
    } else {
      return UserResult(statusCode: response.statusCode, user: null);
    }
  }

  Future<UserResult> updateUser(
      int userId, Map<String, dynamic> parameterMap) async {
    final url = BASE_URL + '/api/users/$userId/';
    final jwt = await AuthenticationUtility.getMyJwt();

    final response = await http.patch(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ' + jwt,
      },
      body: jsonEncode(parameterMap),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final user = User(
          id: body['id'],
          username: body['username'],
          iconUrl: body['icon']['thumbnail_url'],
          description: body['intro'],
          tags: (body['user_tags'].cast<int>()));
      return UserResult(statusCode: response.statusCode, user: user);
    } else {
      return UserResult(statusCode: response.statusCode, user: null);
    }
  }
}

class UserResult {
  UserResult({this.statusCode, this.user});
  int statusCode;
  User user;
}

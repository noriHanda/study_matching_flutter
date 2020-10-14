import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';

class SignupResult {
  final bool isSuccess;
  final String errorMessage;

  SignupResult({this.isSuccess, this.errorMessage});
}

class AuthenticationApi {
  static Future<SignupResult> signup(
      {String username,
      String email,
      String password,
      String rePassword}) async {
    const url = BASE_URL + '/api/auth/users/';
    var response = await http.post(url, body: {
      'username': username,
      'email': email,
      'password': password,
      're_password': rePassword
    });
    if (response.statusCode == 201) {
      return SignupResult(isSuccess: true, errorMessage: '');
    } else if (response.statusCode == 400) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      var errorMessageSummary = '';
      for (var messageList in [
        body['username']?.cast<String>(),
        body['email']?.cast<String>(),
        body['password']?.cast<String>()
      ]) {
        if (messageList != null) {
          for (var message in messageList) {
            errorMessageSummary += '・' + message.toString() + '\n';
          }
        }
      }
      return SignupResult(isSuccess: false, errorMessage: errorMessageSummary);
    } else {
      return SignupResult(
          isSuccess: false,
          errorMessage: '不明なエラーです。「お問い合わせ」から、エラーの内容をお問い合わせください。');
    }
  }

  static Future<LoginResult> login(
      String emailOrUsername, String password, afterLoginedCallback) async {
    const url = BASE_URL + '/api/auth/jwt/create/';
    var response;
    final emailOrNull = RegExp(r'hokudai.ac.jp$').firstMatch(emailOrUsername);
    if (emailOrNull == null) {
      response = await http
          .post(url, body: {'username': emailOrUsername, 'password': password});
    } else {
      response = await http
          .post(url, body: {'email': emailOrUsername, 'password': password});
    }
    if (response.statusCode == 200) {
      if (afterLoginedCallback != null) {
        final tokenMap = JwtTokenMap(
            access: jsonDecode(response.body)['access'],
            refresh: jsonDecode(response.body)['refresh']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access', tokenMap.access);
        await prefs.setString('refresh', tokenMap.refresh);
        afterLoginedCallback(tokenMap);
        return LoginResult(isFailure: false, errorMessage: '');
      }
    } else {
      print("login error");
    }
    return LoginResult(
        isFailure: true, errorMessage: 'ユーザ名、メールアドレス、もしくはパスワードが間違っています。');
  }

  static Future<String> refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String refreshToken = prefs.getString('refresh');
    if (refreshToken == null) {
      return null;
    }
    const url = BASE_URL + '/api/auth/jwt/refresh/';
    final response = await http.post(url,
        body: jsonEncode({'refresh': refreshToken}),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final tokenMap = JwtTokenMap(
          access: jsonDecode(response.body)['access'],
          refresh: jsonDecode(response.body)['refresh']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', tokenMap.access);
      await prefs.setString('refresh', tokenMap.refresh);
      return tokenMap.access;
    } else {
      print("refresh error");
      return null;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', null);
    await prefs.setString('access', null);
    await prefs.setString('refresh', null);
  }

  static Future<User> fetchAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access');
    print(accessToken);
    if (accessToken != null) {
      final url = BASE_URL + '/api/auth/users/me/';
      var response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: 'JWT ' + accessToken},
      );

      if (response.statusCode == 200) {
        final authUser = jsonDecode(utf8.decode(response.bodyBytes));
        final userResult = await UserApi().fetchUser(authUser['id']);
        if (userResult.statusCode == 200) {
          return userResult.user;
        }
      }
    }
    return null;
  }

  static Future<SendingPasswordResetEmailResult> sendPasswordResetEmail(
      email) async {
    const url = BASE_URL + '/api/auth/users/reset_password/';
    var response = await http.post(url, body: {
      'email': email,
    });
    if (response.statusCode == 204) {
      return SendingPasswordResetEmailResult(isSuccess: true, errorMessage: '');
    } else if (response.statusCode == 400) {
      return SendingPasswordResetEmailResult(
          isSuccess: false, errorMessage: '入力値が間違っています。');
    } else {
      return SendingPasswordResetEmailResult(
          isSuccess: false,
          errorMessage: '不明なエラーです。「お問い合わせ」から、エラーの内容をお問い合わせください。');
    }
  }
}

class JwtTokenMap {
  JwtTokenMap({this.access, this.refresh});
  String access;
  String refresh;
}

class LoginResult {
  LoginResult({this.isFailure, this.errorMessage});
  bool isFailure;
  String errorMessage;
}

class SendingPasswordResetEmailResult {
  SendingPasswordResetEmailResult({this.isSuccess, this.errorMessage});
  bool isSuccess;
  String errorMessage;
}

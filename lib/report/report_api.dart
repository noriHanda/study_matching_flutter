import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';

class ReportApi {
  Future<bool> create({String reportedUserId, String reportContent}) async {
    const url = BASE_URL + '/api/reports/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.post(
      url,
      body: {'reported_user_id': reportedUserId, 'content': reportContent},
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

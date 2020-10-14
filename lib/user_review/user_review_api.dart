import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/user_review/user_review.dart';

class UserReviewApi {
  Future<UserReviewResult> create(
      {String reviewee, String text, String rating}) async {
    const url = BASE_URL + '/api/user_reviews/';
    final jwt = await AuthenticationUtility.getMyJwt();

    print(reviewee);

    var response = await http.post(
      url,
      body: {'reviewee': reviewee, 'text': text, 'rating': rating},
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      print(body);
      final userReview = UserReview.fromJson(body);
      print(userReview);
      return UserReviewResult(
          statusCode: response.statusCode, userReview: userReview);
    } else {
      return UserReviewResult(
          statusCode: response.statusCode,
          errorCode: body['errorCode'] as String,
          userReview: null);
    }
  }

  Future<UserReviewListResult> fetchReviewsToUser(int userId) async {
    final url = BASE_URL +
        '/api/user_review_utils/fetch_reviews_to_user?userId=$userId';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final userReviewList = body
          .map((v) => UserReview.fromJson(
                v,
              ))
          .toList();
      return UserReviewListResult(
          statusCode: response.statusCode, userReviewList: userReviewList);
    } else {
      return UserReviewListResult(
          statusCode: response.statusCode, userReviewList: null);
    }
  }
}

class UserReviewResult {
  UserReviewResult({this.statusCode, this.userReview, this.errorCode});
  int statusCode;
  String errorCode;
  UserReview userReview;
}

class UserReviewListResult {
  UserReviewListResult({this.statusCode, this.userReviewList});
  int statusCode;
  List<UserReview> userReviewList;
}

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/user_review/user_review.dart';
import 'package:study_matching/user_review/user_review_api.dart';

class UserReviewListBloc {
  BehaviorSubject<List<UserReview>> _userReviewLIstController =
      BehaviorSubject<List<UserReview>>.seeded([]);
  StreamSink<List<UserReview>> get setUserReviewListData =>
      _userReviewLIstController.sink;
  ValueObservable<List<UserReview>> get userReviewList =>
      _userReviewLIstController.stream;

  final userReviewApi = UserReviewApi();

  void fetchMyUserReviewList(int userId) async {
    final result = await userReviewApi.fetchReviewsToUser(userId);
    if (result.statusCode == 200) {
      setUserReviewListData.add(result.userReviewList);
    } else if (result.statusCode == 401) {
      setUserReviewListData.addError(401);
    } else {
      setUserReviewListData.add(null);
    }
  }

  dispose() {
    _userReviewLIstController.close();
  }
}

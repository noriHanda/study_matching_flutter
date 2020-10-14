import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';

class UserBloc {
  BehaviorSubject<User> _userController = BehaviorSubject<User>.seeded(null);
  StreamSink<User> get setUserData => _userController.sink;
  ValueObservable<User> get user => _userController.stream;
  BehaviorSubject<bool> _loadingStatusController =
      BehaviorSubject<bool>.seeded(false);
  StreamSink<bool> get setLoadingStatus => _loadingStatusController.sink;
  ValueObservable<bool> get isLoading => _loadingStatusController.stream;

  final userApi = UserApi();

  void fetchUser(int userId) async {
    setLoadingStatus.add(true);
    final result = await userApi.fetchUser(userId);
    if (result.statusCode == 200) {
      setUserData.add(result.user);
    } else if (result.statusCode == 401) {
      setUserData.addError(401);
    } else {
      setUserData.add(null);
    }
    setLoadingStatus.add(false);
  }

  dispose() {
    _userController.close();
    _loadingStatusController.close();
  }
}

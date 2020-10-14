import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/auth/authentication_api.dart';
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/user/user.dart';
import 'package:study_matching/user/user_api.dart';

class AuthBloc {
  BehaviorSubject<String> _userJwtController = BehaviorSubject<String>();
  StreamSink<String> get setUserJwt => _userJwtController.sink;
  ValueObservable<String> get userJwt => _userJwtController.stream;

  BehaviorSubject<User> _userController = BehaviorSubject<User>.seeded(null);
  StreamSink<User> get setUser => _userController.sink;
  ValueObservable<User> get user => _userController.stream;

  BehaviorSubject<bool> _loadingLoginStatusController =
      BehaviorSubject<bool>.seeded(false);
  StreamSink<bool> get setLoadingLoginStatus =>
      _loadingLoginStatusController.sink;
  ValueObservable<bool> get isLoadingLoginStatus =>
      _loadingLoginStatusController.stream;

  final userApi = UserApi();

  AuthBloc() {
    loadUserData();
    userJwt.listen((jwt) {
      if (jwt != null)
        fetchAndSetUser();
      else
        setLoadingLoginStatus.add(false);
    });
  }

  void loadUserData() async {
    setLoadingLoginStatus.add(true);
    await AuthenticationApi.refresh();
    final access = await AuthenticationUtility.getMyJwt();
    setUserJwt.add(access);
    setLoadingLoginStatus.add(false);
  }

  Future<void> fetchAndSetUser() async {
    final user = await AuthenticationApi.fetchAuthUser();
    setUser.add(user);
  }

  void logout() async {
    await AuthenticationApi.logout();
    setUserJwt.add(null);
    setUser.add(null);
  }

  dispose() {
    _userJwtController.close();
    _userController.close();
    _loadingLoginStatusController.close();
  }
}

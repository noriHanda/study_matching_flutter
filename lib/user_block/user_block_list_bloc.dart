import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/user_block/user_block.dart';
import 'package:study_matching/user_block/user_block_api.dart';

class UserBlockListBloc {
  BehaviorSubject<List<UserBlock>> _userblockListController =
      BehaviorSubject<List<UserBlock>>.seeded(null);
  StreamSink<List<UserBlock>> get setUserBlockListData =>
      _userblockListController.sink;
  ValueObservable<List<UserBlock>> get userBlockList =>
      _userblockListController.stream;

  final userBlockApi = UserBlockApi();

  Future<void> fetchUserBlockList() async {
    final result = await userBlockApi.fetchUserBlockList();
    if (result.statusCode == 200) {
      setUserBlockListData.add(result.userBlockList);
    } else if (result.statusCode == 401) {
      setUserBlockListData.addError(401);
    } else {
      setUserBlockListData.add(null);
    }
  }

  dispose() {
    _userblockListController.close();
  }
}

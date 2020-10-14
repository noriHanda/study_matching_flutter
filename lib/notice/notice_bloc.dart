import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/notice/notice.dart';
import 'package:study_matching/notice/notice_api.dart';

class NoticeBloc {
  BehaviorSubject<List<Notice>> _noticeController =
      BehaviorSubject<List<Notice>>.seeded(null);
  StreamSink<List<Notice>> get setNotificationData => _noticeController.sink;
  ValueObservable<List<Notice>> get notices => _noticeController.stream;

  BehaviorSubject<int> _unreadNoticeCountController =
      BehaviorSubject<int>.seeded(0);
  StreamSink<int> get setUnreadNoticeCount => _unreadNoticeCountController.sink;
  ValueObservable<int> get unreadNoticeCount =>
      _unreadNoticeCountController.stream;

  final noticeApi = NoticeApi();

  Future<void> fetchMyNoticeList() async {
    try {
      final noticeList = await noticeApi.fetchMyNoticeList();
      setNotificationData.add(noticeList);
    } catch (e) {
      setNotificationData.addError(e.message);
    }
  }

  Future<void> fetchMyUnreadNoticeCount() async {
    try {
      final myUnreadNoticeCount = await noticeApi.fetchMyUnreadNoticeCount();
      setUnreadNoticeCount.add(myUnreadNoticeCount);
    } catch (e) {
      setUnreadNoticeCount.addError(e.message);
    }
  }

  Future<void> resetMyUnreadNoticeCount() async {
    await noticeApi.resetMyUnreadNoticeCount();
  }

  dispose() {
    _noticeController.close();
    _unreadNoticeCountController.close();
  }
}

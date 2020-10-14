import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/tag/tag.dart';
import 'package:study_matching/tag/tag_api.dart';

class TagBloc {
  TagBloc() {
    fetchTags();
  }

  BehaviorSubject<List<Tag>> _tagController =
      BehaviorSubject<List<Tag>>.seeded([]);
  StreamSink<List<Tag>> get setTagData => _tagController.sink;
  ValueObservable<List<Tag>> get tags => _tagController.stream;

  final tagApi = TagApi();

  void fetchTags() async {
    final result = await tagApi.fetchAll();
    if (result.statusCode == 200) {
      setTagData.add(result.tags);
    } else if (result.statusCode == 401) {
      setTagData.addError(401);
    } else {
      setTagData.add(null);
    }
  }

  dispose() {
    _tagController.close();
  }
}

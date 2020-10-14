import 'dart:async';

import 'package:rxdart/rxdart.dart';

class OfferSearchSelectedTagBloc {
  BehaviorSubject<List<int>> _selectedTagIdController =
      BehaviorSubject<List<int>>.seeded([]);
  StreamSink<List<int>> get setSelectedTagIdList =>
      _selectedTagIdController.sink;
  ValueObservable<List<int>> get ids => _selectedTagIdController.stream;

  dispose() {
    _selectedTagIdController.close();
  }
}

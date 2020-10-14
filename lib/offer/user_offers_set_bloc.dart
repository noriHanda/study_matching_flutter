import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/offer/offer_api.dart';
import 'package:study_matching/offer/user_offers_set.dart';

class UserOffersSetBloc {
  UserOffersSetBloc() {
    fetchUserOffersSets();
  }

  BehaviorSubject<List<UserOffersSet>> _offerController =
      BehaviorSubject<List<UserOffersSet>>.seeded([]);
  StreamSink<List<UserOffersSet>> get setUserOffersSetData =>
      _offerController.sink;
  ValueObservable<List<UserOffersSet>> get userOffersSetList =>
      _offerController.stream;

  final offerApi = OfferApi();

  Future<void> fetchUserOffersSets() async {
    final result = await offerApi.fetchUserOfferSetList(limit: 50, offset: 0);
    if (result.statusCode == 200) {
      setUserOffersSetData.add(result.userOfferSetList);
    } else if (result.statusCode == 401) {
      setUserOffersSetData.addError(401);
    } else {
      setUserOffersSetData.add(null);
    }
  }

  dispose() {
    _offerController.close();
  }
}

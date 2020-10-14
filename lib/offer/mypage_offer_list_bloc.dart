import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_api.dart';

class MyPageOfferListBloc {
  BehaviorSubject<List<Offer>> _offerController =
      BehaviorSubject<List<Offer>>.seeded([]);
  StreamSink<List<Offer>> get setOfferData => _offerController.sink;
  ValueObservable<List<Offer>> get offers => _offerController.stream;

  final offerApi = OfferApi();

  Future<void> fetchOffers(int userId) async {
    final result = await offerApi.fetchIndividualUserOfferList(userId: userId);
    if (result.statusCode == 200) {
      setOfferData.add(result.offers);
    } else if (result.statusCode == 401) {
      setOfferData.addError(401);
    } else {
      setOfferData.add(null);
    }
  }

  dispose() {
    _offerController.close();
  }
}

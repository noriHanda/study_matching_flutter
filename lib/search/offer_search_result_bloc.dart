import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/search/offer_search_api.dart';

class OfferSearchResultBloc {
  BehaviorSubject<List<Offer>> _offerController =
      BehaviorSubject<List<Offer>>.seeded([]);
  StreamSink<List<Offer>> get setOfferData => _offerController.sink;
  ValueObservable<List<Offer>> get offers => _offerController.stream;

  final offerSearchApi = OfferSearchApi();

  void searchOffers({List<int> queryTagList}) async {
    final result = await offerSearchApi.searchOffer(queryTagList);
    if (result.statusCode == 200) {
      setOfferData.add(result.offers);
    } else if (result.statusCode == 401) {
      setOfferData.addError(401);
    } else {
      setOfferData.add([]);
    }
  }

  dispose() {
    _offerController.close();
  }
}

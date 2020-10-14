import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/offer_api.dart';

class ProfileOfferListBloc {
  BehaviorSubject<List<Offer>> _offerController =
      BehaviorSubject<List<Offer>>.seeded([]);
  StreamSink<List<Offer>> get setOfferData => _offerController.sink;
  ValueObservable<List<Offer>> get offers => _offerController.stream;
  BehaviorSubject<bool> _offerLoadingStatusController =
      BehaviorSubject<bool>.seeded(false);
  StreamSink<bool> get setOfferLoadingStatus =>
      _offerLoadingStatusController.sink;
  ValueObservable<bool> get isLoadingOffer =>
      _offerLoadingStatusController.stream;

  final offerApi = OfferApi();

  Future<void> fetchOffers(int userId) async {
    setOfferLoadingStatus.add(true);
    final result = await offerApi.fetchIndividualUserOfferList(userId: userId);
    if (result.statusCode == 200) {
      setOfferData.add(result.offers);
    } else if (result.statusCode == 401) {
      setOfferData.addError(401);
    } else {
      setOfferData.add(null);
    }
    setOfferLoadingStatus.add(false);
  }

  dispose() {
    _offerController.close();
    _offerLoadingStatusController.close();
  }
}

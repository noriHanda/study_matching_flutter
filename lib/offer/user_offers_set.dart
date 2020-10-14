import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/user/user.dart';

class UserOffersSet {
  UserOffersSet({this.user, this.offers});
  final List<Offer> offers;
  final User user;
}

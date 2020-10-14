import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/offer/offer.dart';

class OfferSearchApi {
  Future<OfferListResult> searchOffer(List<int> tags) async {
    const url = BASE_URL + '/api/search/offers/tags';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          HttpHeaders.authorizationHeader: 'JWT ' + jwt
        },
        body: jsonEncode({'user_tags': tags}));

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final offers = body
          .map((v) => Offer(
              id: v['id'],
              title: v['title'],
              description: v['description'],
              iconUrl: v['image']['thumbnail_url']))
          .toList();
      return OfferListResult(statusCode: response.statusCode, offers: offers);
    } else {
      return OfferListResult(statusCode: response.statusCode, offers: []);
    }
  }
}

class OfferListResult {
  OfferListResult({this.statusCode, this.offers});
  int statusCode;
  List<Offer> offers;
}

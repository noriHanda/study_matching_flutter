import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/offer/user_offers_set.dart';
import 'package:study_matching/user/user.dart';

class OfferApi {
  Future<OfferListResult> fetchAll() async {
    const url = BASE_URL + '/api/offers';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final offers = body.map((v) => Offer.fromJson(v)).toList();
      return OfferListResult(statusCode: response.statusCode, offers: offers);
    } else {
      return OfferListResult(statusCode: response.statusCode, offers: []);
    }
  }

  Future<OfferResult> create(
      String title, String description, File file, String matchingWay) async {
    const url = BASE_URL + '/api/offers/';
    final jwt = await AuthenticationUtility.getMyJwt();

    final request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'JWT ' + jwt,
    });
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['matching_way'] = matchingWay;
    request.files.add(http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: file.path, contentType: MediaType('image', 'jpeg')));
    final response = await request.send();
    dynamic offerJson;
    if (response.statusCode == 201) {
      await for (var value in response.stream.transform(utf8.decoder)) {
        offerJson = jsonDecode(value);
        return OfferResult(
            statusCode: response.statusCode, offer: Offer.fromJson(offerJson));
      }
    }
    return OfferResult(statusCode: response.statusCode, offer: null);
  }

  Future<OfferResult> update(int offerId, String title, String description,
      File file, String matchingWay) async {
    final url = BASE_URL + '/api/offers/$offerId/';
    final jwt = await AuthenticationUtility.getMyJwt();

    final request = http.MultipartRequest("PATCH", Uri.parse(url));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'JWT ' + jwt,
    });
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['matching_way'] = matchingWay;
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'file', file.readAsBytesSync(),
          filename: file.path, contentType: MediaType('image', 'jpeg')));
    }
    final response = await request.send();
    dynamic offerJson;
    if (response.statusCode == 200) {
      await for (var value in response.stream.transform(utf8.decoder)) {
        offerJson = jsonDecode(value);
        final offer = Offer.fromJson(offerJson);
        return OfferResult(statusCode: response.statusCode, offer: offer);
      }
    }
    return OfferResult(statusCode: response.statusCode, offer: null);
  }

  Future<bool> delete(int offerId) async {
    final url = BASE_URL + '/api/offers/$offerId/';
    final jwt = await AuthenticationUtility.getMyJwt();

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ' + jwt,
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserOfferSetListResult> fetchUserOfferSetList(
      {int limit, int offset}) async {
    final url = BASE_URL +
        '/api/offer_utils/fetch_user_offer_set_list?limit=$limit&offset=$offset';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print(body);

      body.forEach((v) {
        print((v['offers'] as List<dynamic>)
            .map((k) => Offer.fromJson(k as Map<String, dynamic>))
            .toList());
      });
      final userOfferSetList = body
          .map((v) => UserOffersSet(
              offers: (v['offers'] as List<dynamic>)
                  .map((k) => Offer.fromJson(k as Map<String, dynamic>))
                  .toList(),
              user: User.fromJson(v['user'])))
          .toList();
      userOfferSetList.forEach((UserOffersSet v) {
        print(v.user.username);
      });
      return UserOfferSetListResult(
          statusCode: response.statusCode, userOfferSetList: userOfferSetList);
    } else {
      return UserOfferSetListResult(
          statusCode: response.statusCode, userOfferSetList: null);
    }
  }

  Future<UserOfferSetListResult> fetchUserOfferSetListLoggedOut(
      {int limit, int offset}) async {
    final url = BASE_URL +
        '/api/offer_utils/fetch_user_offer_set_list_logged_out?limit=$limit&offset=$offset';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      body.forEach((v) {
        print((v['offers'] as List<dynamic>)
            .map((k) => Offer.fromJson(k as Map<String, dynamic>))
            .toList());
      });

      final userOfferSetList = body
          .map((v) => UserOffersSet(
              offers: (v['offers'] as List<dynamic>)
                  .map((k) => Offer.fromJson(k as Map<String, dynamic>))
                  .toList(),
              user: User.fromJson(v['user'])))
          .toList();

      userOfferSetList.forEach((UserOffersSet v) {
        print(v.user.username);
      });

      return UserOfferSetListResult(
          statusCode: response.statusCode, userOfferSetList: userOfferSetList);
    } else {
      return UserOfferSetListResult(
          statusCode: response.statusCode, userOfferSetList: null);
    }
  }

  Future<OfferListResult> fetchIndividualUserOfferList({int userId}) async {
    final url = BASE_URL +
        '/api/offer_utils/fetch_individual_user_offer_list?userId=$userId';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final offers = body.map((v) => Offer.fromJson(v)).toList();
      return OfferListResult(statusCode: response.statusCode, offers: offers);
    } else {
      return OfferListResult(statusCode: response.statusCode, offers: []);
    }
  }
}

// Method for logged out version of the method above
/*Future<OfferListResult> fetchIndividualUserOfferListLoggedOut(
      {int userId}) async {
    final url = BASE_URL +
        '/api/offer_utils/fetch_individual_user_offer_list_logged_out?userId=$userId';
    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final offers = body.map((v) => Offer.fromJson(v)).toList();
      return OfferListResult(statusCode: response.statusCode, offers: offers);
    } else
      return OfferListResult(statusCode: response.statusCode, offers: []);
  }*/

class OfferListResult {
  OfferListResult({this.statusCode, this.offers});
  int statusCode;
  List<Offer> offers;
}

class OfferResult {
  OfferResult({this.statusCode, this.offer});
  int statusCode;
  Offer offer;
}

class UserOfferSetListResult {
  UserOfferSetListResult({this.statusCode, this.userOfferSetList});
  int statusCode;
  List<UserOffersSet> userOfferSetList;
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:study_matching/auth/utils.dart';
import 'package:study_matching/base_url.dart';
import 'package:study_matching/offer/offer.dart';
import 'package:study_matching/tag/tag.dart';

class TagApi {
  Future<TagListResult> fetchAll() async {
    const url = BASE_URL + '/api/tags/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final tags = body.map((v) => Tag(id: v['id'], name: v['name'])).toList();
      //print(tags);
      return TagListResult(statusCode: response.statusCode, tags: tags);
    } else {
      //print(response.statusCode);
      return TagListResult(statusCode: response.statusCode, tags: []);
    }
  }

  Future<OfferResult> create(String title, String description) async {
    const url = BASE_URL + '/api/offers/';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.post(
      url,
      body: {'title': title, 'description': description},
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      final offer = Offer(
          id: body['id'],
          title: body['title'],
          description: body['description']);
      print(offer);
      return OfferResult(statusCode: response.statusCode, offer: offer);
    } else {
      return OfferResult(statusCode: response.statusCode, offer: null);
    }
  }

  Future<TagListResult> fetchUserHavingTags(int userId) async {
    final url =
        BASE_URL + '/api/tag_utils/fetch_user_having_tags?user_id=$userId';
    final jwt = await AuthenticationUtility.getMyJwt();
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'JWT ' + jwt},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      final tags = body.map((v) => Tag(id: v['id'], name: v['name'])).toList();
      //print(tags);
      return TagListResult(statusCode: response.statusCode, tags: tags);
    } else {
      //print(response.statusCode);
      return TagListResult(statusCode: response.statusCode, tags: []);
    }
  }
}

class TagListResult {
  TagListResult({this.statusCode, this.tags});
  int statusCode;
  List<Tag> tags;
}

class OfferResult {
  OfferResult({this.statusCode, this.offer});
  int statusCode;
  Offer offer;
}

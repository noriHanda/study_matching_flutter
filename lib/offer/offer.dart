import 'package:study_matching/offer/matching_way_radio_button.dart';

class Offer {
  Offer({
    this.id,
    this.title,
    this.description,
    this.matchingWay,
    this.userId,
    this.iconUrl,
  });

  Offer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['offerer'],
        title = json['title'],
        description = json['description'],
        matchingWay = json['matching_way'] ?? matchingWays['ChatMainly'],
        iconUrl = json['image']['thumbnail_url'],
        updatedDate = json['updatedDate'];

  final int id;
  final int userId;
  final String title;
  final String description;
  final String matchingWay;
  final String iconUrl;
  DateTime createdDate;
  DateTime updatedDate;
}

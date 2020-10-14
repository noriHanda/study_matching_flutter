class UserReview {
  UserReview(
      {this.id,
      this.text,
      this.reviewer,
      this.reviewee,
      this.rating,
      this.createdAt});

  UserReview.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reviewer = json['reviewer'],
        reviewee = json['reviewee'],
        text = json['text'],
        rating = json['rating'],
        createdAt = DateTime.parse(json['created_at']).toLocal();

  final int id;
  final String text;
  final int reviewer;
  final int reviewee;
  final int rating;
  final DateTime createdAt;
}

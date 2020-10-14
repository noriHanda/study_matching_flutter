class Notice {
  Notice({this.id, this.body, this.link, this.imageUrl, this.createdDate});

  Notice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        body = json['body'],
        imageUrl = json['image_url'],
        link = json['link'],
        createdDate = DateTime.parse(json['created_at']).toLocal();

  final int id;
  final String body;
  final String link;
  final String imageUrl;
  final DateTime createdDate;
}

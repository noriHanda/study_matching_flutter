class Talk {
  Talk({this.id, this.userId, this.sentence, this.createdDate});

  Talk.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        this.sentence = json['sentence'],
        this.userId = json['talker'],
        this.createdDate = DateTime.parse(json['created_at']).toLocal();

  int userId;
  int id;
  String sentence;
  DateTime createdDate;
}

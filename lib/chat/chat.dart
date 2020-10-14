class Chat {
  Chat({this.id, this.user1, this.user2, this.createdDate});

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        this.user1 = json['user1'],
        this.user2 = json['user2'],
        this.createdDate = DateTime.parse(json['created_at']).toLocal();

  int id;
  int user1;
  int user2;
  DateTime createdDate;
  DateTime updatedDate;
}

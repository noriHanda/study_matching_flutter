class UserBlock {
  UserBlock({this.id, this.blockedUser, this.blockingUser, this.createdAt});

  UserBlock.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        blockedUser = json['blocked_user'],
        blockingUser = json['blocking_user'],
        createdAt = DateTime.parse(json['created_at']).toLocal();

  final int id;
  final int blockedUser;
  final int blockingUser;
  final DateTime createdAt;
}

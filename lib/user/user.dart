class User {
  User(
      {this.id,
      this.username,
      this.iconUrl,
      this.description,
      this.tags,
      this.faculty,
      this.department,
      this.grade});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        description = json['intro'],
        iconUrl = json['icon'] != null ? json['icon']['thumbnail_url'] : null,
        tags = json['user_tags'].cast<int>(),
        faculty = json['faculty'],
        department = json['department'],
        grade = json['grade'];

  int id;
  String username;
  String iconUrl;
  String description;
  String faculty;
  String department;
  String grade;
  List<int> tags;
}

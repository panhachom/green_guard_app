class BlogModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String createdAt;
  BlogModel(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body,
      required this.createdAt});

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        body: json['body'],
        createdAt: json['created_at']);
  }
}

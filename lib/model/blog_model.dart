class BlogModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  BlogModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

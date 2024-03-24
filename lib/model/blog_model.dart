import 'package:green_guard_app/model/image_model.dart';
import 'package:green_guard_app/model/user_model.dart';

class BlogModel {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final String? subtitle;
  final String? createdAt;
  final String? category;
  final int? status;
  final UserModel? user;
  final List<ImageModel>? images;

  BlogModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.createdAt,
    this.category,
    this.status,
    this.subtitle,
    this.user,
    this.images,
  });

  static const Map<String, String> CATEGORIES = {
    'rice_blast': 'ជំងឺ​រលួយក​ស្រូវ',
    'brown_spot': 'ជំងឺអុតត្នោត',
    'bacterial_Leaf_blight': 'ជំងឺបាក់តេរីរលាកស្លឺក',
    'stem_rot': 'ជំងឺរលួយដើម',
    'falsa_Smut': 'ជំងឺធ្យូងបៃតង',
    'tungro_diseases': 'ជំងឺទុងគ្រោ',
    'sheathBlight': 'ជំងឺរលាកស្រទងស្លឹក',
    'other': 'ផ្សេងទៀត',
  };

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      createdAt: json['created_at'],
      category: json['category'],
      status: json['status'],
      subtitle: json['sub_title'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      images: (json['images'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
    );
  }
}

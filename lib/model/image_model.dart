class ImageModel {
  final int id;
  final int parentId;
  final String parentType;
  final String fileName;
  final String filePath;
  final String fileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ImageModel({
    required this.id,
    required this.parentId,
    required this.parentType,
    required this.fileName,
    required this.filePath,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      parentId: json['parent_id'],
      parentType: json['parent_type'],
      fileName: json['file_name'],
      filePath: json['file_path'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

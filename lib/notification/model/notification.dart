class NotificationModel {
  late String id;
  late String title;
  late String message;
  // late String userImage;
  late String? fileUrl;
  late DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.fileUrl,
    required this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    fileUrl = json['file-url'] ?? "";

    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;

    data['title'] = title;
    data['message'] = message;
    data['file-url'] = fileUrl ?? "";
    data['createdAt'] = createdAt.toIso8601String();

    return data;
  }
}

class NotificationModel {
  late String id;
  late String title;
  late String message;
  // late String userImage;
  late String? fileUrl;
  late String? fileName;
  late String? fileType;
  late DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    required this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['notificationId'];
    title = json['notificationTitle'];
    message = json['notificationText'];
    fileUrl = json['fileUrl'] ?? "";
    fileName = json['fileName'] ?? "";
    fileType = json['file-type'] ?? "";
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['notificationId'] = id;
    data['notificationTitle'] = title;
    data['notificationText'] = message;
    data['fileUrl'] = fileUrl ?? "";
    data['fileName'] = fileName ?? "";
    data['file-type'] = fileType ?? "";
    data['createdAt'] = createdAt.toIso8601String();

    return data;
  }
}

class NoticesModel {
  late String noticeId;
  late String noticeTitle;
  late String noticeText;
  late String? fileType;
  late String? fileUrl;
  late String? fileName;
  late DateTime createdAt;

  NoticesModel({
    required this.noticeId,
    required this.noticeTitle,
    required this.noticeText,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    required this.createdAt,
  });

  NoticesModel.fromJson(Map<String, dynamic> json) {
    noticeId = json['noticeId'];
    noticeTitle = json['noticeTitle'];
    noticeText = json['noticeText'];
    fileUrl = json['fileUrl'] ?? "";
    fileName = json['fileName'] ?? "";
    fileType = json['file-type'] ?? "";
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['noticeId'] = noticeId;
    data['noticeTitle'] = noticeTitle;
    data['noticeText'] = noticeText;
    data['fileUrl'] = fileUrl ?? "";
    data['fileName'] = fileName ?? "";
    data['file-type'] = fileType ?? "";
    data['createdAt'] = createdAt.toIso8601String();

    return data;
  }
}

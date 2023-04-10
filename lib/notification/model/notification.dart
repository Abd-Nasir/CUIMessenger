class NotificationModel {
  late String sId;
  late String userid;
  late String messageFrom;
  late String messageTo;
  late String fullName;
  late String message;
  // late String userImage;
  late DateTime createdAt;
  late DateTime updatedAt;

  NotificationModel({
    required this.sId,
    required this.userid,
    required this.messageFrom,
    required this.messageTo,
    required this.fullName,
    required this.message,
    // required this.userImage,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    messageFrom = json['message-from'];
    messageTo = json['message-to'];
    fullName = json['full-name'];
    message = json['message'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    data['message-from'] = messageFrom;
    data['message-to'] = messageTo;
    data['full-name'] = fullName;
    data['message'] = message;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();

    return data;
  }
}

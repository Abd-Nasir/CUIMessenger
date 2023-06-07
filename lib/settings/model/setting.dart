class Setting {
  late bool chatNotifications;

  late bool noticeNotification;

  Setting({
    required this.chatNotifications,
    required this.noticeNotification,
  });

  Setting.fromJson(Map<String, dynamic> json) {
    chatNotifications = json['chatNotifications'];
    noticeNotification = json['noticeNotification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatNotifications'] = chatNotifications;
    data['noticeNotification'] = noticeNotification;

    return data;
  }
}

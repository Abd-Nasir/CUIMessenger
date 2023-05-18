import 'package:hive/hive.dart';
part 'setting.g.dart';

@HiveType(typeId: 0)
class Setting {
  @HiveField(0)
  late bool chatNotifications;

  @HiveField(1)
  late bool noticeNotification;

  // @HiveField(2)
  // late String languageCode;

  // @HiveField(3)
  // late String countryCode;

  // @HiveField(4)
  // late bool fingerprint;

  // @HiveField(5)
  // late bool notifications;

  // @HiveField(6)
  // late bool emeAlarm;

  // @HiveField(7)
  // late bool dangerzoneAlert;

  // @HiveField(8)
  // late bool opensFirst;

  // @HiveField(9)
  // late bool geoFenceActive;

  Setting({
    required this.chatNotifications,
    required this.noticeNotification,
    // required this.languageCode,
    // required this.countryCode,
    // required this.fingerprint,
    // required this.notifications,
    // required this.emeAlarm,
    // required this.dangerzoneAlert,
    // required this.opensFirst,
    // required this.geoFenceActive,
  });

  Setting.fromJson(Map<String, dynamic> json) {
    chatNotifications = json['chat-notifications'];
    noticeNotification = json['noticeNotification'];
    // languageCode = json['language-code'];
    // countryCode = json['country-code'];
    // fingerprint = json['fingerprint'];
    // notifications = json['notifications'];
    // emeAlarm = json['emergency-alarm'];
    // dangerzoneAlert = json['dangerzone-alert'];
    // opensFirst = json["opens-first"];
    // geoFenceActive = json['geo-fence-active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat-notifications'] = chatNotifications;
    data['noticeNotification'] = noticeNotification;
    // data['language-code'] = languageCode;
    // data['country-code'] = countryCode;
    // data['fingerprint'] = fingerprint;
    // data['notifications'] = notifications;
    // data['emergency-alarm'] = emeAlarm;
    // data['dangerzone-alert'] = dangerzoneAlert;
    // data["opens-first"] = opensFirst;
    // data['geo-fence-active'] = geoFenceActive;
    return data;
  }
}

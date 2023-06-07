import 'package:cui_messenger/settings/model/setting.dart';

abstract class SettingEvents {
  const SettingEvents();
}

class InitialSettingsEvent extends SettingEvents {
  const InitialSettingsEvent() : super();
}

class ChangeNoticeNotificationsEvent extends SettingEvents {
  final Setting setting;
  const ChangeNoticeNotificationsEvent({required this.setting}) : super();
}

class ChangeChatNotificationsEvent extends SettingEvents {
  final Setting setting;

  const ChangeChatNotificationsEvent({required this.setting}) : super();
}

abstract class SettingEvents {
  const SettingEvents();
}

class InitialSettingsEvent extends SettingEvents {
  const InitialSettingsEvent() : super();
}

class ChangeNotificationsEvent extends SettingEvents {
  const ChangeNotificationsEvent() : super();
}

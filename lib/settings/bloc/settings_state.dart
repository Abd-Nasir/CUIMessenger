import 'package:cui_messenger/settings/bloc/settings_provider.dart';
import 'package:cui_messenger/settings/model/setting.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class SettingsState extends Equatable {
  final Setting settings;
  final SettingsProvider provider;

  const SettingsState({required this.settings, required this.provider});

  factory SettingsState.initial(SettingsProvider provider) {
    var settingBox = Hive.box("settings");
    Setting settings = settingBox.get('settings');

    return SettingsState(
      settings: settings,
      provider: provider,
    );
  }

  SettingsState copyWith(
          {Setting? settings, SettingsProvider? provider, int? count}) =>
      SettingsState(
        settings: settings ?? this.settings,
        provider: provider ?? this.provider,
      );

  @override
  List<Object?> get props => [settings, provider];
}

class SettingStateLoading extends SettingsState {
  const SettingStateLoading({required super.settings, required super.provider});
}

class SettingStateMessageStateLoading extends SettingsState {
  const SettingStateMessageStateLoading(
      {required super.settings, required super.provider});
}

class SettingStateNotificationUpdated extends SettingsState {
  const SettingStateNotificationUpdated(
      {required super.settings, required super.provider});
}

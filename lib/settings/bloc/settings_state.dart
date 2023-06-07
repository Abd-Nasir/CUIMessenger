import 'package:cui_messenger/settings/bloc/settings_provider.dart';
import 'package:equatable/equatable.dart';

// import 'package:hive/hive.dart';

class SettingsState extends Equatable {
  final SettingsProvider settingsProvider;

  const SettingsState({required this.settingsProvider});

  SettingsState copyWith({SettingsProvider? settingsProvider}) => SettingsState(
      settingsProvider: settingsProvider ?? this.settingsProvider);

  @override
  List<Object?> get props => [settingsProvider];
}

// class SettingsInitialState extends SettingsState {
//   const SettingsInitialState({required SettingsProvider settingsProvider})
//       : super(settingsProvider: settingsProvider,settings: this.settings);
// }

class SettingStateLoading extends SettingsState {
  const SettingStateLoading({required super.settingsProvider});
}

// class SettingStateMessageStateLoading extends SettingsState {
//   const SettingStateMessageStateLoading({required super.settingsProvider});
// }

class SettingStateNotificationUpdated extends SettingsState {
  const SettingStateNotificationUpdated({required super.settingsProvider});
}

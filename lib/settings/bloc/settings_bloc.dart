import 'package:cui_messenger/settings/bloc/settings_event.dart';
import 'package:cui_messenger/settings/bloc/settings_provider.dart';
import 'package:cui_messenger/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';

class SettingsBloc extends Bloc<SettingEvents, SettingsState> {
  SettingsBloc(SettingsProvider settingsProvider)
      : super(SettingsState(settingsProvider: settingsProvider)) {
    on<InitialSettingsEvent>(
      (event, emit) async {
        emit(SettingStateLoading(settingsProvider: settingsProvider));

        await settingsProvider.loadNotificationStatus().then((value) {
          emit(SettingStateNotificationUpdated(
              settingsProvider: settingsProvider));
        });
      },
    );

    on<ChangeNoticeNotificationsEvent>((event, emit) async {
      settingsProvider.changeNoticeNotificationAlert(setting: event.setting);
    });

    on<ChangeChatNotificationsEvent>((event, emit) async {
      settingsProvider.changeChatNotificationAlert(setting: event.setting);
    });
  }
}

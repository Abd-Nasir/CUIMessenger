import 'package:cui_messenger/settings/bloc/settings_event.dart';
import 'package:cui_messenger/settings/bloc/settings_provider.dart';
import 'package:cui_messenger/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsBloc extends Bloc<SettingEvents, SettingsState> {
  SettingsBloc(SettingsProvider settingProvider)
      : super(SettingsState.initial(settingProvider)) {
    on<InitialSettingsEvent>(
      (event, emit) async {
        settingProvider.settings.chatNotifications =
            await Permission.notification.isGranted ||
                await Permission.notification.isLimited;
      },
    );

    on<ChangeNotificationsEvent>((event, emit) {
      emit(SettingStateLoading(
          settings: settingProvider.settings, provider: settingProvider));
      settingProvider.changeNotificationAlert();
      emit(SettingStateNotificationUpdated(
          settings: settingProvider.settings, provider: settingProvider));
    });
  }
}

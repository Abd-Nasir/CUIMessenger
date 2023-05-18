// import 'package:background_fetch/background_fetch.dart';
import 'package:cui_messenger/settings/model/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsProvider {
  late Box<dynamic> settingBox;
  late Setting settings;
  bool initialized = false;

  int count = 0;
  SettingsProvider();

  bool? isDarkMode;

  void themeinfo() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.dark) {
      isDarkMode = true;
    } else {
      isDarkMode = false;
    }
    // isDarkMode = brightness == Brightness.dark;
  }

  // void onClickEnable(bool enabled) {
  //   if (enabled) {
  //     BackgroundFetch.start().then((int status) {
  //       debugPrint('[BackgroundFetch] start success: $status');
  //     }).catchError((e) {
  //       debugPrint('[BackgroundFetch] start FAILURE: $e');
  //     });
  //   } else {
  //     BackgroundFetch.stop().then((int status) {
  //       debugPrint('[BackgroundFetch] stop success: $status');
  //     });
  //   }
  // }

  // void _onClickStatus() async {
  //   int status = await BackgroundFetch.status;
  //   debugPrint('[BackgroundFetch] status: $status');
  // }

  Future<void> loadFromDB() async {
    await Hive.openBox("settings").then((value) {
      settings = value.get('settings');
      settingBox = value;
      initialized = true;
    });
  }

  void changeNotificationAlert() {
    debugPrint("Pressed chat Notification Alert");
    settings.chatNotifications = !settings.chatNotifications;
    settingBox.put('settings', settings);
  }

  // void changeNotifications() async {
  //   debugPrint("pressed me!");
  //   if (!settings.noticeNotification) {
  //     if (await Permission.notification.isPermanentlyDenied) {
  //       await openAppSettings();
  //       settings.notifications = await Permission.notification.isGranted ||
  //           await Permission.notification.isLimited;
  //       settingBox.put('settings', settings);
  //       onClickEnable(settings.notifications);
  //     } else {
  //       await openAppSettings();
  //       settings.notifications =
  //           await Permission.notification.isPermanentlyDenied ||
  //               await Permission.notification.isDenied;
  //       settingBox.put('settings', settings);
  //       onClickEnable(settings.notifications);
  //     }
  //   } else {
  //     await openAppSettings();
  //     settings.notifications =
  //         await Permission.notification.isPermanentlyDenied ||
  //             await Permission.notification.isDenied;
  //     settingBox.put('settings', settings);
  //     onClickEnable(settings.notifications);
  //   }
  // }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/settings/model/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsProvider {
  Setting? settings;
  final user = FirebaseAuth.instance.currentUser;

  SettingsProvider();
  // Static instance to access api without initialization
  static SettingsProvider instance = SettingsProvider();

  Future<bool> loadNotificationStatus() async {
    FirebaseFirestore.instance
        .collection("registered-users")
        .doc(user!.uid)
        .get()
        .then((value) {
      UserModel userModel = UserModel.fromJson(value.data()!);
      Setting tempSetting = Setting(
          chatNotifications: userModel.chatNotification,
          noticeNotification: userModel.noticeNotification);
      settings = tempSetting;
    });

    return true;
  }

  void changeNoticeNotificationAlert({required Setting setting}) {
    FirebaseFirestore.instance
        .collection("registered-users")
        .doc(user!.uid)
        .update({"noticeNotification": setting.noticeNotification});
  }

  void changeChatNotificationAlert({required Setting setting}) {
    FirebaseFirestore.instance
        .collection("registered-users")
        .doc(user!.uid)
        .update({"chatNotification": setting.chatNotifications});
  }
}

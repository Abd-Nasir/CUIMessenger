import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cui_messenger/notification/model/myNotification.dart';
import 'package:cui_messenger/notification/model/notification.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:overlay_support/overlay_support.dart';
// import 'package:safepall/screens/authentication/model/user.dart' as user_model;
// import 'package:sendbird_sdk/sendbird_sdk.dart';

class NotificationProvider {
  // final sendBird = SendbirdSdk(appId: "5063F43D-4021-44AC-9331-DADE6A5A2130");
  // User? user;
  // GroupChannel? currentChannel;
  List<NotificationModel> notifications = [];

  // List<BaseMessage> messages = List.empty(growable: true);

  Future<void> loadNotifications() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .get()
        .then((value) {
      notifications.clear();
      value.docs.forEach((value) {
        notifications.add(NotificationModel.fromJson(value.data()));
      });
    });
  }

  void sendNotificationRange() {
    fb.User? user = fb.FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("users").get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          if (snapshot.docs[i].data()['uid'] != user!.uid) {
            getToken(snapshot.docs[i].data()['uid']);
          }
        }
      }
    });
  }

  void getToken(String uid) {
    String? token;
    Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('token')
            .get();
    querySnapshot.then((snapshot) {
      token = snapshot.docs.first.id;
      sendNotification(token, "Hey there", "Notification Body");
      // print(token);
    });
  }

  void sendNotification(String? token, String? title, String? body) {
    createNotification(MyNotification(
        to: token, notification: NotificationBody(title: title, body: body)));
  }

  Future<bool> createNotification(MyNotification notification) async {
    try {
      // print(order.billing!.firstName);
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      // var fbody = notification.toJson();
      // print(fbody);
      final body = jsonEncode(notification.toJson());
      // print(body);
      final response = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key =AAAA4wmJZQk:APA91bF0s_ccic5EdZZl_Pd39YOOnHRzYnr5A7IupsPvMNy3ERpAUHTRPZfHjeQjkmFZqfHomXEbUiIto9ItvQ2Yc_VMtUjyFk98xv6X8htx3fUQCOyY4vquerz9FS75391KIehSBHOn"
      });

      if (response.statusCode == 201) {
        print('done');
        return true;
      }
      print(response.body);
    } catch (e) {
      print(e);
    }
    return false;
  }
}

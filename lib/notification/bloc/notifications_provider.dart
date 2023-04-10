import 'package:cui_messenger/notification/model/notification.dart';
import 'package:flutter/cupertino.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:safepall/screens/authentication/model/user.dart' as user_model;
// import 'package:sendbird_sdk/sendbird_sdk.dart';

class NotificationProvider {
  // final sendBird = SendbirdSdk(appId: "5063F43D-4021-44AC-9331-DADE6A5A2130");
  // User? user;
  // GroupChannel? currentChannel;
  List<NotificationModel> notifications = [];

  // List<BaseMessage> messages = List.empty(growable: true);

  Future<void> loadEmeNotifications(String userId) async {
    // debugPrint("USer id in loadEMenitifu: $userId");
    // await connectSendBird(userId);
  }

  // Future<void> connectSendBird(String userid) async {
  //   try {
  //     user = await sendBird.connect(userid);
  //     // debugPrint("connect user: ${user!.toJson()}");
  //     if (user!.profileUrl!.isEmpty) {
  //       // debugPrint("Inside update user!");
  //       user_model.User? userData = await Api.instance.getUserWithUID(userid);
  //       // debugPrint("After update");
  //       if (userData != null) {
  //         await sendBird
  //             .updateCurrentUserInfo(
  //                 nickname: "${userData.firstName} ${userData.lastName}",
  //                 fileInfo: FileInfo.fromUrl(url: userData.imageKey))
  //             .then((value) => debugPrint("User data updated"));
  //       }
  //     }

  //     debugPrint("User - Connected to Send Bird!");
  //   } catch (error) {
  //     debugPrint("Failed to connect with Send Bird api\n$error");
  //   }
  // }

  // Future<void> loadUserNotifications() async {
  //   try {
  //     MessageListParams messageListParams = MessageListParams()..reverse = true;
  //     messages = await currentChannel!.getMessagesByTimestamp(
  //         DateTime.now().millisecondsSinceEpoch * 1000, messageListParams);
  //   } catch (error) {
  //     debugPrint("Error loading messages!\n$error");
  //   }
  // }

  Future<void> getNotificatoinsList(String email) async {
    // try {
    //   var response = await Api.instance.getNotifications(email);
    //   notifications = response;
    //   notifications.sort((a, b) {
    //     return b.createdAt.compareTo(a.createdAt);
    //   });

    //   debugPrint("Get EmeMessages");
    // } catch (error) {
    //   debugPrint(
    //       "Error occured in loading notifications from database. Error: \n $error");
    // }
  }

  // Future<void> sendMessage(
  //     {required String message,
  //     String? customType,
  //     required BuildContext context}) async {
  //   try {
  //     final params = UserMessageParams(
  //       message: message,
  //       customType: customType,
  //     );

  //     final preMessage = currentChannel!.sendUserMessage(params,
  //         onCompleted: (message, error) {
  //       if (error != null) {
  //         debugPrint("Send Message error");
  //         showSimpleNotification(
  //           Text("Error occurred while sending emergency message!"),
  //           background: Palette.red.withOpacity(0.9),
  //           duration: const Duration(seconds: 2),
  //         );
  //       } else {
  //         showSimpleNotification(
  //           const Text("Message Sent!"),
  //           background: Palette.green.withOpacity(0.9),
  //           duration: const Duration(seconds: 2),
  //         );
  //         debugPrint("message sent success!");
  //       }
  //     });
  //   } catch (error) {
  //     debugPrint("Error in sending message!\n$error");
  //   }
  // }

  // Future<GroupChannel> createChannel(List<String> userIds) async {
  //   try {
  //     user_model.User? response =
  //         await Api.instance.getUserWithUID(userIds.last);
  //     var channel;
  //     if (response != null) {
  //       final params = GroupChannelParams()
  //         ..userIds = userIds
  //         ..isDistinct = true
  //         ..name = "${response.firstName} ${response.lastName}"
  //         ..coverImage = FileInfo.fromUrl(url: response.profilePicture)
  //         ..operatorUserIds = userIds;
  //       channel = await GroupChannel.createChannel(params);
  //       return channel;
  //     }
  //     debugPrint("Returning empty!");
  //     return channel;
  //   } catch (error) {
  //     debugPrint('createChannel: ERROR: $error');
  //     rethrow;
  //   }
  // }

  // Future<void> openChannel(GroupChannel channel) async {
  //   try {
  //     currentChannel = channel;
  //     // loadUserMessages();
  //     // The current user successfully enters the open channel.
  //   } catch (error) {
  //     // Handle error.
  //     debugPrint("Error in open channel\n$error");
  //   }
  // }

  // Future<List<GroupChannel>> getChannels() async {
  //   try {
  //     final query = GroupChannelListQuery()
  //       ..userIdsIncludeIn = [user!.userId]
  //       ..includeEmptyChannel = true
  //       ..order = GroupChannelListOrder.latestLastMessage
  //       ..limit = 15;
  //     return await query.loadNext();
  //   } catch (error) {
  //     debugPrint('getGroupChannels: ERROR: $error');
  //     return [];
  //   }
  // }
}

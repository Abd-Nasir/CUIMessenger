// import 'dart:developer';
// import 'dart:io';
import 'dart:math' as math;

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/message_reply.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/chat/methods/firestore_methods.dart';
import 'package:cui_messenger/chat/models/chat_model.dart';
import 'package:cui_messenger/chat/models/group.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/chat/screens/bottom_pages.dart/contacts_screen.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_screen.dart';
import 'package:cui_messenger/chat/utils/helper_widgets.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//value to store if its replying or not
MessageReply? messageReply;
//getting a random number
math.Random random = math.Random();

getAvatarWithStatus(bool isGroupChat, ChatContactModel contactModel,
    {double size = 20}) {
  return Stack(
    children: [
      isGroupChat
          ? contactModel.profilePicture != ""
              ? CircleAvatar(
                  radius: size,
                  backgroundImage: CachedNetworkImageProvider(
                    contactModel.profilePicture,
                    // maxWidth: 50,
                    // maxHeight: 50,
                  ))
              : CircleAvatar(
                  backgroundColor: Palette.hintGrey,
                  radius: size,
                  child: const Icon(
                    Icons.groups_2,
                    color: Palette.white,
                  ))
          : showUsersImage(contactModel.profilePicture == "",
              picUrl: contactModel.profilePicture, size: size),
      if (!isGroupChat)
        StreamBuilder<bool>(
            stream: ChatMethods().getOnlineStream(contactModel.contactId),
            builder: (context, snapshot) {
              return Positioned(
                  bottom: 1,
                  right: 1,
                  child: Icon(
                    Icons.circle_rounded,
                    size: size >= 25 ? 25 : 14,
                    color: snapshot.data != null
                        ? snapshot.data!
                            ? Colors.green
                            : Colors.grey
                        : Colors.grey,
                  ));
            }),
    ],
  );
}

Widget showDateWithLines(dateInList) {
  var tempDate = DateFormat.MMMMEEEEd().format(DateTime.now());
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(dateInList == tempDate ? "Today" : dateInList,
        style: const TextStyle(color: Colors.grey)),
  ]);
}

showFloatingFlushBar(
    BuildContext context, String upMessage, String downMessage) {
  Flushbar(
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 1),
    backgroundGradient: LinearGradient(
      colors: [Palette.cuiPurple, Palette.cuiPurple.withOpacity(0.25)],
      stops: const [0.6, 1],
    ),
    boxShadows: const [
      BoxShadow(
        color: Colors.white,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    titleColor: Colors.white,
    messageColor: Colors.white,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: upMessage,
    message: downMessage,
  ).show(context);
}

showToastMessage(String toastText) {
  Fluttertoast.showToast(
      msg: toastText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Palette.cuiPurple,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget getMessageCard(var model, context, {bool isGroupChat = false}) {
  // Group model = models;
  bool seen = false;
  if (isGroupChat) {
    if (model.isSeen.contains(firebaseAuth.currentUser!.uid)) {
      seen = true;
    } else {
      seen = false;
    }
  } else {
    seen = model.isSeen;
  }
  return Container(
    margin: EdgeInsets.symmetric(
        vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.05),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    height: 70,
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
          blurRadius: 5,
          spreadRadius: 2,
          offset: const Offset(2, 2),
          color: Palette.cuiPurple.withOpacity(0.2))
    ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreen(
                  contactModel: ChatContactModel(
                    contactId: isGroupChat ? model.groupId : model.contactId,
                    name: model.name,
                    profilePicture:
                        isGroupChat ? model.groupPic : model.profilePicture,
                    timeSent: DateTime.now(),
                    lastMessageBy: "",
                    lastMessageId: '',
                    isSeen: false,
                    lastMessage: "",
                  ),
                  people: isGroupChat ? model.membersUid : [],
                  isGroupChat: isGroupChat,
                )));
      },
      leading: Stack(
        children: [
          isGroupChat
              ? model.groupPic != ""
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                        model.groupPic,
                        // maxWidth: 50,
                        // maxHeight: 50,
                      ))
                  : const CircleAvatar(
                      radius: 20, child: Icon(Icons.groups_outlined))
              : showUsersImage(model.profilePicture == "",
                  size: 20,
                  picUrl: model.profilePicture != ""
                      ? model.profilePicture
                      : 'assets/user.png'),
          if (!isGroupChat)
            StreamBuilder<bool>(
                stream: ChatMethods().getOnlineStream(model.contactId),
                builder: (context, snapshot) {
                  return Positioned(
                      bottom: 1,
                      right: 1,
                      child: Icon(
                        Icons.circle_rounded,
                        size: 14,
                        color: snapshot.data != null
                            ? snapshot.data!
                                ? Colors.green
                                : Colors.grey
                            : Colors.grey,
                      ));
                }),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model.name,
            // "model."
            // "name",
            style: TextStyle(
                fontSize: 15,
                //  bodyTextOverflow: TextOverflow.ellipsis,
                fontWeight: model.lastMessageBy != firebaseAuth.currentUser!.uid
                    ? !seen
                        ? FontWeight.bold
                        : FontWeight.normal
                    : FontWeight.normal),
          ),
          Text(
            DateFormat.jm().format(model.timeSent),
            style: TextStyle(
                fontSize: 12,
                fontWeight: model.lastMessageBy != firebaseAuth.currentUser!.uid
                    ? !seen
                        ? FontWeight.bold
                        : FontWeight.normal
                    : FontWeight.normal),
          ),
        ],
      ),
      subtitle: SizedBox(
        height: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  model.lastMessage,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          model.lastMessageBy != firebaseAuth.currentUser!.uid
                              ? !seen
                                  ? FontWeight.bold
                                  : FontWeight.normal
                              : FontWeight.normal),
                ),
              ),
            ),
            // if (!isGroupChat)
            Icon(
              Icons.circle,
              color: model.lastMessageBy != firebaseAuth.currentUser!.uid
                  ? !seen
                      ? Palette.cuiPurple
                      : Colors.transparent
                  : Colors.transparent,
              size: 14,
            )
          ],
        ),
      ),
    ),
  );
}

getIcon(icon) {
  return Icon(
    icon,
    color: Colors.black,
  );
}

void showNewMessage(BuildContext context) async {
  var size = MediaQuery.of(context).size;
  return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: ((context) => SimpleDialog(
              title: Row(
                children: [
                  const Expanded(
                      child: Center(child: Text("Create New Message"))),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              contentPadding: const EdgeInsets.all(8),
              children: [
                SizedBox(
                  height: size.height / 2,
                  width: size.width,
                  child: Scaffold(
                    body: ContactsScreen(
                      isChat: true,
                    ),
                  ),
                ),
              ])));
}

fetchUserInfo() async {
  {
    await firebaseFirestore
        .collection("registered-users")
        .doc(firebaseAuth.currentUser?.uid)
        .get()
        .then((value) {
      userInfo = UserModel.getValuesFromSnap(value);
    });
  }
}

showPeopleForTask(BuildContext context, List usersList, VoidCallback refresh,
    {bool isForGroup = false, required String? groupId}) async {
  var size = MediaQuery.of(context).size;
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => SimpleDialog(
              title: Row(
                children: [
                  const Expanded(child: Center(child: Text("Add People"))),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        refresh();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              contentPadding: const EdgeInsets.all(8),
              children: [
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: size.height / 2,
                    width: size.width,
                    child: Scaffold(
                        body: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: FutureBuilder<List<UserModel>>(
                          future: isForGroup
                              ? ChatMethods().getMembersOfGroup(groupId!)
                              : ChatMethods().getContacts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data == null) {
                              return const Center(
                                child: Text("Nothing to show you"),
                              );
                            }
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        var data = snapshot.data![index];
                                        return isForGroup
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                              contactModel: ChatContactModel(
                                                                  contactId:
                                                                      data.uid,
                                                                  name: data
                                                                      .firstName,
                                                                  profilePicture: data
                                                                      .profilePicture,
                                                                  timeSent:
                                                                      DateTime
                                                                          .now(),
                                                                  lastMessageBy:
                                                                      "",
                                                                  lastMessageId:
                                                                      "",
                                                                  isSeen: false,
                                                                  lastMessage:
                                                                      ""),
                                                            )),
                                                  );
                                                },
                                                child: getForwardCard(
                                                    data, context))
                                            : InkWell(
                                                onTap: () {
                                                  final groupRef =
                                                      FirebaseFirestore.instance
                                                          .collection("groups")
                                                          .doc(groupId);
                                                  setState(() {
                                                    // if (usersList
                                                    //     .contains(data.uid)) {
                                                    groupRef
                                                        .get()
                                                        .then((value) {
                                                      print(value.data());
                                                      Group group =
                                                          Group.fromMap(
                                                              value.data()!);
                                                      print(group.membersUid);
                                                      if (group.membersUid
                                                          .contains(data.uid)) {
                                                        group.membersUid
                                                            .remove(data.uid);
                                                        print(group.membersUid);
                                                        groupRef.update(
                                                            group.toMap());
                                                        usersList
                                                            .remove(data.uid);
                                                      } else {
                                                        group.membersUid
                                                            .add(data.uid);
                                                        print(group.membersUid);
                                                        groupRef.update(
                                                            group.toMap());
                                                        usersList.add(data.uid);
                                                      }
                                                    });
                                                  });
                                                },
                                                child: getPeopleCard(
                                                    data,
                                                    context,
                                                    usersList
                                                        .contains(data.uid)));
                                      })),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: ElevatedButton(
                                //       onPressed: () {
                                //         // showPeopleForTask(context, people);
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: Palette.cuiPurple,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(8),
                                //         ),
                                //         padding: const EdgeInsetsDirectional
                                //             .fromSTEB(0, 0, 0, 0),
                                //         minimumSize: Size(size.width / 2, 54),
                                //       ),
                                //       child: const Text(
                                //         'Add People',
                                //         textAlign: TextAlign.left,
                                //         style: TextStyle(
                                //             color: Color.fromRGBO(
                                //                 255, 255, 255, 1),
                                //             fontFamily: 'Poppins',
                                //             fontSize: 15,
                                //             letterSpacing:
                                //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                //             fontWeight: FontWeight.normal,
                                //             height: 1),
                                //       )),
                                // ),
                              ],
                            );
                          }),
                    )),
                  );
                }),
              ])));
}

getContactCard(UserModel model, context, bool isChat,
    {bool shouldShow = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    child: InkWell(
      onTap: () {
        if (shouldShow) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(
                    contactModel: ChatContactModel(
                        contactId: model.uid,
                        name: model.firstName,
                        profilePicture: model.profilePicture,
                        timeSent: DateTime.now(),
                        lastMessageBy: "",
                        lastMessageId: "",
                        isSeen: false,
                        lastMessage: ""),
                  )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                  radius: 25,
                  backgroundImage: (model.profilePicture == ""
                      ? const AssetImage(
                          'assets/user.png',
                        )
                      : CachedNetworkImageProvider(
                          model.profilePicture,
                          // maxWidth: 50,
                          // maxHeight: 50,
                          // fit: BoxFit.fitHeight,
                        )) as ImageProvider),
              StreamBuilder<bool>(
                  stream: ChatMethods().getOnlineStream(model.uid),
                  builder: (context, snapshot) {
                    return Positioned(
                        bottom: 1,
                        right: 1,
                        child: Icon(
                          Icons.circle_rounded,
                          size: 14,
                          color: snapshot.data != null
                              ? snapshot.data!
                                  ? Colors.green
                                  : Colors.grey
                              : Colors.grey,
                        ));
                  }),
            ],
          ),
          title: Text(
            model.firstName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: shouldShow
              ? Container(
                  decoration: BoxDecoration(
                      color: Palette.cuiPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50)),
                  width: 45,
                  height: 45,
                  child: Icon(
                    isChat ? Icons.message_rounded : Icons.call,
                    color: Palette.cuiPurple,
                  ),
                )
              : const Text(""),
        ),
      ),
    ),
  );
}

Widget getForwardCard(UserModel model, context) {
  return Container(
    margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.02),
    // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
          color: Palette.cuiPurple.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(2, 2)),
    ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: (model.profilePicture == ""
                    ? const AssetImage(
                        'assets/user.png',
                      )
                    : CachedNetworkImageProvider(
                        model.profilePicture,

                        // maxWidth: 50,
                        // maxHeight: 50,
                        // fit: BoxFit.fitHeight,
                      )) as ImageProvider),
            StreamBuilder<bool>(
                stream: ChatMethods().getOnlineStream(model.uid),
                builder: (context, snapshot) {
                  return Positioned(
                      bottom: 1,
                      right: 1,
                      child: Icon(
                        Icons.circle_rounded,
                        size: 14,
                        color: snapshot.data != null
                            ? snapshot.data!
                                ? Colors.green
                                : Colors.grey
                            : Colors.grey,
                      ));
                }),
          ],
        ),
        title: Text(
          model.firstName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Palette.cuiPurple,
          size: 20,
        )),
  );
}

getPeopleCard(UserModel model, context, bool isSelected) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                  radius: 25,
                  backgroundImage: (model.profilePicture == ""
                      ? const AssetImage(
                          'assets/user.png',
                        )
                      : CachedNetworkImageProvider(
                          model.profilePicture,
                          // maxWidth: 50,
                          // maxHeight: 50,
                          // fit: BoxFit.fitHeight,
                        )) as ImageProvider),
            ],
          ),
          title: Text(
            model.firstName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // subtitle: Row(
          //   children: [
          //     Text(
          //       model.location,
          //       style:
          //           const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //     ),
          // ],
          // ),
          trailing: Container(
            decoration: BoxDecoration(
                color: Palette.cuiPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50)),
            width: 45,
            height: 45,
            child: Icon(
              isSelected ? Icons.circle : Icons.circle,
              color: isSelected ? Palette.cuiPurple : Colors.grey,
            ),
          )),
    ),
  );
}

// getTaskCard(TaskModel model, context, VoidCallback callback,
//     {ValueSetter<List>? refresh, List? tasksList}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//     child: StatefulBuilder(builder: (context, setState) {
//       return Container(
//         decoration: BoxDecoration(
//             color: scaffoldBackgroundColor,
//             borderRadius: BorderRadius.circular(15)),
//         child: ListTile(
//           leading: InkWell(
//             onTap: () {
//               setState(() {
//                 //if the task is set as completed
//                 if (model.isCompleted) {
//                   setState(() {
//                     model.isCompleted = false;
//                     model.completedAt = null;
//                   });
//                 } else {
//                   setState(() {
//                     model.isCompleted = true;
//                     model.completedAt = DateTime.now();
//                   });
//                 }
//               });
//               refresh!(tasksList!);
//             },
//             child: Container(
//                 decoration: BoxDecoration(
//                     // color: Palette.cuiPurple.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10)),
//                 width: 45,
//                 height: 45,
//                 child: Icon(
//                   FontAwesomeIcons.circleCheck,
//                   color: model.isCompleted ? Palette.cuiPurple : Colors.grey,
//                 )),
//             // child: Container(
//             //     decoration: BoxDecoration(
//             //         color: Palette.cuiPurple.withOpacity(0.1),
//             //         borderRadius: BorderRadius.circular(50)),
//             //     width: 45,
//             //     height: 45,
//             //     child: Icon(
//             //       Icons.circle,
//             //       color: model.isCompleted ? Palette.cuiPurple : Colors.grey,
//             //     )),
//           ),
//           title: Text(
//             model.taskTitle,
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: !model.isCompleted ? Colors.black : Colors.grey,
//                 decoration: model.isCompleted
//                     ? TextDecoration.lineThrough
//                     : TextDecoration.none),
//           ),
//           subtitle: model.completedAt != null
//               ? Row(
//                   children: [
//                     Text(
//                       timeago.format(model.completedAt!, locale: "en_short"),
//                       style: const TextStyle(
//                           fontSize: 12, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )
//               : null,
//           trailing: InkWell(
//             onTap: () {
//               _showDeleteDialog(context, callback);
//               setState(() {});
//             },
//             child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(50)),
//                 width: 45,
//                 height: 45,
//                 child: const Icon(
//                   Icons.delete_forever,
//                   color: Colors.red,
//                 )),
//           ),
//         ),
//       );
//     }),
//   );
// }

// _showDeleteDialog(context, VoidCallback callback) {
//   showDialog(
//       context: context,
//       builder: (ctxt) => AlertDialog(
//             title: const Text("Alert"),
//             content: const Text("Are you sure you want to delete this task?"),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Cancel")),
//               ElevatedButton(
//                   onPressed: () {
//                     callback();

//                     Navigator.pop(context);
//                   },
//                   child: const Text("Continue")),
//             ],
//           ));
// }

//returs a widget that acts as a prompt
getNewChatPrompt(context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Palette.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Palette.cuiPurple.withOpacity(0.25),
              blurRadius: 3.0,
              spreadRadius: 2,
              offset: const Offset(0.0, 2.0),
            ),
          ]),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "You dont have any chats\nstart a chat",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.cuiPurple,
              ),
              onPressed: () {
                showNewMessage(context);
              },
              child: const Text('Start a chat')),
        ],
      ),
    ),
  );
}

Future<String> getImage(String id, bool isGroup) async {
  if (isGroup) {
    return await firebaseFirestore
        .collection('groups')
        .doc(id)
        .get()
        .then((value) {
      Group val = Group.fromMap(value.data()!);

      return val.groupPic;
    });
  } else {
    return await firebaseFirestore
        .collection('registered-users')
        .doc(id)
        .get()
        .then((value) {
      UserModel val = UserModel.getValuesFromSnap(value);

      return val.profilePicture;
    });
  }
}

Widget returnNothingToShow() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(
        Icons.sentiment_neutral_rounded,
        size: 50,
      ),
      Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Text("Nothing to Show"),
      )
    ],
  ));
}

Future<List<String>> fetchImageUrlsFromUid(List peopleUid) async {
  List<String> peopleImages = [];
  for (var element in peopleUid) {
    UserModel temp = await FirestoreMethods().getUserInformationOther(element);
    peopleImages.add(temp.profilePicture);
  }
  return peopleImages;
}

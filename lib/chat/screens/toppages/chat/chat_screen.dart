import 'dart:developer';
import 'dart:io';

import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/message_enum.dart';
import 'package:cui_messenger/chat/constants/utils.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/chat/models/chat_model.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_profile/chat_profile_group.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_profile/chat_profile_screen.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/forward_message_screen.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/image_preview_sending.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/message_reply_preview.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/my_message_card.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/sender_message_card.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';

class ChatScreen extends StatefulWidget {
  final ChatContactModel contactModel;
  final List<Message>? message;
  final bool? isGroupChat;
  final List? people;
  const ChatScreen(
      {super.key,
      this.people,
      this.message,
      this.isGroupChat,
      required this.contactModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool isGroupChat = false;
  UserModel? usermodel;
  List tokensList = [];
  var user;
  //for controlling the keyboard
  FocusNode focusNode = FocusNode();

  getTokensList() async {
    for (var element in widget.people!) {
      if (element != firebaseAuth.currentUser!.uid) {
        await getNotificationToken(element);
      }
    }
  }

  getNotificationToken(String uid) async {
    UserModel model = UserModel.getValuesFromSnap(
        await firebaseFirestore.collection('registered-users').doc(uid).get());
    tokensList.add(model.token);
  }

  getdata() async {
    if (!isGroupChat) {
      var doc = await firebaseFirestore
          .collection('registered-users')
          .doc(widget.contactModel.contactId)
          .get();
      user = doc.data() as Map<dynamic, dynamic>;
      // CALLERDATA = user;
      usermodel = UserModel.getValuesFromSnap(doc);
      if (mounted) setState(() {});
    } else {
      // Map<dynamic, dynamic> values = {
      //   'name': widget.contactModel.name,
      //   'profile-picture': widget.contactModel.profilePicture,
      // };
      // CALLERDATA = values;
    }
  }

  bool isBlocked = false;
  int pageIndex = 0;
  bool showOptions = false;
  int selectedNum = 1;
  int messagesLenth = 10;
  double? offSetValue;
  final ScrollController messageController =
      ScrollController(keepScrollOffset: true);
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void startGetBlockStatus() {
    ChatMethods().getBlockStatus().listen((event) {
      isBlocked = event.blockList.contains(widget.contactModel.contactId);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //checking if the chat is a group chat
    if (widget.isGroupChat != null) {
      isGroupChat = widget.isGroupChat!;
    }
    //getting the list of tokens of all the people in the group
    if (isGroupChat) {
      getTokensList();
    }
//getting the data of the user
    getdata();
    // if (!isGroupChat) {
    //   //setting the typing to false just in case it was left on true
    //   ChatMethods().stopTyping(widget.contactModel.contactId);
    // }

    // ChatMethods()
    //     .setChatContactMessageSeen(widget.contactModel.contactId, isGroupChat);

    if (widget.message != null) {
      sendForwardedMessageToUser();
    }
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   try {
    //     if (mounted) {
    //       messageController.jumpTo(messageController.position.maxScrollExtent);
    //     }
    //   } catch (e) {}
    // });
    startGetBlockStatus();
  }

  void sendForwardedMessageToUser() {
    //iterating over all the messages in the list
    //and sending the messages to the user
    for (var element in widget.message!) {
      if (element.type == MessageEnum.link ||
          element.type == MessageEnum.text) {
        //forwarding the text message
        ChatMethods().sendTextMessage(
            context: context,
            text: element.text,
            recieverUserId: widget.contactModel.contactId,
            senderUser: userInfo!,
            messageReply: null,
            isGroupChat: isGroupChat);
      } else {
        ChatMethods().sendForwardedFileMessage(
            context: context,
            fileUrl: element.text,
            recieverUserId: widget.contactModel.contactId,
            senderUserData: userInfo!,
            messageEnum: element.type,
            messageReply: null,
            isGroupChat: isGroupChat);
      }
    }
  }

  void incrementSelectedNum() {
    setState(() {
      ++selectedNum;
    });
  }

  void decrementSelectedNum() {
    setState(() {
      --selectedNum;
      if (selectedNum == 0) {
        setStateToNormal();
      }
    });
  }

  void changeShowOptions() async {
    showMaterialModalBottomSheet(
      expand: false,

      context: context,
      backgroundColor: Colors.transparent,
      // isDismissible: false,
      elevation: 4,
      enableDrag: false,
      builder: (context) => showBottomSheet(),
      // builder: (context) => MessageHoldSheet(
      //   taskTitleTemp: taskTitleTemp,
      //   setStateToNormal: setStateToNormal,
      //   deleteMessage: deleteMessage,
      //   copyTextToClipboard: copyTextToClipboard,
      //   forwardMessage: forwardMessage,
      //   getBoolCreateCheck: _getBoolCreateCheck,
      //   getBoolCopyCheck: _getBoolCopyCheck,
      // ),
    ).whenComplete(() {
      offSetValue = messageController.offset;

      if (isDismissed) {
        setStateToNormal();
      }
    });
  }

  void setStateToNormal() {
    setState(() {
      showOptions = false;
      selectedNum = 1;
      messageId = [];
      tempMessage = [];
      taskTitleTemp = "";
    });
  }

  bool isTyping = false;
  List<String> messageId = [];
  List<Message> tempMessage = [];
  final listViewKey = GlobalKey();
  String taskTitleTemp = "";
  bool isDateShown = false;
  String previousTime = "";
  bool isDismissed = true;
  int messagesListLength = 0;

  bool _getBoolCreateCheck() {
    if (selectedNum == 1) {
      try {
        for (var element in tempMessage) {
          if (element.messageId == messageId[0]) {
            if (element.type == MessageEnum.text) {
              taskTitleTemp = element.text;
              log(element.text + " jdfjasf");
              return true;
            }
          }
        }
      } catch (e) {
        return false;
      }
      return false;
    } else {
      taskTitleTemp = "";
      return false;
    }
  }

  bool _getBoolCopyCheck() {
    try {
      for (var element in tempMessage) {
        if (element.messageId == messageId[0]) {
          if (element.type == MessageEnum.text) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void copyTextToClipboard() {
    offSetValue = messageController.offset;
    String text = '';
    for (var i = 0; i < tempMessage.length; i++) {
      for (var element in messageId) {
        if (tempMessage[i].messageId == element) {
          if (text != '') {
            text = "$text\n${tempMessage[i].text}";
          } else {
            text = tempMessage[i].text;
          }
        }
      }
    }
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showToastMessage("Text Copied");
    });
    setStateToNormal();
  }

  forwardMessage() {
    List<Message> messages = [];
    for (var i = 0; i < tempMessage.length; i++) {
      for (var element in messageId) {
        if (tempMessage[i].messageId == element) {
          messages.add(tempMessage[i]);
        }
      }
    }
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ForwardMessageScreen(messageList: messages)))
        .whenComplete(() {
      setStateToNormal();
    });
  }

  Widget showBottomSheet() {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ListTile(
          //   title: const Text('Edit'),
          //   leading: const Icon(Icons.edit),
          //   onTap: () => Navigator.of(context).pop(),
          // ),

          if (_getBoolCopyCheck())
            ListTile(
              title: const Text('Copy Text'),
              leading: const Icon(Icons.content_copy),
              onTap: () {
                Navigator.of(context).pop();
                copyTextToClipboard();
                isDismissed = false;
              },
            ),
          ListTile(
            title: const Text('Forward'),
            leading: const Icon(FontAwesomeIcons.arrowUpFromBracket),
            onTap: () {
              Navigator.of(context).pop();
              forwardMessage();
              isDismissed = false;
            },
          ),
          ListTile(
            title: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            leading: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () async {
              Navigator.of(context).pop();
              deleteMessage();
              isDismissed = false;
            },
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //Setting the values in the Menu Items class

    MenuItems.makeMenuItem(isGroupChat, isBlocked);
    return WithForegroundTask(
      child: GestureDetector(
        onTap: () {
          try {
            focusNode.unfocus();
          } catch (e) {}
          log("Unfocusing");
        },
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                  backgroundColor: Palette.white,
                  appBar: AppBar(
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: 65,
                    title: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              RouteGenerator.navigatorKey.currentState!.pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: Palette.cuiPurple,
                            )),
                        InkWell(
                          onTap: openProfile,
                          child: Row(
                            children: [
                              getAvatarWithStatus(
                                  isGroupChat, widget.contactModel),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.contactModel.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      pageIndex == 0
                          ? Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Stack(
                                    children: [
                                      RefreshIndicator(
                                        onRefresh: () async {
                                          setState(() {
                                            messagesLenth += 5;
                                            offSetValue =
                                                messageController.offset;
                                          });
                                        },
                                        child: SingleChildScrollView(
                                          controller: messageController,
                                          reverse: true,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          child: StreamBuilder<List<Message>>(
                                              stream: isGroupChat
                                                  ? ChatMethods()
                                                      .getGroupChatStream(widget
                                                          .contactModel
                                                          .contactId)
                                                  : ChatMethods().getChatStream(
                                                      messagesLenth,
                                                      widget.contactModel
                                                          .contactId),
                                              builder: (context, snapshot) {
                                                isDateShown = false;
                                                isTyping = false;

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                }
                                                // if (!isLoadPreviousPressed) {
                                                // SchedulerBinding.instance.addPostFrameCallback((_) {
                                                //   widget.messageController.jumpTo(
                                                //       widget.messageController.position.maxScrollExtent);
                                                // });
                                                // } else {
                                                // SchedulerBinding.instance.addPostFrameCallback((_) {
                                                //   widget.messageController
                                                //       .jumpTo(widget.messageController.offset);
                                                // });
                                                // }
                                                if (offSetValue != null) {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    messageController
                                                        .jumpTo(offSetValue!);
                                                    offSetValue = null;
                                                  });
                                                } else {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    messageController
                                                        .jumpTo(0.0);
                                                  });
                                                }

                                                //in case of group chat checking if the message is deleted by the user
                                                List<Message> messagesList = [];
                                                if (isGroupChat) {
                                                  for (var element
                                                      in snapshot.data!) {
                                                    Message message = element;
                                                    if (message
                                                            .isMessageDeleted !=
                                                        null) {
                                                      if (!message
                                                          .isMessageDeleted!
                                                          .contains(firebaseAuth
                                                              .currentUser!
                                                              .uid)) {
                                                        messagesList
                                                            .add(message);
                                                      }
                                                    } else {
                                                      messagesList.add(message);
                                                    }
                                                  }
                                                } else {
                                                  messagesList = snapshot.data!;
                                                }
                                                // if (messagesList.length ==
                                                //     messagesListLength) {
                                                //   showToastMessage(
                                                //       "End of Chat");
                                                // } else {
                                                //   messagesListLength =
                                                //       messagesList.length;
                                                // }
                                                return ListView.builder(
                                                  key: const PageStorageKey(
                                                      'const name here'),
                                                  // controller: widget.messageController,
                                                  itemCount:
                                                      messagesList.length + 1,
                                                  primary: false,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  // physics: AlwaysScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    tempMessage = messagesList;
                                                    var messageData;
                                                    if (index !=
                                                        snapshot.data!.length) {
                                                      messageData =
                                                          messagesList[index];
                                                      if (messageData
                                                              .messageId ==
                                                          messageData
                                                              .recieverid) {
                                                        isTyping = true;
                                                      } else {
                                                        var timeSent = DateFormat
                                                                .jm()
                                                            .format(messageData
                                                                .timeSent);
                                                        if (!messageData
                                                                .isSeen &&
                                                            messageData
                                                                    .recieverid ==
                                                                firebaseAuth
                                                                    .currentUser!
                                                                    .uid) {
                                                          if (!isGroupChat) {
                                                            ChatMethods()
                                                                .setChatMessageSeen(
                                                              widget
                                                                  .contactModel
                                                                  .contactId,
                                                              messageData
                                                                  .messageId,
                                                            );
                                                          }
                                                        }
                                                        if (isGroupChat) {
                                                          ChatMethods()
                                                              .setChatContactMessageSeen(
                                                                  widget
                                                                      .contactModel
                                                                      .contactId,
                                                                  isGroupChat);
                                                        }

                                                        //showing the time
                                                        var dateInList = DateFormat
                                                                .MMMMEEEEd()
                                                            .format(messageData
                                                                .timeSent);
                                                        if (previousTime !=
                                                            dateInList) {
                                                          previousTime =
                                                              dateInList;
                                                          isDateShown = false;
                                                        } else {
                                                          isDateShown = true;
                                                        }
                                                        if (messageData
                                                                .senderId ==
                                                            firebaseAuth
                                                                .currentUser!
                                                                .uid) {
                                                          return Column(
                                                            children: [
                                                              if (!isDateShown)
                                                                showDateWithLines(
                                                                    dateInList),
                                                              InkWell(
                                                                onTap: () {
                                                                  focusNode
                                                                      .unfocus();
                                                                },
                                                                onLongPress:
                                                                    () {
                                                                  changeShowOptions();
                                                                  messageId.add(
                                                                      messageData
                                                                          .messageId);
                                                                },
                                                                child:
                                                                    MyMessageCard(
                                                                  message:
                                                                      messageData
                                                                          .text,
                                                                  date:
                                                                      timeSent,
                                                                  isSeen:
                                                                      messageData
                                                                          .isSeen,
                                                                  type:
                                                                      messageData
                                                                          .type,
                                                                  repliedText:
                                                                      messageData
                                                                          .repliedMessage,
                                                                  username:
                                                                      messageData
                                                                          .repliedTo,
                                                                  repliedMessageType:
                                                                      messageData
                                                                          .repliedMessageType,
                                                                  longPress:
                                                                      changeShowOptions,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                        return Column(
                                                          children: [
                                                            if (!isDateShown)
                                                              showDateWithLines(
                                                                  dateInList),
                                                            InkWell(
                                                              onTap: () {
                                                                focusNode
                                                                    .unfocus();
                                                              },
                                                              onLongPress: () {
                                                                changeShowOptions();
                                                                messageId.add(
                                                                    messageData
                                                                        .messageId);
                                                              },
                                                              child: SenderMessageCard(
                                                                  avatarWidget: getAvatarWithStatus(
                                                                      isGroupChat,
                                                                      widget
                                                                          .contactModel),
                                                                  photoUrl: widget
                                                                      .contactModel
                                                                      .profilePicture,
                                                                  message:
                                                                      messageData
                                                                          .text,
                                                                  date:
                                                                      timeSent,
                                                                  type: messageData
                                                                      .type,
                                                                  username:
                                                                      messageData.senderUsername ??
                                                                          "",
                                                                  repliedMessageType:
                                                                      messageData
                                                                          .repliedMessageType,
                                                                  longPress:
                                                                      changeShowOptions,
                                                                  repliedText:
                                                                      messageData
                                                                          .repliedMessage,
                                                                  isGroupChat:
                                                                      isGroupChat),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    }
                                                    if (index ==
                                                            snapshot
                                                                .data!.length &&
                                                        isTyping) {
                                                      return SenderMessageCard(
                                                          avatarWidget:
                                                              getAvatarWithStatus(
                                                                  isGroupChat,
                                                                  widget
                                                                      .contactModel),
                                                          photoUrl: "",
                                                          message:
                                                              "/////TYPINGZK????",
                                                          date: "null",
                                                          type:
                                                              MessageEnum.text,
                                                          username: "",
                                                          repliedMessageType:
                                                              MessageEnum.text,
                                                          longPress: () {},
                                                          repliedText: '',
                                                          isGroupChat:
                                                              isGroupChat);
                                                    }
                                                    return const SizedBox();
                                                  }),
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  )),
                                  MyTextField(
                                    model: widget.contactModel,
                                    isGroupChat: isGroupChat,
                                    focusNode: focusNode,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      // : isGroupChat
                      //     ? Expanded(
                      //         child: TodoScreen(
                      //         // id: widget.contactModel.contactId,
                      //         isGroupChat: isGroupChat,
                      //         people: widget.people,
                      //       ))
                      //     : Expanded(
                      //         child: TodoScreen(
                      //         id: widget.contactModel.contactId,
                      //       )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _showBlockDialog() {
    if (isGroupChat) {
      showDialog(
          context: context,
          builder: (ctxt) => AlertDialog(
                title: const Text("Alert"),
                content:
                    const Text("Are you sure you want to leave this group?"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.red[100]),
                      onPressed: () {
                        ChatMethods().leaveGroup(widget.contactModel.contactId);
                        Navigator.pop(context);
                      },
                      child: const Text("Leave")),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (ctxt) => AlertDialog(
                title: const Text("Alert"),
                content: Text(isBlocked
                    ? "You are about to unblock ${widget.contactModel.name}"
                    : "Are you sure you want to block this user?"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () {
                        ChatMethods()
                            .blockUnblockUser(widget.contactModel.contactId);
                        Navigator.pop(context);
                      },
                      child: const Text("Continue")),
                ],
              ));
    }
  }

  _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (ctxt) => AlertDialog(
              title: const Text("Alert"),
              content: const Text("Are you sure you want to delete this chat?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      {
                        ChatMethods().deleteContactMessage(
                            widget.contactModel.contactId);
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("Continue")),
              ],
            ));
  }

  void deleteMessage() {
    for (var id in messageId) {
      if (isGroupChat) {
        ChatMethods().deleteMessageInGroup(
            groupId: widget.contactModel.contactId, messageId: id);
      } else {
        ChatMethods().deleteSingleMessage(
            recieverUserId: widget.contactModel.contactId, messageId: id);
      }
    }
    setStateToNormal();
  }

  void openProfile() {
    if (isGroupChat) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatProfileGroup(
                id: widget.contactModel.contactId,
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatProfileScreen(
                chatContactModel: widget.contactModel,
              )));
    }
  }
}

// the stream wiget
class _ChatList extends StatefulWidget {
  final bool isGroupChat;
  bool showOptions;
  final ScrollController messageController;
  final ChatContactModel contactModel;
  List tempMessage;
  List messageId;
  String previousTime;
  bool isDateShown;
  bool isTyping;
  VoidCallback changeShowOptions;
  VoidCallback decrementSelectedNum;
  VoidCallback incrementSelectedNum;

  _ChatList({
    required this.isGroupChat,
    required this.contactModel,
    required this.showOptions,
    required this.messageController,
    required this.tempMessage,
    required this.messageId,
    required this.previousTime,
    required this.isDateShown,
    required this.isTyping,
    required this.changeShowOptions,
    required this.decrementSelectedNum,
    required this.incrementSelectedNum,
  });

  @override
  State<_ChatList> createState() => __ChatListState();
}

class __ChatListState extends State<_ChatList> {
  bool isGroupChat = false;
  bool showOptions = false;
  int messagesLenth = 10;
  bool isLoadPreviousPressed = false;
  ValueNotifier<bool> showLoadingOption = ValueNotifier(false);
  final ScrollController messageController =
      ScrollController(keepScrollOffset: true);
  final GlobalKey scrollKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    isGroupChat = widget.isGroupChat;
    showOptions = widget.showOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Message>>(
            stream: isGroupChat
                ? ChatMethods()
                    .getGroupChatStream(widget.contactModel.contactId)
                : ChatMethods().getChatStream(
                    messagesLenth, widget.contactModel.contactId),
            builder: (context, snapshot) {
              widget.isDateShown = false;
              widget.isTyping = false;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              // if (!isLoadPreviousPressed) {
              // SchedulerBinding.instance.addPostFrameCallback((_) {
              //   widget.messageController.jumpTo(
              //       widget.messageController.position.maxScrollExtent);
              // });
              // } else {
              //   SchedulerBinding.instance.addPostFrameCallback((_) {
              //     widget.messageController
              //         .jumpTo(widget.messageController.offset);
              //   });
              // }

              //in case of group chat checking if the message is deleted by the user
              List<Message> messagesList = [];
              if (isGroupChat) {
                for (var element in snapshot.data!) {
                  Message message = element;
                  if (message.isMessageDeleted != null) {
                    if (!message.isMessageDeleted!
                        .contains(firebaseAuth.currentUser!.uid)) {
                      messagesList.add(message);
                    }
                  } else {
                    messagesList.add(message);
                  }
                }
              } else {
                messagesList = snapshot.data!;
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // final metrices = notification.metrics;

                  // if (metrices.atEdge && metrices.pixels == 0) {
                  //   //you are at top of  list
                  //   showLoadingOption.value = true;
                  // } else {
                  //   showLoadingOption.value = false;
                  // }

                  // if (metrices.pixels == metrices.minScrollExtent) {
                  //   //you are at top of list
                  //   showLoadingOption.value = true;
                  // } else {
                  //   showLoadingOption.value = false;
                  // }

                  // if (metrices.atEdge && metrices.pixels > 0) {
                  //   //you are at end of  list
                  //   showLoadingOption.value = false;
                  // }

                  // if (metrices.pixels >= metrices.maxScrollExtent) {
                  //   //you are at end of list
                  //   showLoadingOption.value = false;
                  // }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: messageController,
                  key: scrollKey,
                  reverse: true,
                  // physics:  NeverScrollableScrollPhysics(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.builder(
                    // controller: widget.messageController,
                    itemCount: messagesList.length + 1,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    // physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      widget.tempMessage = messagesList;
                      var messageData;
                      if (index != snapshot.data!.length) {
                        messageData = messagesList[index];
                        if (messageData.messageId == messageData.recieverid) {
                          widget.isTyping = true;
                        } else {
                          var timeSent =
                              DateFormat.jm().format(messageData.timeSent);
                          if (!messageData.isSeen &&
                              messageData.recieverid ==
                                  firebaseAuth.currentUser!.uid) {
                            if (!isGroupChat) {
                              ChatMethods().setChatMessageSeen(
                                widget.contactModel.contactId,
                                messageData.messageId,
                              );
                            }
                          }
                          if (isGroupChat) {
                            ChatMethods().setChatContactMessageSeen(
                                widget.contactModel.contactId, isGroupChat);
                          }

                          //showing the time
                          var dateInList = DateFormat.MMMMEEEEd()
                              .format(messageData.timeSent);
                          if (widget.previousTime != dateInList) {
                            widget.previousTime = dateInList;
                            widget.isDateShown = false;
                          } else {
                            widget.isDateShown = true;
                          }
                          if (messageData.senderId ==
                              firebaseAuth.currentUser!.uid) {
                            return Column(
                              children: [
                                if (!widget.isDateShown)
                                  showDateWithLines(dateInList),
                                InkWell(
                                  onLongPress: () {
                                    widget.changeShowOptions();
                                    widget.messageId.add(messageData.messageId);
                                  },
                                  child: MyMessageCard(
                                    message: messageData.text,
                                    date: timeSent,
                                    isSeen: messageData.isSeen,
                                    type: messageData.type,
                                    repliedText: messageData.repliedMessage,
                                    username: messageData.repliedTo,
                                    repliedMessageType:
                                        messageData.repliedMessageType,
                                    longPress: widget.changeShowOptions,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              if (!widget.isDateShown)
                                showDateWithLines(dateInList),
                              InkWell(
                                // onTap: () {
                                //   print(
                                //       "This is photourl ${widget.contactModel.photoUrl}");
                                // },
                                onLongPress: () {
                                  // print("Hey there");
                                  widget.changeShowOptions();
                                  widget.messageId.add(messageData.messageId);
                                },
                                child: SenderMessageCard(
                                    avatarWidget: getAvatarWithStatus(
                                        widget.isGroupChat,
                                        widget.contactModel),
                                    photoUrl:
                                        widget.contactModel.profilePicture,
                                    message: messageData.text,
                                    date: timeSent,
                                    type: messageData.type,
                                    username: messageData.senderUsername ?? "",
                                    repliedMessageType:
                                        messageData.repliedMessageType,
                                    longPress: widget.changeShowOptions,
                                    repliedText: messageData.repliedMessage,
                                    isGroupChat: isGroupChat),
                              ),
                            ],
                          );
                        }
                      }
                      if (index == snapshot.data!.length && widget.isTyping) {
                        return SenderMessageCard(
                            avatarWidget: getAvatarWithStatus(
                                widget.isGroupChat, widget.contactModel),
                            photoUrl: "",
                            message: "/////TYPINGZK????",
                            date: "null",
                            type: MessageEnum.text,
                            username: "",
                            repliedMessageType: MessageEnum.text,
                            longPress: () {},
                            repliedText: '',
                            isGroupChat: isGroupChat);
                      }
                      return const SizedBox();
                    }),
                  ),
                ),
              );
            }),
        // ValueListenableBuilder(
        //     valueListenable: showLoadingOption,
        //     builder: (context, value, widget) {
        //       if (value) {
        //         return Align(
        //           alignment: Alignment.topCenter,
        //           child: ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //                 elevation: 5,
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(25))),
        //             child: const Text("Swipe Down To Load Previous Messages"),
        //             onPressed: () {},
        //           ),
        //         );
        //         // return Align(
        //         //   alignment: Alignment.topCenter,
        //         //   child: ElevatedButton(
        //         //     style: ElevatedButton.styleFrom(
        //         //         elevation: 5,
        //         //         shape: RoundedRectangleBorder(
        //         //             borderRadius: BorderRadius.circular(25))),
        //         //     child: const Text("Swipe Down To "),
        //         //     onPressed: () {},
        //         //   ),
        //         // );
        //       }
        //       return Container();
        //     }),
      ],
    );
  }
}

//The text field
class MyTextField extends StatefulWidget {
  final ChatContactModel model;
  final bool isGroupChat;
  final FocusNode focusNode;
  const MyTextField(
      {required this.model,
      required this.focusNode,
      required this.isGroupChat,
      super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isShowSendButton = false;
  int pageIndex = 0;
  bool isShowEmojiContainer = false;
  RecorderController? _controller;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isRecordingPressed = false;
  late FocusNode focusNode;
  final TextEditingController _messageController = TextEditingController();
  bool isBlocked = false;
  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode;
    if (!widget.isGroupChat) {
      getBlock();
    }
    _controller = RecorderController();
    _controller!.updateFrequency =
        const Duration(milliseconds: 100); // Update speed of new wave
    _controller!.androidEncoder =
        AndroidEncoder.aac; // Changing android encoder
    _controller!.androidOutputFormat =
        AndroidOutputFormat.mpeg4; // Changing android output format
    _controller!.iosEncoder =
        IosEncoder.kAudioFormatMPEG4AAC; // Changing ios encoder
    _controller!.sampleRate = 44100; // Updating sample rate
    _controller!.bitRate = 48000; // Updating bitrate
    // _controller!.currentScrolledDuration; // Current duration position notifier
    openAudio();
  }

  getBlock() async {
    isBlocked = await ChatMethods().checkMessageAllowed(widget.model.contactId);
    if (mounted) {
      setState(() {});
    }
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // throw RecordingPermissionException('Mic permission not allowed!');
    }
    // await _controller!.openRecorder();
    // isRecorderInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _controller!.dispose();
    isRecorderInit = false;
    ChatMethods().stopTyping(widget.model.contactId);
  }

  // void sendTextMessage() async {
  //   if (isShowSendButton) {
  //     if (_messageController.text.isNotEmpty) {
  //       ChatMethods().sendTextMessage(
  //           context: context,
  //           text: _messageController.text.trim(),
  //           recieverUserId: widget.model.contactId,
  //           senderUser: userInfo,
  //           messageReply: null,
  //           isGroupChat: widget.isGroupChat);
  //       setState(() {
  //         _messageController.text = '';
  //         if (!widget.isGroupChat) {
  //           ChatMethods().stopTyping(widget.model.contactId);
  //         }
  //       });
  //       if (!isShowSendButton) {
  //         // ChatMethods()
  //         //     .updateTyping(widget.model.contactId, true);
  //         setState(() {
  //           isShowSendButton = true;
  //         });
  //       } else {
  //         // ChatMethods().updateTyping(widget.model.contactId, false);
  //         setState(() {
  //           isShowSendButton = false;
  //         });
  //       }
  //     }
  //   } else {
  //     if (isRecordingPressed) {
  //       var tempDir = await getTemporaryDirectory();
  //       var path = '${tempDir.path}/flutter_sound.aac';
  //       // if (!isRecorderInit) {
  //       //   return;
  //       // }
  //       if (isRecording) {
  //         print('hi');
  //         final path = await _controller!.stop();
  //         showToastMessage("Sending Recording");
  //         sendFileMessage(File(path!), MessageEnum.audio);
  //       } else {
  //         await _controller!.record(path: path);
  //       }

  //       setState(() {
  //         isRecording = !isRecording;
  //         isRecordingPressed = !isRecordingPressed;
  //       });
  //     }
  //   }
  // }
  void sendTextMessage() async {
    if (isShowSendButton) {
      if (_messageController.text.isNotEmpty) {
        ChatMethods().sendTextMessage(
          context: context,
          text: _messageController.text.trim(),
          recieverUserId: widget.model.contactId,
          senderUser: userInfo!,
          messageReply: null,
          isGroupChat: widget.isGroupChat,
        );
        setState(() {
          _messageController.text = '';
          if (!widget.isGroupChat) {
            ChatMethods().stopTyping(widget.model.contactId);
          }
        });
      }
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      // if (!isRecorderInit) {
      //   return;
      // }
      if (isRecording) {
        final path = await _controller!.stop();
        showToastMessage("Sending Recording");
        sendFileMessage(File(path!), MessageEnum.audio);
      } else {
        await _controller!.record(path: path);
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
    if (!isShowSendButton) {
      // ChatMethods()
      //     .updateTyping(widget.model.contactId, true);
      setState(() {
        isShowSendButton = true;
      });
    } else {
      // ChatMethods().updateTyping(widget.model.contactId, false);
      setState(() {
        isShowSendButton = false;
      });
    }
  }

  void cancelRecording() {
    _controller!.stop();
    showToastMessage("Recording Cancelled");
    setState(() {
      isRecording = !isRecording;
    });
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ChatMethods().sendFileMessage(
        context: context,
        file: file,
        recieverUserId: widget.model.contactId,
        messageEnum: messageEnum,
        senderUserData: userInfo!,
        messageReply: null,
        isGroupChat: widget.isGroupChat);
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      showToastMessage("Sending File");
      sendFileMessage(file, MessageEnum.file);
    } else {
      // User canceled the picker
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePreviewSending(
                  isGroupChat: widget.isGroupChat,
                  contactId: widget.model.contactId,
                  imagePath: image)));
      // sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      int sizeInBytes = video.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 30) {
        showToastMessage("Size is greater than 30 mb");
      } else {
        showToastMessage("Sending Video");
        sendFileMessage(video, MessageEnum.video);
      }
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  Widget getTextField() {
    return Column(
      children: [
        if (messageReply != null)
          MessageReplyPreview(
              photoUrl: widget.model.profilePicture,
              messageReply: messageReply),
        Row(
          children: [
            if (isRecording)
              Row(
                children: [
                  AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 1.95, 30.0),
                    recorderController: _controller!,
                    enableGesture: false,
                    padding: const EdgeInsets.all(20),
                    waveStyle: const WaveStyle(
                      waveColor: Palette.cuiPurple,
                      waveThickness: 5,
                      backgroundColor: Colors.black,
                      showDurationLabel: true,
                      spacing: 8.0,
                      durationStyle: TextStyle(color: Palette.cuiPurple),
                      showBottom: true,
                      extendWaveform: true,
                      durationLinesColor: Palette.cuiPurple,
                      showMiddleLine: false,
                      //   gradient: ui.Gradient.linear(
                      //     const Offset(70, 50),
                      //     // Offset(MediaQuery.of(context).size.width / 2, 0),
                      //     [Colors.red, Colors.green],
                      // ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        cancelRecording();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20,
                        child: Icon(
                          Icons.close,
                          // ? Icons.close
                          // : Icons.mic,

                          size: 20,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        sendTextMessage();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Palette.cuiPurple,
                        radius: 20,
                        child: Center(
                          child: Icon(
                            Icons.send,
                            // ? Icons.close
                            // : Icons.mic,

                            size: 20,
                            color: Palette.white,
                          ),
                        ),
                      ))
                ],
              ),
            if (!isRecording)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: _messageController,
                              autofocus: false,
                              maxLines: 10,
                              minLines: 1,
                              onChanged: (val) {
                                if (!isBlocked) {
                                  // log(isBlocked.toString());
                                  if (!widget.isGroupChat) {
                                    ChatMethods()
                                        .setTyping(widget.model.contactId);
                                  }
                                }
                                if (val.isNotEmpty) {
                                  if (!isShowSendButton) {
                                    setState(() {
                                      isShowSendButton = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isShowSendButton = false;
                                  });
                                  if (!widget.isGroupChat) {
                                    ChatMethods()
                                        .stopTyping(widget.model.contactId);
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: 'Message ${widget.model.name}',
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: Palette.cuiOffWhite,
                                        child: Wrap(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      selectFile();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Palette
                                                                    .cuiPurple),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Icon(
                                                              Icons
                                                                  .document_scanner_sharp,
                                                              size: 35,
                                                              color: Palette
                                                                  .cuiPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Document',
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      selectImage();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Palette
                                                                    .cuiPurple),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Icon(
                                                              Icons
                                                                  .camera_enhance_rounded,
                                                              size: 35,
                                                              color: Palette
                                                                  .cuiPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Image',
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                      // return Wrap(
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Palette.cuiPurple,
                                ),
                              ),
                              IconButton(
                                onPressed: toggleEmojiKeyboardContainer,
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                  color: Palette.cuiPurple,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isRecordingPressed = true;
                                    sendTextMessage();
                                  });
                                },
                                icon: const Icon(
                                  Icons.mic_rounded,
                                  color: Palette.cuiPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  sendTextMessage();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: isShowSendButton
                                      ? Palette.cuiPurple
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                      _messageController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _messageController.text.length));
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isShowEmojiContainer) {
      focusNode.unfocus();
    }
    return StreamBuilder<UserModel>(
        stream: ChatMethods().getBlockStatus(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Palette.cuiOffWhite,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Card(
                elevation: 5,
                child: snapshot.data!.blockList.contains(widget.model.contactId)
                    ? const Text("You have blocked this user")
                    : getTextField(),
              ),
            );
          }
          return getTextField();
        });
  }
}

class MenuItems {
  static late List<MenuItem> firstItems;
  // static List<MenuItem> secondItems = [logout];

  static var home;
  static var share;
  static var logout;
  // static var home = MenuItem(
  //     text: isGroupChat ? "Group Info" : "Profile",
  //     icon: isGroupChat ? Icons.groups_2_rounded : Icons.person);
  // static var share = const MenuItem(text: 'Delete', icon: Icons.delete);
  // static var logout = MenuItem(
  //     text: isGroupChat
  //         ? "Leave"
  //         : isBlocked
  //             ? "Unblock"
  //             : "Block",
  //     icon: Icons.logout);

  static void makeMenuItem(bool isGroupChat, bool isBlocked) {
    home = MenuItem(
        text: isGroupChat ? "Group Info" : "Profile",
        icon: isGroupChat ? Icons.groups_2_rounded : Icons.person);
    share = const MenuItem(text: 'Delete', icon: Icons.delete);
    logout = MenuItem(
        text: isGroupChat
            ? "Leave"
            : isBlocked
                ? "Unblock"
                : "Block",
        icon: Icons.logout);
    //adding the values to the list
    firstItems = [home, if (!isGroupChat) share, logout];
  }

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(
      BuildContext context,
      MenuItem item,
      VoidCallback profileCallBack,
      VoidCallback deleteCallBack,
      VoidCallback blockCallBack) {
    if (item == MenuItems.home) {
      profileCallBack();
    } else if (item == MenuItems.share) {
      deleteCallBack();
    } else if (item == MenuItems.logout) {
      blockCallBack();
    }
  }
}
// showOptions
//         ? ListView.builder(
//             controller: widget.messageController,
//             itemCount: widget.tempMessage.length + 1,
//             physics: const ClampingScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: ((context, index) {
//               var messageData;
//               if (index != widget.tempMessage.length) {
//                 messageData = widget.tempMessage[index];
//                 if (messageData.messageId == messageData.recieverid) {
//                   widget.isTyping = true;
//                 } else {
//                   var timeSent = DateFormat.jm().format(messageData.timeSent);
//                   if (!messageData.isSeen &&
//                       messageData.recieverid == firebaseAuth.currentUser!.uid) {
//                     if (!isGroupChat) {
//                       ChatMethods().setChatMessageSeen(
//                         widget.contactModel.contactId,
//                         messageData.messageId,
//                       );
//                     }
//                   }
//                   if (isGroupChat) {
//                     ChatMethods().setChatContactMessageSeen(
//                         widget.contactModel.contactId, isGroupChat);
//                   }
//                   //showing the time
//                   var dateInList =
//                       DateFormat.MMMMEEEEd().format(messageData.timeSent);
//                   if (widget.previousTime != dateInList) {
//                     widget.previousTime = dateInList;
//                     widget.isDateShown = false;
//                   } else {
//                     widget.isDateShown = true;
//                   }

//                   if (messageData.senderId == firebaseAuth.currentUser!.uid) {
//                     return Column(
//                       children: [
//                         if (!widget.isDateShown) getDateWithLines(dateInList),
//                         InkWell(
//                           onTap: (() {
//                             {
//                               if (widget.messageId
//                                   .contains(messageData.messageId)) {
//                                 widget.decrementSelectedNum();

//                                 widget.messageId.remove(messageData.messageId);
//                               } else {
//                                 widget.incrementSelectedNum();

//                                 widget.messageId.add(messageData.messageId);
//                               }
//                             }
//                           }),
//                           child: MyMessageCard(
//                             message: messageData.text,
//                             date: timeSent,
//                             isSeen: messageData.isSeen,
//                             type: messageData.type,
//                             isSelected: widget.messageId
//                                 .contains(messageData.messageId),
//                             repliedText: messageData.repliedMessage,
//                             username: messageData.repliedTo,
//                             repliedMessageType: messageData.repliedMessageType,
//                             longPress: widget.changeShowOptions,
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   return Column(
//                     children: [
//                       if (!widget.isDateShown) getDateWithLines(dateInList),
//                       InkWell(
//                         onTap: (() {
//                           {
//                             if (widget.messageId
//                                 .contains(messageData.messageId)) {
//                               widget.decrementSelectedNum();

//                               widget.messageId.remove(messageData.messageId);
//                             } else {
//                               widget.incrementSelectedNum();

//                               widget.messageId.add(messageData.messageId);
//                             }
//                           }
//                         }),
//                         child: Row(
//                           children: [
//                             SenderMessageCard(
//                               avatarWidget: getAvatarWithStatus(
//                                   isGroupChat, widget.contactModel),
//                               photoUrl: widget.contactModel.photoUrl,
//                               message: messageData.text,
//                               date: timeSent,
//                               type: messageData.type,
//                               username: messageData.senderUsername ?? "",
//                               isSelected: widget.messageId
//                                   .contains(messageData.messageId),
//                               repliedMessageType:
//                                   messageData.repliedMessageType,
//                               longPress: () {},
//                               repliedText: messageData.repliedMessage,
//                               isGroupChat: isGroupChat,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               }
//               return const SizedBox();
//             }),
//           )
//         :

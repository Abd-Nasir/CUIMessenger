import 'dart:io';

import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/message_enum.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:flutter/material.dart';

class ImagePreviewSending extends StatefulWidget {
  final File imagePath;
  final bool isGroupChat;
  final String contactId;
  const ImagePreviewSending(
      {required this.isGroupChat,
      required this.contactId,
      required this.imagePath,
      super.key});

  @override
  State<ImagePreviewSending> createState() => _ImagePreviewSendingState();
}

class _ImagePreviewSendingState extends State<ImagePreviewSending> {
  void sendFileMessage() {
    ChatMethods().sendFileMessage(
        context: context,
        file: widget.imagePath,
        recieverUserId: widget.contactId,
        messageEnum: MessageEnum.image,
        senderUserData: userInfo!,
        messageReply: null,
        isGroupChat: widget.isGroupChat);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          actions: [
            TextButton(
                onPressed: () {
                  showToastMessage("Sending Image");
                  sendFileMessage();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ))
            // InkWell(
            //   onTap: () {
            //     showToastMessage("Sending Image");
            //     sendFileMessage();
            //     Navigator.pop(context);
            //   },
            //  ,
            // ),
          ],
        ),
        body: Center(
          child: Image.file(
              fit: BoxFit.fitWidth, width: size.width, widget.imagePath),
        ));
  }
}

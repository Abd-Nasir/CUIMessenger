import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/message_enum.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/widgets/display_text_image_file.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final bool isSeen;
  final MessageEnum type;
  final VoidCallback longPress;
  final String repliedText;
  final String username;
  final bool? isSelected;
  final MessageEnum repliedMessageType;

  const MyMessageCard(
      {required this.message,
      required this.date,
      required this.isSeen,
      required this.type,
      required this.longPress,
      required this.repliedText,
      required this.username,
      this.isSelected,
      required this.repliedMessageType,
      super.key});

  @override
  Widget build(BuildContext context) {
    // final isReplying = repliedText.isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 80,
              maxWidth: type != MessageEnum.audio
                  ? MediaQuery.of(context).size.width / 1.4
                  : MediaQuery.of(context).size.width / 1.25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0, right: 10, left: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // const Text(
                  //   "You",
                  //   style: TextStyle(
                  //       fontSize: 13, color: Color.fromARGB(124, 0, 0, 0)),
                  // ),
                  // const SizedBox(
                  //   width: 2,
                  // ),
                  Text(
                    date,
                    style: const TextStyle(
                        fontSize: 13, color: Color.fromARGB(124, 0, 0, 0)),
                  ),
                  // Icon(
                  //   Icons.done_all,
                  //   size: 16,
                  //   color: isSeen ? mainColor : Colors.grey,
                  // )
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Card(
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        // topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )),
                      color: Palette.cuiPurple,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: DisplayTextImageGIF(
                              photoUrl: userInfo!.profilePicture,
                              message: message,
                              type: type,
                              isSender: true)),
                    ),
                  ),
                  if (isSelected != null)
                    if (isSelected!) const Icon(Icons.check_box),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

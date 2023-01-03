import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
// import '../widgets/message_textfield.dart';
// import '../widgets/single_message.dart';

class ChatBox extends StatelessWidget {
  static const routeName = "/ChatScreen";
  final String currentUser;
  final String friendId;
  final String friendName;
  final String friendImageUrl;
  // final String friendImage;

  const ChatBox({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImageUrl,
    // required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        // mediaQuery.size.height * 0.08,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Center(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      RouteGenerator.navigatorKey.currentState!.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Palette.cuiPurple,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: friendImageUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      friendName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.info_outline,
                      color: Palette.cuiPurple, size: 25
                      // mediaQuery.size.height * 0.04,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("registered-users")
                    .doc(currentUser)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              currentUser;
                          return SingleMessage(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(currentId: currentUser, recieverId: friendId),
        ],
      ),
    );
  }

  Widget SingleMessage({required String message, required bool isMe}) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: isMe ? Palette.darkWhite : Palette.cuiPurple,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomRight: isMe ? Radius.zero : const Radius.circular(10),
                bottomLeft: !isMe ? Radius.zero : const Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 0.1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Palette.cuiPurple : Colors.white,
              ),
            )),
      ],
    );
  }

  Widget MessageTextField(
      {required String currentId, required String recieverId}) {
    TextEditingController _controller = TextEditingController();
    return Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _controller,
            cursorColor: Palette.cuiPurple,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Palette.cuiPurple),
              labelText: "Type your Message",
              fillColor: Colors.grey[100],
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Palette.cuiBlue),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0),
                gapPadding: 10,
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Palette.cuiPurple),
              ),
            ),
          )),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('registered-users')
                  .doc(currentId)
                  .collection('messages')
                  .doc(recieverId)
                  .collection('chats')
                  .add({
                "senderId": currentId,
                "receiverId": friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('registered-users')
                    .doc(currentId)
                    .collection('messages')
                    .doc(friendId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('registered-users')
                  .doc(friendId)
                  .collection('messages')
                  .doc(currentId)
                  .collection("chats")
                  .add({
                "senderId": currentId,
                "receiverId": friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('registered-users')
                    .doc(friendId)
                    .collection('messages')
                    .doc(currentId)
                    .set({"last_msg": message});
              });
            },
            child: Container(
              height: 45,
              width: 45,
              // padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.cuiPurple,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cui_messenger/chat/model/chat_user.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final TextEditingController searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatUser> user = [
      ChatUser(
          fullName: "Abdullah Nasir",
          time: "8:45",
          messageText:
              "This is recent messageThis is recent messageThis is recent messageThis is recent messageThis is recent messageThis is recent message",
          imageUrl: ""),
      ChatUser(
          fullName: "Leon Nagel",
          time: "9:45",
          messageText: "This is recent message",
          imageUrl: ""),
      ChatUser(
          fullName: "Usama Ashraf",
          time: "8:45",
          messageText: "This is recent message",
          imageUrl: ""),
    ];
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: mediaQuery.size.height * 0.1,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Center(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: mediaQuery.size.width * 0.08),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: mediaQuery.size.width * 0.01,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: "",
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
                  SizedBox(width: mediaQuery.size.width * 0.03),
                  Expanded(
                    child: Text(
                      "Safepall Chat",
                      style: TextStyle(
                          fontSize: mediaQuery.size.height * 0.03,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: mediaQuery.size.width * 0.03,
                  left: mediaQuery.size.width * 0.04,
                  right: mediaQuery.size.width * 0.04,
                  bottom: mediaQuery.size.height * 0.02),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                // reverse: t,
                itemCount: 5,
                // state.provider.chatList.length,
                itemBuilder: (ctx, index) {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  String name = '';
                  // if (state.provider.chatList[index].messages.first.sender
                  //         .uid ==
                  //     uid) {
                  //   name = state.provider.chatList[index].messages.first
                  //       .recepient.name;
                  // } else {
                  //   name = state
                  //       .provider.chatList[index].messages.first.sender.name;
                  // }

                  return chatUserWidget(
                      mediaQueryData: mediaQuery,
                      context: context,
                      fullName: name,
                      messageText: "",
                      // state.provider.chatList[index].messages.last.message,
                      time: "",
                      // state.provider.chatList[index].messages.last.sentTime
                      //     .toString(),
                      imageUrl: "",
                      // BlocProvider.of<AuthBloc>(context)
                      //     .state
                      //     .user!
                      //     .profilePicture,
                      onTap: () {});
                }),
          ],
        ),
      ),
    );
  }

  Widget chatUserWidget({
    required MediaQueryData mediaQueryData,
    required BuildContext context,
    required String fullName,
    required String imageUrl,
    required String time,
    required String messageText,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 2, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Palette.frenchBlue.withOpacity(0.25),
                  blurRadius: 8.0,
                  // offset: Offset.zero
                  offset: const Offset(0.0, 3.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: mediaQueryData.size.width * 0.04,
              right: mediaQueryData.size.width * 0.04,
              top: mediaQueryData.size.height * 0.015,
              bottom: mediaQueryData.size.height * 0.015,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // border:
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
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
                      SizedBox(
                        width: mediaQueryData.size.width * 0.040,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                fullName,
                                style: const TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: mediaQueryData.size.height * 0.008,
                              ),
                              Text(
                                messageText,
                                maxLines: 2,
                                // widget.messageText,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight:
                                        // widget.isMessageRead?FontWeight.bold:
                                        FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
                  child: const Text(
                    "9:33 pm",
                    // widget.time,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            //  widget.isMessageRead
                            //     ? FontWeight.bold
                            //     :
                            FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   alignment: Alignment.centerRight,
          //   margin: EdgeInsets.only(left: mediaQueryData.size.width * 0.2),
          //   // width: mediaQueryData.size.width * 0.8,
          //   child: Divider(
          //     color: Palette.frenchBlue,
          //     indent: mediaQueryData.size.width * 0.03,
          //   ),
          // ),
        ],
      ),
    );
  }
}

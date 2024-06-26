import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/models/chat_model.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

class ChatProfileScreen extends StatefulWidget {
  final ChatContactModel chatContactModel;
  const ChatProfileScreen({required this.chatContactModel, super.key});

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  bool isGroupChat = false;
  ValueNotifier<int> controlValue = ValueNotifier(0);
  Future<UserModel> getUserInfo() async {
    return firebaseFirestore
        .collection('registered-users')
        .doc(widget.chatContactModel.contactId)
        .get()
        .then((value) {
      return UserModel.getValuesFromSnap(value);
    });
  }

  void callBack(int val) {
    controlValue.value = val;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.cuiOffWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "User Profile",
          style:
              TextStyle(color: Palette.cuiPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("Nothing to show you"),
              );
            }
            var data = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TopWidget(
                    chatContactModel: widget.chatContactModel,
                    isGroupChat: isGroupChat,
                    isTodo: controlValue.value,
                    size: size,
                    data: data,
                    callBack: callBack),
                const SizedBox(
                  height: 10,
                ),
                // ValueListenableBuilder(
                //     valueListenable: controlValue,
                //     builder: (context, value, check) {
                //       return value == 0
                //           ? isGroupChat
                //               ? Expanded(
                //                   child: TodoScreen(
                //                   // id: widget.contactModel.contactId,
                //                   isGroupChat: isGroupChat,
                //                   // people: widget.people,
                //                 ))
                //               : Expanded(
                //                   child: TodoScreen(
                //                   id: widget.chatContactModel.contactId,
                //                 ))
                //           : value == 1
                //               ? Expanded(
                //                   child: MediaScreen(
                //                   id: widget.chatContactModel.contactId,
                //                   isGroupChat: isGroupChat,
                //                 ))
                //               : Expanded(
                //                   child: FileScreen(
                //                   id: widget.chatContactModel.contactId,
                //                   isGroupChat: isGroupChat,
                //                 ));
                //     })

                // Center(
                //   child: Container(
                //     width: size.width / 1.2,
                //     height: 130,
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(15)),
                //     child: Padding(
                //       padding: const EdgeInsets.all(10),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Row(
                //               children: const [
                //                 Text(
                //                   "Contact Info",
                //                   style:
                //                       TextStyle(fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               const Icon(
                //                 Icons.phone,
                //                 color: Palette.cuiPurple,
                //               ),
                //               Text(
                //                 data.contact == ""
                //                     ? "Nothing to show"
                //                     : data.contact,
                //                 style: const TextStyle(
                //                     fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ),
                //           // if (data.contactEmail != "")
                //           //   Row(
                //           //     mainAxisAlignment: MainAxisAlignment.start,
                //           //     children: [
                //           //       const Icon(
                //           //         Icons.phone,
                //           //         color: Palette.cuiPurple,
                //           //       ),
                //           //       Text(
                //           //         data.contactEmail,
                //           //         style: const TextStyle(
                //           //             fontWeight: FontWeight.bold),
                //           //       ),
                //           //     ],
                //           //   ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               const Icon(
                //                 Icons.location_on,
                //                 color: Palette.cuiPurple,
                //               ),
                //               Text(
                //                 data.location == ""
                //                     ? "Nothing to show"
                //                     : data.location,
                //                 style: const TextStyle(
                //                     fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Container(
                //     width: size.width / 1.2,
                //     height: 100,
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(15)),
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 20),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Row(
                //             children: const [
                //               Text(
                //                 "Contact Info",
                //                 style: TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ),
                //           if (data.contact != "")
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 const Icon(
                //                   Icons.phone,
                //                   color: Palette.cuiPurple,
                //                 ),
                //                 Text(
                //                   data.contact,
                //                   style: const TextStyle(
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           // if (data.contactEmail != "")
                //           //   Row(
                //           //     mainAxisAlignment: MainAxisAlignment.start,
                //           //     children: [
                //           //       const Icon(
                //           //         Icons.phone,
                //           //         color: Palette.cuiPurple,
                //           //       ),
                //           //       Text(
                //           //         data.contactEmail,
                //           //         style: const TextStyle(
                //           //             fontWeight: FontWeight.bold),
                //           //       ),
                //           //     ],
                //           //   ),
                //           if (data.location != "")
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 const Icon(
                //                   Icons.location_on,
                //                   color: Palette.cuiPurple,
                //                 ),
                //                 Text(
                //                   data.location,
                //                   style: const TextStyle(
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Container(
                //       constraints: BoxConstraints(
                //         maxHeight: 350,
                //         minHeight: 150,
                //         maxWidth: size.width / 1.2,
                //         minWidth: size.width / 1.2,
                //       ),
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(15)),
                //       child: Padding(
                //         padding: const EdgeInsets.all(10),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: const [
                //                 Padding(
                //                   padding: EdgeInsets.all(8.0),
                //                   child: Text(
                //                     "Shared Documents",
                //                     style:
                //                         TextStyle(fontWeight: FontWeight.bold),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(
                //               height: 5,
                //             ),
                //             Flexible(
                //     child: FileScreen(
                //   id: widget.chatContactModel.contactId,
                //   isGroupChat: isGroupChat,
                // )),
                //           ],
                //         ),
                //       )),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Container(
                //       constraints: BoxConstraints(
                //         maxHeight: 600,
                //         minHeight: 150,
                //         maxWidth: size.width / 1.2,
                //         minWidth: size.width / 1.2,
                //       ),
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(15)),
                //       child: Padding(
                //         padding: const EdgeInsets.all(10),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: const [
                //                 Padding(
                //                   padding: EdgeInsets.all(8.0),
                //                   child: Text(
                //                     "Shared Media",
                //                     style:
                //                         TextStyle(fontWeight: FontWeight.bold),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(
                //               height: 5,
                //             ),
                // Flexible(
                //     child: MediaScreen(
                //   id: widget.chatContactModel.contactId,
                //   isGroupChat: isGroupChat,
                // )),
                //           ],
                //         ),
                //       )),
                // )
              ],
            );
          }),
    );
  }
}

// ignore: must_be_immutable
class TopWidget extends StatelessWidget {
  final ChatContactModel chatContactModel;
  final Size size;
  final UserModel data;
  final bool isGroupChat;
  int isTodo;
  Function callBack;
  TopWidget(
      {required this.chatContactModel,
      required this.size,
      required this.data,
      required this.isGroupChat,
      required this.isTodo,
      required this.callBack,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  getAvatarWithStatus(isGroupChat, chatContactModel, size: 50),
                  // showUsersImage(data.photoUrl == "",
                  //     size: 50,
                  //     picUrl: data.photoUrl != ""
                  //         ? data.photoUrl
                  //         : "assets/user.png"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            data.firstName == ""
                                ? "Nothing to show"
                                : data.firstName,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            data.email == "" ? "Nothing to show" : data.email,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Center(
            //   child: Text(
            //     data.bio == "" ? "Nothing to show" : data.bio,
            //     textAlign: TextAlign.center,
            //     overflow: TextOverflow.visible,
            //     style:
            //         const TextStyle(fontWeight: FontWeight.w500),
            //   ),
            // ),
            StatefulBuilder(builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 0;
                        });
                        callBack(0);
                      },
                      child: Text(
                        "To-do",
                        style: TextStyle(
                            color:
                                isTodo == 0 ? Palette.cuiPurple : Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 1;
                        });
                        callBack(1);
                      },
                      child: Text(
                        "Media",
                        style: TextStyle(
                            color:
                                isTodo == 1 ? Palette.cuiPurple : Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 2;
                        });
                        callBack(2);
                      },
                      child: Text(
                        "Files",
                        style: TextStyle(
                            color:
                                isTodo == 2 ? Palette.cuiPurple : Colors.black),
                      )),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

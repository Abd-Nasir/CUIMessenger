import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/chat/models/chat_model.dart';
import 'package:cui_messenger/chat/models/user_model.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddPeople extends StatefulWidget {
  BuildContext? context;
  List? usersList;
  VoidCallback? refresh;
  bool isForGroup = false;
  String? groupId;
  AddPeople(this.context, this.usersList, this.refresh,
      {bool isForGroup = false, String groupId = ""});

  @override
  State<AddPeople> createState() => _AddPeopleState();
}

Future<DocumentSnapshot> getDocumentById(String documentId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(documentId)
      .get();
  return snapshot;
}

class _AddPeopleState extends State<AddPeople> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        // barrierDismissible: false,
        // context: context,
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
        height: size.height / 2,
        width: size.width,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      widget.refresh!();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FutureBuilder<List<UserModel>>(
                  future: widget.isForGroup
                      ? ChatMethods().getMembersOfGroup(widget.groupId!)
                      : ChatMethods().getContacts(),
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
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                var data = snapshot.data![index];
                                return widget.isForGroup
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      contactModel:
                                                          ChatContactModel(
                                                              contactId:
                                                                  data.uid,
                                                              name:
                                                                  data.username,
                                                              photoUrl:
                                                                  data.photoUrl,
                                                              timeSent: DateTime
                                                                  .now(),
                                                              lastMessageBy: "",
                                                              lastMessageId: "",
                                                              isSeen: false,
                                                              lastMessage: ""),
                                                    )),
                                          );
                                        },
                                        child: getForwardCard(data, context))
                                    : InkWell(
                                        onTap: () async {
                                          DocumentSnapshot document =
                                              await getDocumentById(
                                                  userInfo.uid);

                                          // print(document.data['']);

                                          setState(() {
                                            if (widget.usersList!
                                                .contains(data.uid)) {
                                              // usersModelList.remove(data);

                                              widget.usersList!
                                                  .remove(data.uid);
                                              var list = [];
                                              print(widget.usersList);
                                              // for (int x = 0;
                                              //     x < widget.usersList!.length;
                                              //     x++) {
                                              //       if()
                                              //   list.add(data.uid);
                                              // }
                                              list.add(data.uid);
                                              print(data.uid);
                                              FirebaseFirestore.instance
                                                  .collection('groups')
                                                  .doc(userInfo.uid)
                                                  .update({
                                                'membersUid': widget.usersList
                                              });
                                            } else {
                                              // usersModelList.add(data);
                                              widget.usersList!.add(data.uid);
                                            }
                                          });
                                        },
                                        child: getPeopleCard(
                                            data,
                                            context,
                                            widget.usersList!
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
                        //         backgroundColor: mainColor,
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
    }));
  }
}

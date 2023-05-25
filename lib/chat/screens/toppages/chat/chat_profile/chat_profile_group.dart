import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';

import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/utils.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/chat/methods/storage_methods.dart';
import 'package:cui_messenger/chat/models/chat_model.dart';
import 'package:cui_messenger/chat/models/group.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_screen.dart';

import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:cui_messenger/chat/models/group.dart' as model;
// import 'package:yourteam/models/group.dart' as model;

class ChatProfileGroup extends StatefulWidget {
  final String id;
  const ChatProfileGroup({required this.id, super.key});

  @override
  State<ChatProfileGroup> createState() => _ChatProfileGroupState();
}

class _ChatProfileGroupState extends State<ChatProfileGroup> {
  final TextEditingController groupNameController = TextEditingController();
  bool isLoaded = false;
  File? image;
  List<String> peopleUid = [];
  Group? groupInfo;
  Future<String>? future;
  // List people = [];
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    String url = await StorageMethods()
        .storeFileToFirebase('group/${groupInfo!.groupId}', image!);
    await firebaseFirestore.collection('groups').doc(groupInfo!.groupId).update(
      {
        "groupPic": url,
      },
    );
    showToastMessage("Group Picture updated");
    setState(() {});
  }

  void refresh() async {
    // people = [];
    // for (var e in peopleUid) {
    //   UserModel userModel = UserModel.getValuesFromSnap(
    //       await firebaseFirestore.collection("users").doc(e).get());
    //   people.add(userModel);
    // }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty) {
      try {
        model.Group group = model.Group(
          lastMessageBy: groupInfo!.lastMessageBy,
          name: groupNameController.text.trim(),
          groupId: groupInfo!.groupId,
          lastMessage: groupInfo!.lastMessage,
          groupPic: groupInfo!.groupPic,
          membersUid: peopleUid,
          isSeen: groupInfo!.isSeen,
          timeSent: groupInfo!.timeSent,
        );

        await firebaseFirestore
            .collection('groups')
            .doc(groupInfo!.groupId)
            .update(group.toMap());
        Navigator.pop(context);
      } catch (e) {
        showToastMessage(e.toString());
      }
    }
  }

  getInfo() async {
    return await firebaseFirestore
        .collection('groups')
        .doc(widget.id)
        .get()
        .then((value) {
      Group val = Group.fromMap(value.data()!);
      groupInfo = val;
      peopleUid = val.membersUid;
      groupNameController.text = val.name;
      setState(() {
        isLoaded = true;
      });
      future = getImage(groupInfo!.groupId, true);

      return val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: peopleUid.isNotEmpty ? createGroup : null,
            icon: Icon(
              Icons.done,
              color: peopleUid.isEmpty ? Colors.grey : Colors.black,
            ),
          )
        ],
        title: const Text(
          "Group Info",
          style:
              TextStyle(color: Palette.cuiPurple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: !isLoaded
            ? const Center(child: CircularProgressIndicator())
            : getWidget(size, groupInfo),
      ),
    );
  }
  // FutureBuilder<Group>(
  //           future: getInfo(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(
  //                 child: CircularProgressIndicator(),
  //               );
  //             }
  //             if (snapshot.data == null) {
  //               return const Center(
  //                 child: Text("Nothing to show you"),
  //               );
  //             }
  //             var data = snapshot.data!;

  //           }),
  getWidget(size, data) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: size.width / 1.2,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Palette.cuiBlue.withOpacity(0.10),
                        offset: const Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            data.groupPic != "" || data.groupPic != null
                                ? FutureBuilder(
                                    future: future,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return CircleAvatar(
                                            backgroundColor:
                                                Palette.cuiOffWhite,
                                            radius: 80,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              snapshot.data!,
                                            ));
                                      }
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                            // backgroundColor: Palette.cuiOffWhite,
                                            radius: 80,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              snapshot.data!,
                                            ));
                                      } else {
                                        return const CircleAvatar(
                                            radius: 80,
                                            child: Icon(
                                              Icons.groups_outlined,
                                              size: 100,
                                            ));
                                      }
                                    })
                                : const CircleAvatar(
                                    radius: 80,
                                    child: Icon(
                                      Icons.groups_outlined,
                                      size: 100,
                                    )),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  elevation: 2.0,
                                  fillColor: const Color(0xFFF5F6F9),
                                  padding: const EdgeInsets.all(15.0),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Palette.cuiPurple,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: TextField(
                            controller: groupNameController,
                            style: const TextStyle(
                                color: Palette.cuiPurple,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                            // overflow: TextOverflow.visible,
                            // style: const TextStyle(
                            //     fontWeight: FontWeight.w800,
                            //     fontSize: 20),
                          ),
                        ),
                      ),
                    ],
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
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Members",
                style: TextStyle(
                    color: Palette.black, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Palette.cuiPurple,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  showPeopleForTask(context, peopleUid, refresh,
                      groupId: widget.id);
                },
                label: const Text("Add Members"),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<List<UserModel>>(
                future: ChatMethods().getMembersOfGroup(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Palette.cuiPurple,
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("Nothing to show you"),
                    );
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          var data = snapshot.data![index];
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            contactModel: ChatContactModel(
                                                contactId: data.uid,
                                                name: data.firstName,
                                                profilePicture:
                                                    data.profilePicture,
                                                timeSent: DateTime.now(),
                                                lastMessageBy: "",
                                                lastMessageId: "",
                                                isSeen: false,
                                                lastMessage: ""),
                                          )),
                                );
                              },
                              child: getForwardCard(data, context));
                        })),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/constants/utils.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/chat/methods/storage_methods.dart';
import 'package:cui_messenger/chat/models/group.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

// import 'package:cui_messenger//models/group.dart' as model;

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  List peopleUid = [];
  List people = [];
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void refresh() async {
    people = [];
    for (var e in peopleUid) {
      UserModel userModel = UserModel.getValuesFromSnap(
          await firebaseFirestore.collection("registered-users").doc(e).get());
      people.add(userModel);
    }
    setState(() {});
  }
  //   void createGroup() {
  //   if (groupNameController.text.trim().isNotEmpty && image != null) {

  //     ref.read(groupControllerProvider).createGroup(
  //           context,
  //           groupNameController.text.trim(),
  //           image!,
  //           ref.read(selectedGroupContacts),
  //         );
  //     ref.read(selectedGroupContacts.state).update((state) => []);
  //     Navigator.pop(context);
  //   }
  // }
  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty) {
      try {
        var groupId = const Uuid().v1();
        String profileUrl = "";

        if (image != null) {
          profileUrl = await StorageMethods()
              .storeFileToFirebase('group/$groupId', image!);
        }

        Group group = Group(
          createdBy: FirebaseAuth.instance.currentUser!.uid,
          lastMessageBy: firebaseAuth.currentUser!.uid,
          name: groupNameController.text.trim(),
          groupId: groupId,
          lastMessage: '',
          groupPic: profileUrl,
          membersUid: [firebaseAuth.currentUser!.uid, ...peopleUid],
          isSeen: [],
          timeSent: DateTime.now(),
        );

        await firebaseFirestore
            .collection('groups')
            .doc(groupId)
            .set(group.toMap());
        Navigator.of(context).pop();
      } catch (e) {
        showToastMessage(e.toString());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('ss');
    // refresh();
    return Scaffold(
        backgroundColor: Palette.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Palette.white,
          foregroundColor: Palette.cuiPurple,
          actions: [
            IconButton(
              onPressed: people.isNotEmpty ? createGroup : null,
              icon: Icon(
                Icons.done,
                color: people.isEmpty ? Colors.grey : Palette.cuiPurple,
              ),
            )
          ],
          title: const Text('Create Group'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            // maxHeight: 5,
                            staticPhotoUrl,
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            image!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.photo_camera,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                    vertical: MediaQuery.of(context).size.height * 0.05),
                decoration: CustomWidgets.textInputDecoration,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: 4),
                child: TextFormField(
                  controller: groupNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Group Name",
                    hintStyle: TextStyle(
                      color: Palette.hintGrey,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Group Participants:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              people.isEmpty
                  ? const Center(
                      child: Text("No Participants added"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        return getContactCard(people[index], context, false,
                            shouldShow: false);
                      })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             AddPeople(context, peopleUid, refresh)));
            // showPeopleForTask(context, peopleUid, refresh, groupId: null);
            addPeopleBottomSheet(context, peopleUid, refresh);
          },
          label: const Text('Add People'),
          icon: const Icon(Icons.people),
          backgroundColor: Palette.cuiPurple,
        ));
  }

  addPeopleBottomSheet(
    BuildContext context,
    List usersList,
    VoidCallback refresh,
  ) async {
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
                            future: ChatMethods().getContacts(),
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
                                          return InkWell(
                                              onTap: () {
                                                if (peopleUid
                                                    .contains(data.uid)) {
                                                  peopleUid.remove(data.uid);
                                                } else {
                                                  peopleUid.add(data.uid);
                                                }
                                                setState(() {});
                                              },
                                              child: getPeopleCard(
                                                  data,
                                                  context,
                                                  usersList
                                                      .contains(data.uid)));
                                        })),
                                  ),
                                ],
                              );
                            }),
                      )),
                    );
                  }),
                ])));
  }
}

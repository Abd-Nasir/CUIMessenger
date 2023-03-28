import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/chat/view/chat_box.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

class ChatHomeScreen extends StatefulWidget {
  static const routeName = "/ChatHomeScreen";
  // UserModel user;
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  bool textFieldSelected = false;
  List<Map<dynamic, dynamic>> _foundUsers = [];
  TextEditingController searchController = TextEditingController();

  final List<Map> _allUsers = [];

  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  var charLength;

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      charLength = enteredKeyword.length;
      print(charLength);
      if (charLength < 1) {
        textFieldSelected = false;
      } else {
        textFieldSelected = true;
      }
    });
    List<Map<dynamic, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["first-name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void listSearch() async {
    await FirebaseFirestore.instance
        .collection('registered-users')
        // .where('username', isEqualTo: searchController.text)
        .get()
        .then((value) {
      value.docs.forEach((users) {
        if (users.data()['email'] != user!.email) {
          _allUsers.add(users.data());
          print(_allUsers);
        }
      });
      _foundUsers = _allUsers;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    listSearch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final users = ModalRoute.of(context)!.settings.arguments as UserModel;
    // final userProvider = Provider.of<UserModel>(context);

    // Future<List> users = userProvider.getData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF8F8F8),
          centerTitle: true,
          // leading: const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5),
          //   child: CircleAvatar(
          //       // foregroundImage: AssetImage('assets/profile.jpg'),
          //       ),
          // ),
          title: const Text(
            'Chat Home',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: TextFormField(
                onTap: () {
                  textFieldSelected = true;
                },
                onChanged: (value) => _runFilter(value),
                // controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                      onTap: ((() {
                        // onSearch();
                        print('Search Pressed');
                      })),
                      child: const Icon(
                        Icons.search,
                        color: Palette.cuiPurple,
                      )),
                  // suffixIcon: textFieldSelected
                  //     ? Container()
                  //     : IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             textFieldSelected = false;
                  //           });
                  //         },
                  //         icon: const Icon(Icons.cancel_rounded)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Palette.cuiPurple),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Palette.cuiBlue),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Palette.cuiPurple),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(color: Palette.hintGrey),
                  hintText: "Search User",
                  fillColor: Palette.cuiBlue.withOpacity(0.1),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 40,
            // ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.cuiBlue.withOpacity(0.2),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: textFieldSelected
                      ? ListView.builder(
                          itemCount: _foundUsers.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                                onTap: (() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return ChatBox(
                                      currentUser:
                                          BlocProvider.of<AuthBloc>(context)
                                              .state
                                              .user!
                                              .uid,
                                      friendId: _foundUsers[index]['uid'],
                                      friendName:
                                          "${_foundUsers[index]['first-name']} ${_foundUsers[index]['last-name']}",
                                      friendImageUrl: _foundUsers[index]
                                          ['imageUrl'],
                                    );
                                  })));
                                }),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: Palette.cuiOffWhite,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ListTile(
                                    // leading: Image.asset('assets/user.png'),
                                    leading: Container(
                                      height: 45,
                                      width: 45,
                                      // margin: EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                          color: Palette.white,
                                          borderRadius:
                                              BorderRadius.circular(200.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Palette.frenchBlue
                                                    .withOpacity(0.25),
                                                offset: const Offset(0.0, 4.0),
                                                blurRadius: 16.0)
                                          ]),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200.0),
                                        child: CachedNetworkImage(
                                          imageUrl: _foundUsers[index]
                                              ['imageUrl'],
                                          // BlocProvider.of<AuthBloc>(context)
                                          //     .state
                                          //     .user!.
                                          //     .profilePicture,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _foundUsers[index]['first-name'],
                                    ),
                                    trailing: const Icon(
                                      Icons.chat,
                                      color: Palette.cuiPurple,
                                    ),
                                  ),
                                ));
                          }))
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('registered-users')
                              .doc(user!.uid)
                              .collection('messages')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length < 1) {
                                return const Center(
                                  child: Text("No Chats Available !"),
                                );
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    var friendId = snapshot.data.docs[index].id;
                                    var lastMsg =
                                        snapshot.data.docs[index]['last_msg'];
                                    return FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('registered-users')
                                          .doc(friendId)
                                          .get(),
                                      builder: (context,
                                          AsyncSnapshot asyncSnapshot) {
                                        if (asyncSnapshot.hasData) {
                                          var friend = asyncSnapshot.data;
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Palette.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Palette.frenchBlue
                                                          .withOpacity(0.25),
                                                      offset: const Offset(
                                                          0.0, 4.0),
                                                      blurRadius: 16.0)
                                                ]),
                                            padding: const EdgeInsets.all(10),
                                            child: ListTile(
                                              leading: Container(
                                                height: 45,
                                                width: 45,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        friend['imageUrl'],
                                                    // BlocProvider.of<AuthBloc>(context)
                                                    //     .state
                                                    //     .user!.
                                                    //     .profilePicture,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Center(
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress)),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                  "${friend['first-name']} ${friend['last-name']}"),
                                              subtitle: Container(
                                                child: Text(
                                                  "$lastMsg",
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatBox(
                                                              currentUser:
                                                                  user!.uid,
                                                              friendId:
                                                                  friend['uid'],
                                                              friendName: friend[
                                                                  'first-name'],
                                                              friendImageUrl:
                                                                  friend[
                                                                      'imageUrl'],
                                                            )));
                                              },
                                            ),
                                          );
                                        }
                                        return const LinearProgressIndicator();
                                      },
                                    );
                                  });
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),

                  // TextButton(
                  //   onPressed: (() => print('object')),
                  //   child: Text('Press'),
                  // )
                  // ListView.builder(
                  //   itemCount: ,
                  //   itemBuilder: ((context, index) {
                  //   return ChatUserCard(email: email, username: username)
                  // }))
                  // child: ListView.builder(itemBuilder: ((context, index) {
                  //   // return ChatUserCard(email: email, username: username)
                  // })),
                  // child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('users')
                  //         .snapshots(),
                  //     builder: (BuildContext context, snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return Text("There is no expense");
                  //       } else {
                  //         return ListView.builder(
                  //           itemCount: snapshot.data!.docs.length,
                  //           itemBuilder: (context, index) {
                  //             DocumentSnapshot products =
                  //                 snapshot.data!.docs[index];
                  //             return ChatUserCard(
                  //               email: products['email'],
                  //               username: products['username'],
                  //             );
                  //           },
                  //         );
                  //       }
                  //     }),
                ),
              ),
            )
          ],
        ));
  }
}

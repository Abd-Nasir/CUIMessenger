import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/feed/model/comment.dart';
import 'package:cui_messenger/helpers/style/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/style/colors.dart';

class CommentBox extends StatefulWidget {
  final String postId;
  const CommentBox({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController commentController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var currentUser = BlocProvider.of<AuthBloc>(context).state.user!;

    return Scaffold(
        backgroundColor: Palette.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Suggestions',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Palette.white,
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.postId)
                .collection('comments')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              // if (isLoading) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.docs.length > 0) {
                var data = snapshot.data.docs;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, i) {
                            Comment comment = Comment.fromJson(data[i].data());
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5, top: 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20,
                                                    vertical: 12,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: mediaQuery
                                                                .size.width *
                                                            0.08,
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.08,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Palette.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        200.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Palette
                                                                      .frenchBlue
                                                                      .withOpacity(
                                                                          0.25),
                                                                  offset:
                                                                      const Offset(
                                                                          0.0,
                                                                          4.0),
                                                                  blurRadius:
                                                                      16.0)
                                                            ]),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      200.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: comment
                                                                .userImage,
                                                            fit: BoxFit.cover,
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                Center(
                                                                    child: CircularProgressIndicator(
                                                                        value: downloadProgress
                                                                            .progress)),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.02,
                                                      ),
                                                      Text(
                                                        comment.name,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.72,
                                                    // color: Palette.cuiBlue,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 30,
                                                    ),
                                                    child: Text(
                                                      comment.text,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          // height: mediaQuery.size.height * 0.18,
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("posts")
                                                  .doc(widget.postId)
                                                  .collection('comments')
                                                  .doc(comment.commentId)
                                                  .collection('likes')
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Palette.cuiPurple,
                                                    ),
                                                  );
                                                }
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '${snapshot.data.docs.length}'),
                                                        StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "posts")
                                                                .doc(widget
                                                                    .postId)
                                                                .collection(
                                                                    'comments')
                                                                .doc(comment
                                                                    .commentId)
                                                                .collection(
                                                                    'likes')
                                                                .doc(currentUser
                                                                    .uid)
                                                                .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot
                                                                    iconSnapshot) {
                                                              if (!iconSnapshot
                                                                  .hasData) {
                                                                const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Palette
                                                                        .cuiPurple,
                                                                  ),
                                                                );
                                                              }
                                                              return IconButton(
                                                                splashRadius: 2,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .thumb_up_alt_rounded),
                                                                iconSize: 20,
                                                                color: iconSnapshot
                                                                            .data
                                                                            ?.data() !=
                                                                        null
                                                                    ? Palette
                                                                        .yellow
                                                                    : Palette
                                                                        .grey,
                                                                onPressed: () {
                                                                  final likeRef = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "posts")
                                                                      .doc(widget
                                                                          .postId)
                                                                      .collection(
                                                                          'comments')
                                                                      .doc(comment
                                                                          .commentId)
                                                                      .collection(
                                                                          'likes')
                                                                      .doc(currentUser
                                                                          .uid);

                                                                  likeRef
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    if (value
                                                                            .data() ==
                                                                        null) {
                                                                      likeRef
                                                                          .set({
                                                                        "uid": currentUser
                                                                            .uid,
                                                                        "name": currentUser.firstName +
                                                                            currentUser.lastName,
                                                                      });
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "posts")
                                                                          .doc(widget
                                                                              .postId)
                                                                          .collection(
                                                                              'comments')
                                                                          .doc(comment
                                                                              .commentId)
                                                                          .collection(
                                                                              'dislikes')
                                                                          .doc(currentUser
                                                                              .uid)
                                                                          .delete();
                                                                    } else {
                                                                      likeRef
                                                                          .delete();
                                                                    }
                                                                  });
                                                                },
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                    StreamBuilder(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "posts")
                                                                .doc(widget
                                                                    .postId)
                                                                .collection(
                                                                    'comments')
                                                                .doc(comment
                                                                    .commentId)
                                                                .collection(
                                                                    'dislikes')
                                                                .snapshots(),
                                                        builder: (context,
                                                            AsyncSnapshot
                                                                dislikeSnapshot) {
                                                          if (!dislikeSnapshot
                                                              .hasData) {
                                                            const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Palette
                                                                    .cuiPurple,
                                                              ),
                                                            );
                                                          }
                                                          return Row(
                                                            children: [
                                                              Text(
                                                                  '${dislikeSnapshot.data.docs.length}'),
                                                              StreamBuilder(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "posts")
                                                                      .doc(widget
                                                                          .postId)
                                                                      .collection(
                                                                          'comments')
                                                                      .doc(comment
                                                                          .commentId)
                                                                      .collection(
                                                                          'dislikes')
                                                                      .doc(currentUser
                                                                          .uid)
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      AsyncSnapshot
                                                                          iconSnapshot) {
                                                                    if (!iconSnapshot
                                                                        .hasData) {
                                                                      const Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              Palette.cuiPurple,
                                                                        ),
                                                                      );
                                                                    }
                                                                    return IconButton(
                                                                      splashRadius:
                                                                          5,
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .thumb_down_alt_rounded),
                                                                      iconSize:
                                                                          20,
                                                                      color: iconSnapshot.data?.data() !=
                                                                              null
                                                                          ? Palette
                                                                              .cuiPurple
                                                                          : Palette
                                                                              .grey,
                                                                      onPressed:
                                                                          () {
                                                                        final dislikeRef = FirebaseFirestore
                                                                            .instance
                                                                            .collection("posts")
                                                                            .doc(widget.postId)
                                                                            .collection('comments')
                                                                            .doc(comment.commentId)
                                                                            .collection('dislikes')
                                                                            .doc(currentUser.uid);
                                                                        dislikeRef
                                                                            .get()
                                                                            .then((value) {
                                                                          if (value.data() ==
                                                                              null) {
                                                                            dislikeRef.set({
                                                                              "uid": currentUser.uid,
                                                                              "name": currentUser.firstName + currentUser.lastName,
                                                                            });
                                                                            FirebaseFirestore.instance.collection("posts").doc(widget.postId).collection('comments').doc(comment.commentId).collection('likes').doc(currentUser.uid).delete();
                                                                          } else {
                                                                            dislikeRef.delete();
                                                                          }
                                                                        });

                                                                        // setState(() {
                                                                        //   _counter++;
                                                                        // });
                                                                      },
                                                                    );
                                                                  }),
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                decoration: CustomWidgets.textInputDecoration,
                                //   color: Palette.white,
                                child: TextFormField(
                                  autocorrect: false,
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Add new comment",
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                var docref = FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postId)
                                    .collection('comments')
                                    .doc();
                                var comment = Comment(
                                    uid: currentUser.uid,
                                    commentId: docref.id,
                                    regNo: currentUser.regNo,
                                    name: currentUser.firstName +
                                        currentUser.lastName,
                                    text: commentController.text,
                                    userImage: currentUser.profilePicture,
                                    commentImage: "",
                                    createdAt:
                                        DateTime.now().toIso8601String());
                                docref.set(comment.toJson());
                              },
                              icon: const Icon(
                                Icons.send,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(height: 10)
                  ],
                );
              } else {
                // return Center(
                //   child: CircularProgressIndicator(),
                // );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text("No Comments Available !"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                decoration: CustomWidgets.textInputDecoration,
                                //   color: Palette.white,
                                child: TextFormField(
                                  autocorrect: false,
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Add new comment",
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                var docref = FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postId)
                                    .collection('comments')
                                    .doc();
                                var comment = Comment(
                                    uid: currentUser.uid,
                                    commentId: docref.id,
                                    regNo: currentUser.regNo,
                                    name: currentUser.firstName +
                                        currentUser.lastName,
                                    text: commentController.text,
                                    userImage: currentUser.profilePicture,
                                    commentImage: "",
                                    createdAt:
                                        DateTime.now().toIso8601String());
                                docref.set(comment.toJson());
                              },
                              icon: const Icon(
                                Icons.send,
                              ),
                            )
                          ]),
                    ),
                  ],
                );
              }
            }));
  }
}

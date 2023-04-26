import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/feed/model/comment.dart';
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

  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var currentUser = BlocProvider.of<AuthBloc>(context).state.user!;

    return Scaffold(
        backgroundColor: Palette.cuiOffWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Comments',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Palette.cuiOffWhite,
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.postId)
                .collection('comments')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              var data = snapshot.data.docs;

              if (snapshot.hasData) {
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
                                                            0.75,
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                splashRadius: 5,
                                                icon: const Icon(
                                                    Icons.arrow_drop_up),
                                                iconSize: 30,
                                                color: Palette.grey,
                                                onPressed: () {
                                                  setState(() {
                                                    _counter++;
                                                  });
                                                },
                                              ),
                                              Text(
                                                '$_counter',
                                                textAlign: TextAlign.center,
                                              ),
                                              IconButton(
                                                splashRadius: 5,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 30,
                                                color: Palette.grey,
                                                onPressed: () {
                                                  setState(() {
                                                    _counter--;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 8),
                              color: Palette.cuiOffWhite,
                              child: TextFormField(
                                autocorrect: false,
                                controller: commentController,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 25, 10, 0),
                                    hintText: 'Add a comment',
                                    filled: true,
                                    fillColor: Palette.cuiOffWhite,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    )),
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
                                  createdAt: DateTime.now().toIso8601String());
                              docref.set(comment.toJson());
                            },
                            icon: const Icon(
                              Icons.send,
                            ),
                          )
                        ]),
                    SizedBox(height: 10)
                  ],
                );
              }
              return const Center(
                child: Text("No Comments Available !"),
              );
            }));
  }
}

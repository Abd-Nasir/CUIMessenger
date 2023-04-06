import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../helpers/style/colors.dart';
import '../model/comments.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({Key? key}) : super(key: key);

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final commentsData = Comments().comments;
    final commentsList = Provider.of<Comments>(context, listen: false).comments;

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
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: commentsData.length,
                  itemBuilder: (BuildContext context, i) {
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundImage: NetworkImage(
                                                  commentsList[i].userImage,
                                                ),
                                              ),
                                              SizedBox(
                                                width: mediaQuery.size.width *
                                                    0.02,
                                              ),
                                              Text(
                                                commentsList[i].title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child:
                                            Text(commentsList[i].description),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: mediaQuery.size.height * 0.18,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        splashRadius: 5,
                                        icon: const Icon(Icons.arrow_drop_up),
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
                                        icon: const Icon(Icons.arrow_drop_down),
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
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, bottom: 8),
                  color: Palette.cuiOffWhite,
                  child: TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 25, 10, 0),
                        hintText: 'Add a comment',
                        filled: true,
                        fillColor: Palette.cuiOffWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        )),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              )
            ])
          ],
        ));
  }
}

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
        body: ListView.builder(
            itemCount: commentsData.length,
            itemBuilder: (BuildContext context, i) {
              return Card(
                elevation: 0,
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
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        commentsList[i].title,
                                        // (${commentsList[i].id})',
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
                                child: Text(commentsList[i].description),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                splashRadius: 5,
                                icon: Icon(Icons.arrow_drop_up),
                                iconSize: 50,
                                color: Palette.grey,
                                onPressed: () {
                                  setState(() {
                                    _counter++;
                                  });
                                },
                              ),
                              Container(
                                child: Text(
                                  '$_counter',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                splashRadius: 5,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 50,
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
                    const Divider(
                      endIndent: 20,
                      indent: 20,
                      thickness: 1,
                    )
                  ],
                ),
              );
            }));
  }
}

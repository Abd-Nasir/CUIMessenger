import 'dart:ui';

import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/feed/model/post_class.dart';
import 'package:cui_messenger/feed/view/comment_box.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/bloc/auth_bloc.dart';
import '../model/posts.dart';
import 'package:provider/provider.dart';

enum postOptions { editPost, deletePost }

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  postOptions? selectedMenu;

  @override
  Widget build(BuildContext context) {
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    final postsData = Posts().posts;
    final postsList = Provider.of<Posts>(context, listen: false).posts;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.cuiOffWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.cuiOffWhite,
        centerTitle: true,
        title: const Text(
          'Feed',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.post_add_sharp,
                size: 26.0,
                color: Palette.cuiPurple,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: postsData.length,
          itemBuilder: (BuildContext context, i) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(postsList[i].userImage),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${postsList[i].title} (${postsList[i].id})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<postOptions>(
                          position: PopupMenuPosition.under,
                          initialValue: selectedMenu,
                          // Callback that sets the selected popup menu item.
                          onSelected: (postOptions item) {
                            setState(() {
                              selectedMenu = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<postOptions>>[
                            const PopupMenuItem<postOptions>(
                              value: postOptions.editPost,
                              child: Text('Edit Post'),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<postOptions>(
                              value: postOptions.deletePost,
                              child: Text('Delete Post'),
                            )
                          ],
                        ),
                      ]),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        postsList[i].description,
                        style: const TextStyle(color: Palette.grey),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.network(
                          postsList[i].imageUrl,
                        )),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            postsList[i].imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 20,
                            sigmaY: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon:
                                    Icon(Icons.thumb_up_alt_outlined, size: 20),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  RouteGenerator.navigatorKey.currentState!
                                      .pushNamed(commentScreenRoute);
                                },
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 20,
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            );
          }),
    );
  }
}

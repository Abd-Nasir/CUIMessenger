import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/feed/bloc/post_bloc.dart';
import 'package:cui_messenger/feed/bloc/post_event.dart';
import 'package:cui_messenger/feed/bloc/post_state.dart';
import 'package:cui_messenger/feed/model/post.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'new_post_screen.dart';

enum postOptions { editPost, deletePost }

Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => const NewPost(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.easeOutCirc;
      var curveTween = CurveTween(curve: curve);
      const begin = Offset(0.0, 2.0);
      const end = Offset.zero;
      var tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  postOptions? selectedMenu;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

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
              onTap: () {
                Navigator.of(context).push(_createRoute());
              },
              child: const Icon(
                Icons.post_add_sharp,
                size: 26.0,
                color: Palette.cuiPurple,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<PostBloc>(context)
                .add(const LoadPostsFromDatabase());
          },
          child: ListView.builder(
              itemCount: state.postProvider.posts.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: postCard(
                    context: context,
                    mediaQuery: mediaQuery,
                    post: state.postProvider.posts[index],
                  ),
                );
              }),
        );
      }),
    );
  }

  Widget postCard(
      {required Post post,
      required BuildContext context,
      required MediaQueryData mediaQuery}) {
    var currentUser = BlocProvider.of<AuthBloc>(context).state.user!;
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.userImage),
                ),
                const SizedBox(width: 8),
                Text(
                  post.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          PopupMenuButton<postOptions>(
            iconSize: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            splashRadius: 24,
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
              PopupMenuItem<postOptions>(
                height: mediaQuery.size.height * 0.035,
                padding: EdgeInsets.zero,
                value: postOptions.editPost,
                child: Container(
                  color: Colors.white,
                  height: mediaQuery.size.height * 0.035,
                  width: mediaQuery.size.width * 0.28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.edit_note,
                            size: 20, color: Palette.cuiPurple),
                      ),
                      Text(
                        'Edit Post',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<postOptions>(
                height: mediaQuery.size.height * 0.035,
                padding: EdgeInsets.zero,
                value: postOptions.deletePost,
                child: Container(
                  color: Colors.white,
                  height: mediaQuery.size.height * 0.035,
                  width: mediaQuery.size.width * 0.28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.delete,
                            size: 20, color: Palette.cuiPurple),
                      ),
                      Text(
                        'Delete Post',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
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
              post.description,
              style: const TextStyle(color: Palette.black),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(children: [
          post.imageUrl != ''
              ? Image.network(post.imageUrl!)
              : Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  post.imageUrl!,
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
                  sigmaY: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("posts")
                                .doc(post.postId)
                                .collection('likes')
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              return Text(
                                "${snapshot.data.docs.length}",
                                style: TextStyle(
                                    color: post.imageUrl != ''
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              );
                            }),
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("posts")
                                .doc(post.postId)
                                .collection('likes')
                                .doc(currentUser.uid)
                                .set({
                              "uid": currentUser.uid,
                              "name":
                                  currentUser.firstName + currentUser.lastName,
                            });
                          },
                          icon:
                              const Icon(Icons.thumb_up_alt_outlined, size: 20),
                          color:
                              post.imageUrl != '' ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        RouteGenerator.navigatorKey.currentState!.pushNamed(
                            commentScreenRoute,
                            arguments: post.postId);
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                        size: 20,
                      ),
                      color: post.imageUrl != '' ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ])
      ],
    );
  }
}

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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

  bool isLoading = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
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
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Palette.cuiPurple,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
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
                          // context: context,
                          mediaQuery: mediaQuery,
                          post: state.postProvider.posts[index],
                        ),
                      );
                    }),
          );
        }),
      ),
    );
  }

  Widget postCard(
      {required Post post,
      // required BuildContext context,
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
                Container(
                  height: mediaQuery.size.width * 0.1,
                  width: mediaQuery.size.width * 0.1,
                  decoration: BoxDecoration(
                      color: Palette.white,
                      borderRadius: BorderRadius.circular(200.0),
                      boxShadow: [
                        BoxShadow(
                            color: Palette.frenchBlue.withOpacity(0.25),
                            offset: const Offset(0.0, 4.0),
                            blurRadius: 16.0)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200.0),
                    child: CachedNetworkImage(
                      imageUrl: post.userImage,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
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
              ? Container(
                  // borderRadius: BorderRadius.circular(200.0),
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
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
              image: post.imageUrl != ""
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        // imageUrl:
                        post.imageUrl!,
                        // fit: BoxFit.cover,
                        // progressIndicatorBuilder:
                        //     (context, url, downloadProgress) => Center(
                        //         child: CircularProgressIndicator(
                        //             value: downloadProgress.progress)),
                        // errorWidget: (context, url, error) =>
                        //     const Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(post.postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${snapshot.data.docs.length}",
                                style: TextStyle(
                                    color: post.imageUrl != ''
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(post.postId)
                                      .collection('likes')
                                      .doc(currentUser.uid)
                                      .snapshots(),
                                  builder:
                                      (context, AsyncSnapshot iconSnapshot) {
                                    return IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("posts")
                                            .doc(post.postId)
                                            .collection('likes')
                                            .doc(currentUser.uid)
                                            .get()
                                            .then((value) {
                                          if (value.data() == null) {
                                            FirebaseFirestore.instance
                                                .collection("posts")
                                                .doc(post.postId)
                                                .collection('likes')
                                                .doc(currentUser.uid)
                                                .set({
                                              "uid": currentUser.uid,
                                              "name": currentUser.firstName +
                                                  currentUser.lastName,
                                            });
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection("posts")
                                                .doc(post.postId)
                                                .collection('likes')
                                                .doc(currentUser.uid)
                                                .delete();
                                          }
                                        });
                                      },
                                      icon: Icon(
                                          iconSnapshot.data?.data() != null
                                              ? Icons.thumb_up_alt_rounded
                                              : Icons.thumb_up_alt_outlined,
                                          size: 20),
                                      color: iconSnapshot.data?.data() != null
                                          ? Palette.cuiPurple
                                          : post.imageUrl == ''
                                              ? Colors.black
                                              : Palette.white,
                                    );
                                  }),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              RouteGenerator.navigatorKey.currentState!
                                  .pushNamed(commentScreenRoute,
                                      arguments: post.postId);
                            },
                            icon: const Icon(
                              Icons.comment_outlined,
                              size: 20,
                            ),
                            color: post.imageUrl != ''
                                ? Colors.white
                                : Colors.black,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ])
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/feed/model/post.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io' as io;

class PostProvider {
  PostProvider();

  // Static instance to access api without initialization
  static PostProvider instance = PostProvider();

  List<Post> posts = List.empty(growable: true);

  Future<void> loadData() async {
    try {
      // posts.clear();
      await FirebaseFirestore.instance.collection('posts').get().then((value) {
        // value.docs.first;
        // print(value.docs.first);
        posts.clear();
        value.docs.forEach((value) {
          posts.add(Post.fromJson(value.data()));
        });
      });
    } catch (error) {
      debugPrint("error loading Reports from database.\nError:\n$error");
    }
  }

  Future<bool> saveReport(Post post, XFile? file) async {
    try {
      print("In save report");
      if (file != null) {
        print("In if of save report");
        final ref = FirebaseStorage.instance
            .ref()
            .child('feed-images')
            .child('${post.postId}.jpg');
        // print("Reference of storage $ref");
        await ref.putFile(io.File(file.path));

        final url = await ref.getDownloadURL();
        post.imageUrl = url;
      }
      print("here 1");
      var docref = FirebaseFirestore.instance.collection('posts').doc();
      post.postId = docref.id;
      docref.set(post.toJson()).then((_) {
        showSimpleNotification(
          const Text('Added successfully'),
          background: Palette.green.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          slideDismissDirection: DismissDirection.horizontal,
        );
      });
      print("here2");
      return true;
    } catch (error) {
      if (error is FirebaseException) {
        showSimpleNotification(
          Text('Error'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          slideDismissDirection: DismissDirection.horizontal,
        );
      } else {
        showSimpleNotification(
          Text("Unknown Error"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          slideDismissDirection: DismissDirection.horizontal,
        );
      }
      return false;
    }
  }
}

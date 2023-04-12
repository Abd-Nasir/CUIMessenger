import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/feed/model/post.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io' as io;

class PostProvider {
  PostProvider();

  // Static instance to access api without initialization
  static PostProvider instance = PostProvider();

  // List<Report> reports = List.empty(growable: true);

  Future<void> loadData() async {
    try {
      // await Api.instance.loadReports().then((value) {
      //   reports = value;
      // });
    } catch (error) {
      debugPrint("error loading Reports from database.\nError:\n$error");
    }
  }

  Future<bool> saveReport(Post post, XFile? file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${post.postId}.jpg');
      print("Reference of storage $ref");
      await ref.putFile(io.File(file!.path));

      final url = await ref.getDownloadURL();
      // userData['imageUrl'] = url;
      // userData["uid"] = userCredential.user!.uid;
      // print("Image URL: ${userData["imageUrl"]}");
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(userCredential.user!.uid)
          .set(userData);
      print("Completely registered");
      if (userCredential.user != null) {
        final userData = getUserData(userCredential: userCredential);
        return userData;
      }
      if (response["success"]) {
        showSimpleNotification(
          Text("Success"),
          background: Palette.green.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          slideDismissDirection: DismissDirection.horizontal,
        );
        return true;
      } else {
        showSimpleNotification(
          Text("Adding failed"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
          slideDismissDirection: DismissDirection.horizontal,
        );
        return false;
      }
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

import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
// import 'package:safepall/screens/authentication/model/user.dart';
// import 'package:safepall/helpers/api/api.dart';
import '/helpers/style/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  // late SharedPreferences preferences;
  User? currentUser;
  String code = "";
  String userPhone = "";
  String forgotPassword = "null";
  AuthProvider({this.currentUser});

  Future<User?> logInWithEmail({
    required String email,
    required String password,
  }) async {
    // return await Api.instance
    //     .loginWithMail(email: email, password: password)
    //     .then((value) {
    //   if (value != null) {
    //     currentUser = value;
    //     saveUser();
    //     return currentUser;
    //   } else {
    //     return null;
    //   }
    // });

    // Sign in with Email - Using Firebase:
    try {
      fb.UserCredential userCredential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      print("Error Occured in login: $error");
      rethrow;
    }
  }

  Future<User?> registerWithEmail(
      Map<String, dynamic> userData, XFile file) async {
    try {
      fb.UserCredential userCredential = await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userData['email'], password: userData['password']);
    } catch (error) {}

    Future<bool> uploadProfilePicture(XFile file, String userId) async {
      try {
        // var response = await Api.instance.uploadProfilePicture(file, userId);
        // return response["success"];
        return false;
      } catch (error) {
        return false;
      }
    }

    // Future<bool> updateUserPassword({required String password}) async {
    //   try {
    //     bool value = await Api.instance
    //         .updateUserPassword(password: password, phone: userPhone);
    //     return value;
    //   } catch (error) {
    //     return false;
    //   }
    // }

    // Future<bool> updateUserData(
    //     {required String userid,
    //     required Map<String, dynamic> dataChanged,
    //     required XFile? file,
    //     required String? oldImageKey}) async {
    //   try {
    //     Map<String, dynamic> response = await Api.instance.updateUserData(
    //         userid: userid,
    //         dataChanged: dataChanged,
    //         file: file,
    //         oldImageKey: oldImageKey);
    //     if (response["success"]) {
    //       currentUser!.address = dataChanged["address"];
    //       currentUser!.firstName = dataChanged["first-name"];
    //       currentUser!.lastName = dataChanged["last-name"];
    //       currentUser!.phoneNumber = dataChanged["phone"];
    //       if (response["image-upload"]["success"] != null) {
    //         if (response['image-upload']['success']) {
    //           currentUser!.imageKey = response["image-upload"]["key"];
    //           var res =
    //               await Api.instance.getImageByKey(currentUser!.imageKey, userid);
    //           currentUser!.profilePicture = res["url"];
    //         }
    //       }
    //       saveUser();
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } catch (error) {
    //     print("Error occured in updating user data:\n$error");
    //     return false;
    //   }
    // }

    // Future<bool> refreshUser() async {
    //   try {
    //     User? res = await Api.instance
    //         .getUserWithUID(fb.FirebaseAuth.instance.currentUser!.uid);
    //     if (res != null) {
    //       currentUser = res;
    //       String token = await FirebaseMessaging.instance.getToken() as String;
    //       print("Device Token: $token");
    //       await Api.instance.addDevice(
    //         fb.FirebaseAuth.instance.currentUser!.uid,
    //         token,
    //       );
    //       await saveUser();
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } catch (error) {
    //     print("error in refreshing user!\n$error");
    //     return false;
    //   }
    // }

    Future<void> logOut(String deviceId) async {
      // bool res = await Api.instance.logOut(deviceId);
      return;
    }

    Future<bool> deleteAccount(String email) async {
      // bool res = await Api.instance.deleteUserAccount(email);
      return false;
    }
  }
}

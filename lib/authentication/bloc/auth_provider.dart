import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import '/helpers/style/colors.dart';

class AuthProvider {
  // late SharedPreferences preferences;
  fb.User? currentUser;
  UserData? userData;
  String code = "";
  String userPhone = "";
  String forgotPassword = "null";
  String userImageUrl = "";

  Future<void> initialize() async {
    currentUser = fb.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('registered-users')
          // .where('username', isEqualTo: searchController.text)
          .get()
          .then((value) {
        for (var user in value.docs) {
          if (user.data()["uid"] == currentUser!.uid) {
            print("This is user \n\n ${user.data()}\n");
            userData = UserData.fromJson(user.data());
            print("This is email ${userData!.email}");
          }
        }
      });
    }
    return;
    //await _storage.read(key: 'CurrentUser').then((value) async {
    //  if (value != null) {
    //    print("value = $value");

    //  currentUser = User.fromJson(jsonDecode(value));
    //  }
    //});
  }

  getUserData({required fb.UserCredential userCredential}) async {
    if (userCredential.user != null) {
      // return userCredential.user;
      await FirebaseFirestore.instance
          .collection('registered-users')
          // .where('username', isEqualTo: searchController.text)
          .get()
          .then((value) {
        value.docs.forEach((user) {
          if (user.data()["uid"] == userCredential.user!.uid) {
            print("This is user \n\n ${user.data()}\n");
            userData = UserData.fromJson(user.data());
            print("This is email ${userData!.email}");
          }
        });
      });
      return userData;
    }
  }
  // Future<String?> imageUrl() async {
  //   FirebaseFirestore.instance
  //       .collection('registered-users')
  //       // .where('username', isEqualTo: searchController.text)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((users) {
  //       if (users.data()["uid"] == fb.FirebaseAuth.instance.currentUser!.uid) {
  //         userImageUrl = users.data()['imageUrl'];
  //         print("userImageUrl ${userImageUrl}");
  //       }
  //     });
  //   });
  //   return userImageUrl;
  // }

  Future<UserData?> studentLogin({
    required String email,
    required String password,
  }) async {
    try {
      fb.UserCredential userCredential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // return userCredential.user;
        await FirebaseFirestore.instance
            .collection('registered-users')
            // .where('username', isEqualTo: searchController.text)
            .get()
            .then((value) {
          value.docs.forEach((user) {
            if (user.data()["uid"] == userCredential.user!.uid) {
              print("This is user \n\n ${user.data()}\n");
              userData = UserData.fromJson(user.data());
              print("This is email ${userData!.email}");
            }
          });
        });
        return userData;
      }
      return null;
      // print(response);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Invalid Email"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'user-not-found') {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("User not found,\n Try again or Register"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'wrong-password') {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Incorrect password!, try again"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please check your internet connection"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      }
    }
    return null;
  }

  Future<UserData?> teacherLogin({
    required String email,
    required String password,
  }) async {
    try {
      fb.UserCredential userCredential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // return userCredential.user;
        await FirebaseFirestore.instance
            .collection('registered-users')
            // .where('username', isEqualTo: searchController.text)
            .get()
            .then((value) {
          value.docs.forEach((user) {
            if (user.data()["uid"] == userCredential.user!.uid) {
              print("This is user \n\n ${user.data()}\n");
              userData = UserData.fromJson(user.data());
              print("This is email ${userData!.email}");
            }
          });
        });
        return userData;
      }
      return null;
      // print(response);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Invalid Email"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'user-not-found') {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("User not found,\n Try again or Register"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'wrong-password') {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Incorrect password!, try again"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please check your internet connection"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      }
    }
    return null;
  }

  Future<UserData?> registerStudentWithEmail(
      Map<String, dynamic> userData, XFile? file) async {
    try {
      final auth = fb.FirebaseAuth.instance;
      fb.UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: userData['email'], password: userData['password']);
      print("Registered email password");

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${userCredential.user!.uid}.jpg');
      print("Reference of storage $ref");
      await ref.putFile(io.File(file!.path));

      final url = await ref.getDownloadURL();
      userData['imageUrl'] = url;
      userData["uid"] = userCredential.user!.uid;
      print("Image URL: ${userData["imageUrl"]}");
      await FirebaseFirestore.instance
          .collection('registered-users')
          .doc(userCredential.user!.uid)
          .set(userData);
      print("Completely registered");
      if (userCredential.user != null) {
        final userData = getUserData(userCredential: userCredential);
        return userData;
      }
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("The password provided is too weak."),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The account already exists for that email.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('The account already exists for that email.');
      } else if (e.code == 'operation-not-allowed') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('There is a problem with auth service config :/'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('There is a problem with auth service config :/');
      } else if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please type stronger password"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('Please type stronger password');
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          Text("Auth Error + ${e}"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('auth error ' + e.toString());
        rethrow;
      }
    }
    return null;
  }

  Future<UserData?> registerFacultyWithEmail(
      Map<String, dynamic> userData, XFile? file) async {
    try {
      bool isRegistered = false;
      print("Email:==== ${userData["email"]}");
      final auth = fb.FirebaseAuth.instance;
      final userRef = FirebaseFirestore.instance
          .collection("registeredFacultyEmails")
          .doc(userData["email"]);

      await userRef.get().then((docSnapshot) => {
            if (docSnapshot.exists)
              {isRegistered = true, print(docSnapshot.exists)}
            // print("User is there $isRegistered")
          });
      print("is registered $isRegistered");
      if (isRegistered == true) {
        fb.UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: userData['email'], password: userData['password']);
        print("Registered email password");

        final ref = FirebaseStorage.instance
            .ref()
            .child('faculty_images')
            .child('${userCredential.user!.uid}.jpg');
        print("Reference of storage $ref");
        await ref.putFile(io.File(file!.path));

        final url = await ref.getDownloadURL();
        userData['imageUrl'] = url;
        userData["uid"] = userCredential.user!.uid;
        print("Image URL: ${userData["imageUrl"]}");
        await FirebaseFirestore.instance
            .collection('registered-users')
            .doc(userCredential.user!.uid)
            .set(userData);
        print("Completely registered");
        if (userCredential.user != null) {
          final userData = getUserData(userCredential: userCredential);
          return userData;
        }
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please ask the concerns to register your email"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      }
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("The password provided is too weak."),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The account already exists for that email.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('The account already exists for that email.');
      } else if (e.code == 'operation-not-allowed') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('There is a problem with auth service config :/'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('There is a problem with auth service config :/');
      } else if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please type stronger password"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('Please type stronger password');
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          Text("Auth Error + ${e}"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
        print('auth error ' + e.toString());
        rethrow;
      }
    }
    return null;
  }

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

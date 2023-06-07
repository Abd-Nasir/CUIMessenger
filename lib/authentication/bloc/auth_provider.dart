import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
// import '../model/user.dart';
import '/helpers/style/colors.dart';

class AuthProvider {
  // late SharedPreferences preferences;
  fb.User? currentUser;
  UserModel? userData;
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
            userData = UserModel.fromJson(user.data());
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

  Future<UserModel?> getUserData(
      {required fb.UserCredential userCredential}) async {
    if (userCredential.user != null) {
      // return userCredential.user;
      await FirebaseFirestore.instance
          .collection('registered-users')
          // .where('username', isEqualTo: searchController.text)
          .get()
          .then((value) {
        for (var user in value.docs) {
          if (user.data()["uid"] == userCredential.user!.uid) {
            // print("This is user \n\n ${user.data()}\n");
            userData = UserModel.fromJson(user.data());
            // print("This is email ${userData!.email}");
          }
        }
      });
      return userData;
    }
    return null;
  }

  Future<UserModel?> studentLogin({
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
          for (var user in value.docs) {
            if (user.data()["uid"] == userCredential.user!.uid) {
              // print("This is user \n\n ${user.data()}\n");
              userData = UserModel.fromJson(user.data());
              // print("This is email ${userData!.email}");
            }
          }
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
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("User not found,\n Try again or Register"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'wrong-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Incorrect password!, try again"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
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

  Future<UserModel?> teacherLogin({
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
            .get()
            .then((value) {
          for (var user in value.docs) {
            if (user.data()["uid"] == userCredential.user!.uid) {
              // print("This is user \n\n ${user.data()}\n");
              userData = UserModel.fromJson(user.data());
              // print("This is email ${userData!.email}");
            }
          }
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
        // print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("User not found,\n Try again or Register"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'wrong-password') {
        // print(e.code);
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Incorrect password!, try again"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        // print(e.code);
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

  Future<UserModel?> registerStudentWithEmail(
      UserModel userData, XFile? file, String password) async {
    try {
      final auth = fb.FirebaseAuth.instance;
      fb.UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: userData.email, password: password);

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${userCredential.user!.uid}.jpg');
      await ref.putFile(io.File(file!.path));

      final url = await ref.getDownloadURL();
      userData.profilePicture = url;
      userData.uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('registered-users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());

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
      } else if (e.code == 'email-already-in-use') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The account already exists for that email.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'operation-not-allowed') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('There is a problem with auth service config :/'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please type stronger password"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          Text("Auth Error + $e"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );

        rethrow;
      }
    }
    return null;
  }

  Future<UserModel?> registerFacultyWithEmail(
      UserModel userData, XFile? file, String password) async {
    try {
      bool isRegistered = false;

      final auth = fb.FirebaseAuth.instance;
      final userRef = FirebaseFirestore.instance
          .collection("registeredFacultyEmails")
          .doc(userData.email);

      await userRef.get().then((docSnapshot) => {
            if (docSnapshot.exists)
              {
                isRegistered = true,
              }
            // print("User is there $isRegistered")
          });

      if (isRegistered == true) {
        fb.UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: userData.email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('faculty_images')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(io.File(file!.path));

        final url = await ref.getDownloadURL();
        userData.profilePicture = url;
        userData.uid = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('registered-users')
            .doc(userCredential.user!.uid)
            .set(userData.toJson());

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
      } else if (e.code == 'email-already-in-use') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The account already exists for that email.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'operation-not-allowed') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('There is a problem with auth service config :/'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text("Please type stronger password"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          Text("Auth Error + $e"),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );

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

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;

    // Create a credential with the user's email and old password
    final credential = EmailAuthProvider.credential(
      email: user!.email.toString(),
      password: oldPassword,
    );
    try {
      // Re-authenticate the user with the credential
      await user.reauthenticateWithCredential(credential);

      // Change the user's password
      updatePassword(newPassword);
      // Password change successful
      print('Password updated successfully!');
      RouteGenerator.navigatorKey.currentState!.pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The provided password is incorrect.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );

        // Handle incorrect password error
      } else {
        // Handle other errors
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('Something went wrong'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      showSimpleNotification(
        slideDismissDirection: DismissDirection.horizontal,
        const Text('Something went wrong'),
        background: Palette.red.withOpacity(0.9),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await user!.updatePassword(newPassword);

      // print('Password changed successfully');

      showSimpleNotification(
        slideDismissDirection: DismissDirection.horizontal,
        const Text('Password changed successfully'),
        background: Palette.green.withOpacity(0.9),
        duration: const Duration(seconds: 2),
      );
      // _currentPasswordController.text = '';
      // _newPasswordController.text = '';
      // _repeatPasswordController.text = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('The password provided is too weak.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else if (e.code == 'requires-recent-login') {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text(
              'This operation is sensitive and requires recent authentication. Log in again before retrying this request.'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      } else {
        showSimpleNotification(
          slideDismissDirection: DismissDirection.horizontal,
          const Text('Something went wrong'),
          background: Palette.red.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      showSimpleNotification(
        slideDismissDirection: DismissDirection.horizontal,
        const Text('Something went wrong'),
        background: Palette.red.withOpacity(0.9),
        duration: const Duration(seconds: 2),
      );
    }
  }
}

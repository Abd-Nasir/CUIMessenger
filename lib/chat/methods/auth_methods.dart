import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/chat/constants/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = firebaseAuth;
  final FirebaseFirestore _fireStore = firebaseFirestore;
  Future<String> deleteAccount() async {
    //deleting the user information from the database than delete
    try {
      await _fireStore
          .collection('registered-users')
          .doc(_firebaseAuth.currentUser!.uid)
          .delete();
      await _firebaseAuth.currentUser!.delete();

      return 'success';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> resetPassword({required String email}) async {
    String result = "";
    await firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => result = "sent")
        .catchError((e) => result = e.toString());
    return result;
  }

  // Future<String> changePassword({required String pass}) async {
  //   String result = "";
  //   await firebaseAuth.currentUser!
  //       .updatePassword(pass)
  //       .then((value) => result = "done")
  //       .catchError((e) => result = e.toString());
  //   return result;
  // }
}

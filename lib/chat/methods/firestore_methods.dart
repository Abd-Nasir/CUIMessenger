import 'package:cui_messenger/chat/constants/constants.dart';

import 'package:cui_messenger/authentication/model/user_model.dart';

class FirestoreMethods {
  void setUserStateCall(bool isInCall) async {
    await firebaseFirestore
        .collection('registered-users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'isInCall': isInCall,
    });
  }

  // //adding a record
  // Future<String> addRecord(String name, RecordsModel model) async {
  //   String res = "Some error occurred";
  //   try {
  //     //if the fields are not empty than registering the user
  //     await firebaseFirestore
  //         .collection("users")
  //         .doc(firebaseAuth.currentUser!.uid)
  //         .collection("records")
  //         .doc(name)
  //         .set(model.toJson());
  //     res = "Success";
  //   } on FirebaseAuthException catch (err) {
  //     res = err.message.toString();
  //   }
  //   return res;
  // }

  // //getting records of user
  // Future getRecords() async {
  //   try {
  //     //if the fields are not empty than registering the user
  //     return await firebaseFirestore
  //         .collection("users")
  //         .doc(firebaseAuth.currentUser!.uid)
  //         // .doc("NzmMDTyLPBXm6WMG03TQTwPBsub2")
  //         .collection("records")
  //         .get();
  //   } on FirebaseAuthException catch (err) {
  //     return err;
  //   }
  // }

  // //getting records of user
  // Future<String> deleteRecord(String recordId) async {
  //   String res = "Some error occurred";

  //   try {
  //     //if the fields are not empty than registering the user
  //     await firebaseFirestore
  //         .collection("users")
  //         .doc(firebaseAuth.currentUser!.uid)
  //         // .doc("NzmMDTyLPBXm6WMG03TQTwPBsub2")
  //         .collection("records")
  //         .doc(recordId)
  //         .delete()
  //         .then((value) => res = "Success");
  //   } on FirebaseAuthException catch (err) {
  //     return err.message.toString();
  //   }
  //   return res;
  // }

  // Future<String> getRecordNumber() async {
  //   int num = 0;
  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .collection("records")
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       int temp = int.parse(element.id);
  //       if (num < temp) {
  //         num = temp;
  //       }
  //     });
  //     num++;
  //   });
  //   return num.toString();
  // }

//adding the image url to firestore
  Future<String> addPhotoToFirestore({
    required String url,
  }) async {
    String res = "Some error occurred";
    try {
      //if the fields are not empty than registering the user
      if (url.isNotEmpty) {
        firebaseFirestore
            .collection("registered-users")
            .doc(firebaseAuth.currentUser?.uid)
            .update({
          'photoUrl': url,
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //adding the image url to firestore
  Future<String> updateProfile({
    required String name,
    required String contact,
    required String bio,
    required String loc,
  }) async {
    String res = "Some error occurred";
    try {
      //if the fields are not empty than registering the user
      {
        firebaseFirestore
            .collection("registered-users")
            .doc(firebaseAuth.currentUser?.uid)
            .update({
          'name': name,
          'contact': contact,
          'bio': bio,
          'location': loc,
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //searching the user in the database
  Future<String> searchUser({
    required String text,
  }) async {
    String res = "Some error occurred";
    // try {
    //   //if the fields are not empty than registering the user
    //   if (email.isNotEmpty && password.isNotEmpty) {
    //     UserCredential credential = await _firebaseAuth
    //         .createUserWithEmailAndPassword(email: email, password: password);
    //     UserModel user = UserModel(
    //       uid: credential.user!.uid,
    //       username: username.trim(),
    //       email: email.trim(),
    //       photoUrl: "",
    //       bio: "",
    //       contact: "",
    //       location: "",
    //       isOnline: false,
    //       blockList: [],
    //       contacts: [],
    //     );
    //     await _fireStore
    //         .collection("users")
    //         .doc(credential.user!.uid)
    //         .set(user.toJson());
    //     res = "Success";
    //   }
    // } on FirebaseAuthException catch (err) {
    //   res = err.message.toString();
    // }
    return res;
  }

  //get online status
  Future<UserModel> getUserInformationOther(String receiverId) async {
    return await firebaseFirestore
        .collection('registered-users')
        .doc(receiverId)
        .get()
        .then((event) {
      return UserModel.getValuesFromSnap(event);
    });
  }
}

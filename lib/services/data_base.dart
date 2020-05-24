import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/models/user.dart';

Future<void> showCostumeFireBaseErrorNotif(String title) async {
  //this func. will show in-app notification if there is no internet
  await Future.delayed(const Duration(seconds: 1));
  BotToast.showNotification(
    title: (child) {
      return Container(
        child: Text(
          title,
          textAlign: TextAlign.center,
          // textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    },
    duration: const Duration(seconds: 5),
  );
  await Future.delayed(const Duration(seconds: 2));
}

Future<bool> connected() async {
  //This will check if there is an internet connection
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  CollectionReference usersCollection = Firestore.instance.collection('users');

  CollectionReference postsCollection = Firestore.instance.collection('Posts');

// family functions
  Future updateUserData(User user) async {
    //this can be used to add new family or update an exsisting one
    if (await connected()) {
      await usersCollection.document(uid).setData(user.toMap());
    } else {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
    }
  }

  Future<String> getEmailByUsername(String username) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    var querySnapshot = await DatabaseService('')
        .usersCollection
        .where('user_name', isEqualTo: username)
        .snapshots()
        .first;

    var email = querySnapshot.documents.first.data['email'];

    return email;
  }

  Future<bool> checkUserNameExcist(String userName) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    var snap = await usersCollection
        .where('user_name', isEqualTo: userName)
        .getDocuments();
    if (snap.documents.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<bool> checkEmailExcist(String email) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    var snap =
        await usersCollection.where('email', isEqualTo: email).getDocuments();
    if (snap.documents.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<User> getUserData() async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }

    final userDoc = await usersCollection.document(uid).get();
    final user = User.fromDocument(userDoc, userDoc.documentID);
    return user;
  }

  Future deleteUser() async {
    //this can be used to delete family and only can be used by the admin
    await usersCollection.document(uid).delete();
  }

  // List<Family> _familiesListFromSnapshot(QuerySnapshot snap) {
  //   return snap.documents.map((doc) {
  //     return Family.fromDocument(doc, doc.documentID);
  //   }).toList();
  // }

  // Family _familyDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return Family.fromDocument(snapshot, uid);
  // }

  // Stream<List<Family>> get families {
  //   return usersCollection.snapshots().map(_familiesListFromSnapshot);
  // }

  // Stream<Family> get familyData {
  //   return usersCollection
  //       .document(uid)
  //       .snapshots()
  //       .map(_familyDataFromSnapshot);
  // }

  Future uploadPic(BuildContext context, File image) async {
    String fileName = 'userphoto'; //TODO: get username
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot.error == null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await Firestore.instance
          .collection("images")
          .add({"url": downloadUrl, "name": 'userName'}); //TODO: get username
      final snackBar = SnackBar(content: Text('Yay! Success'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('error')));
    }
  }
}

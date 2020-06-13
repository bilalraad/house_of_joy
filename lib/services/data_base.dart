import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../models/user.dart';

///this func will show [notification-like popup] or [top snakbar] inside the app without the context
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
  try {
    final result = await InternetAddress.lookup('google.com');
    //the first [if] will check if the device is connected to wifi or mobile data
    //but it dosen't check if there is internet or not(i.e. you nay have connection but you cant browse any thing)
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //this will check the actual intenet connection
      if (await DataConnectionChecker().hasConnection) {
        // 'connected';
        return true;
      } else {
        return false;
      }
    }
  } catch (_) {
    // 'not connected';
    return false;
  }
  return false;
}

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  CollectionReference usersCollection = Firestore.instance.collection('users');

  ///this func. can be used to add new user or update an exsisting one
  Future updateUserData(User user) async {
    if (await connected()) {
      await usersCollection.document(uid).setData(user.toMap());
    } else {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
    }
  }

  List<Activity> _activitiesListFromSnapshot(DocumentSnapshot doc) {
    return List<Activity>.from(
        doc.data['activities']?.map((x) => Activity.fromMap(x)));
  }

  Stream<List<Activity>> get activities {
    return usersCollection
        .document(uid)
        .snapshots()
        .map(_activitiesListFromSnapshot);
  }

  ///this func. can be used to add new activity or update an exsisting one
  Future<void> updateUserActivities(Activity activity) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    final postowner = await getUserData();
    await usersCollection.document(uid).updateData({
      'activities':
          (postowner.activities..add(activity)).map((e) => e.toMap()).toList()
    });
  }

  ///if the user deleted a post this will delete all the activities that connected to that post
  Future<void> deletePostActivities(String postId) async {
    final postowner = await getCurrentUserData();
    await usersCollection.document(postowner.uid).updateData({
      'activities': (postowner.activities
            ..removeWhere((element) => element.postId == postId))
          .map((e) => e.toMap())
          .toList()
    });
  }

  ///this will mark all the activities as readed when the user enter the activities tab
  Future<void> markAllActivitiesAsReaded() async {
    if (await connected()) {
      final postowner = await getUserData();
      var updatedActivities = <Activity>[];
      if (postowner.activities.length >= 6) {
        for (var i = 6; i < postowner.activities.length; i++) {
          if (postowner.activities[i].isReaded) {
            postowner.activities.remove(postowner.activities[i - 6]);
          }
        }
      }
      for (var i in postowner.activities) {
        updatedActivities.add(i.copyWith(isReaded: true));
      }

      await usersCollection.document(uid).updateData(
          {'activities': (updatedActivities.map((e) => e.toMap()).toList())});
    }
  }

  Future<String> getEmailByUsername(String username) async {
    if (!await connected()) {
      return null;
    }
    final querySnapshot = await DatabaseService('')
        .usersCollection
        .where('userName', isEqualTo: username)
        .snapshots()
        .first;

    final documents = querySnapshot.documents;

    final email = documents.isNotEmpty ? documents.first.data['email'] : null;

    return email;
  }

  Future<bool> checkUserNameExcist(String userName) async {
    if (!await connected()) {
      return false;
    }
    final snap = await usersCollection
        .where('userName', isEqualTo: userName)
        .getDocuments();
    if (snap.documents.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<bool> checkEmailExcist(String email) async {
    if (!await connected()) {
      return false;
    }
    final snap =
        await usersCollection.where('email', isEqualTo: email).getDocuments();
    if (snap.documents.isNotEmpty) {
      return true;
    }

    return false;
  }

  ///get user data that is currently using the app
  Future<User> getCurrentUserData() async {
    if (!await connected()) {
      return null;
    }
    final firebaseuser = await FirebaseAuth.instance.onAuthStateChanged.first;
    if (firebaseuser == null) return null;
    final userDoc = await usersCollection.document(firebaseuser.uid).get();
    final user = User.fromDocument(userDoc, userDoc.documentID);
    return user;
  }

  Future deleteUser() async {
    //this can be used to delete user and only can be used by the admin
    await usersCollection.document(uid).delete();
  }

  ///get any user data by giving his Id
  Future<User> getUserData() async {
    if (uid == null) return null;
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    final userDoc = await usersCollection.document(uid).get();
    final user = User.fromDocument(userDoc, userDoc.documentID);
    return user;
  }

  ///this function is used to upload profile picture
  Future<String> uploadPic(File image, {String fileName}) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }

    if (uid.isNotEmpty) fileName = uid;
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = firebaseStorageRef.putFile(image);
    final taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot.error == null) {
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      await Firestore.instance
          .collection("images")
          .add({"url": imageUrl, "name": fileName});

      return imageUrl;
    } else {
      return null;
    }
  }
  ///this function is used to upload post pictures
  Future<dynamic> postImageToFireBase(Asset imageFile) async {
    if (!await connected()) {
      return null;
    }
    final imageData = await imageFile.getByteData();
    final fileName = '$uid${imageFile.name}';
    final reference = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putData(imageData.buffer.asUint8List());
    final storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}

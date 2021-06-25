import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../models/user.dart';

///this func will show [notification-like popup] or [top snakbar] inside the app without the context
Future<void> showCostumeFireBaseErrorNotif(String title) async {
  //this func. will show in-app notification if there is no internet
  await Future.delayed(const Duration(seconds: 1));
  BotToast.showNotification(
    title: (child) {
      return Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    },
    duration: const Duration(seconds: 5),
  );
  await Future.delayed(const Duration(seconds: 2));
}

///To check the internet connection and data connection
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

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference get userActivtiesReference {
    return usersCollection.doc(uid).collection('userActivities');
  }

  ///this func. can be used to add new user or update an exsisting one
  Future updateUserData(UserModel user) async {
    if (await connected()) {
      await usersCollection.doc(uid).set(user.toMap());
    } else {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
    }
  }

  List<Activity> _activitiesListFromSnapshot(QuerySnapshot querySnapshot) {
    if (querySnapshot.docs == null) return null;
    var activities = <Activity>[];
    querySnapshot?.docs?.forEach(
        (element) => activities.add(Activity.fromMap(element.data())));
    return activities;
  }

  Stream<List<Activity>> get activities {
    return userActivtiesReference.snapshots().map(_activitiesListFromSnapshot);
  }

  ///this func. can be used to add new activity or update an exsisting one
  Future<void> updateUserActivities(Activity activity) async {
    if (!await connected()) {
      return null;
    }
    userActivtiesReference.doc().set(activity.toMap());
  }

  ///this will mark all the activities as readed when the user enter the activities tab
  Future<void> markAllActivitiesAsReaded() async {
    if (await connected()) {
      await userActivtiesReference
          .get()
          .then((value) => value.docs.forEach((element) {
                if (!element['isReaded']) {
                  userActivtiesReference
                      .doc(element.id)
                      .update({'isReaded': true});
                }
              }));
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

    final documents = querySnapshot.docs;

    final email = documents.isNotEmpty ? documents.first['email'] : null;

    return email;
  }

  Future<bool> checkUserNameExcist(String userName) async {
    if (!await connected()) {
      return false;
    }
    final snap =
        await usersCollection.where('userName', isEqualTo: userName).get();
    if (snap.docs.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<bool> checkEmailExcist(String email) async {
    if (!await connected()) {
      return false;
    }
    final snap = await usersCollection.where('email', isEqualTo: email).get();
    if (snap.docs.isNotEmpty) {
      return true;
    }

    return false;
  }

  ///get user data that is currently using the app
  Future<UserModel> getCurrentUserData() async {
    if (!await connected()) {
      return null;
    }
    final firebaseuser = await FirebaseAuth.instance.authStateChanges().first;
    if (firebaseuser == null) return null;
    final userDoc = await usersCollection.doc(firebaseuser.uid).get();
    final user = UserModel.fromDocument(userDoc);
    return user;
  }

  Future deleteUser() async {
    //this can be used to delete user and only can be used by the admin
    await usersCollection.doc(uid).delete();
  }

  ///get any user data by giving his Id
  Future<UserModel> getUserData() async {
    if (uid == null) return null;
    if (!await connected()) {
      return null;
    }
    final userDoc = await usersCollection.doc(uid).get();
    final user = UserModel.fromDocument(userDoc);
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
    try {
      await firebaseStorageRef.putFile(image);
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("images")
          .add({"url": imageUrl, "name": fileName});

      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  ///this function is used to upload post pictures
  Future<String> postImageToFireBase(Asset imageFile) async {
    var randomInt = Random();
    if (!await connected()) {
      return null;
    }
    final imageData = await imageFile.getByteData(quality: 70);
    final fileName = '$uid${imageFile.name}${randomInt.nextInt(100)}';
    final reference = FirebaseStorage.instance.ref().child(fileName);
    try {
      await reference.putData(imageData.buffer.asUint8List());
      return await reference.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}

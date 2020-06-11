import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (await DataConnectionChecker().hasConnection) {
        print('connected');
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    }
  } catch (_) {
    print('not connected');
    return false;
  }
  return false;
}

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  CollectionReference usersCollection = Firestore.instance.collection('users');

// family functions
  Future updateUserData(User user) async {
    //this can be used to add new family or update an exsisting one
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

  Future<void> updateUserActivities(Activity activity) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    var postowner = await getUserData();
    print(postowner.uid);
    await usersCollection.document(uid).updateData({
      'activities':
          (postowner.activities..add(activity)).map((e) => e.toMap()).toList()
    });
  }

  Future<void> markAllActivitiesAsReaded() async {
    if (await connected()) {
      var postowner = await getUserData();
      List<Activity> updatedActivities = [];
      if (postowner.activities.length >= 6) {
        for (var i = 6; i < postowner.activities.length; i++) {
          if (postowner.activities[i].isReaded)
            postowner.activities.remove(postowner.activities[i - 6]);
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
    var querySnapshot = await DatabaseService('')
        .usersCollection
        .where('userName', isEqualTo: username)
        .snapshots()
        .first;

    var documents = querySnapshot.documents;

    var email = documents.isNotEmpty ? documents.first.data['email'] : null;

    return email;
  }

  Future<bool> checkUserNameExcist(String userName) async {
    if (!await connected()) {
      return false;
    }
    var snap = await usersCollection
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
    var snap =
        await usersCollection.where('email', isEqualTo: email).getDocuments();
    if (snap.documents.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<User> getCurrentUserData() async {
    if (!await connected()) {
      return null;
    }
    final firebaseuser = await FirebaseAuth.instance.onAuthStateChanged.first;
    // print(firebaseuser.uid);

    if (firebaseuser == null) return null;
    final userDoc = await usersCollection.document(firebaseuser.uid).get();
    final user = User.fromDocument(userDoc, userDoc.documentID);
    return user;
  }

  Future deleteUser() async {
    //this can be used to delete user and only can be used by the admin
    await usersCollection.document(uid).delete();
  }

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

  Future<String> uploadPic(File image, {String fileName}) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }

    if (uid.isNotEmpty) fileName = uid;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
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

  Future<dynamic> postImageToFireBase(Asset imageFile) async {
    if (!await connected()) {
      print('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    var imageData = await imageFile.getByteData();
    String fileName = '$uid${imageFile.name}';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putData(imageData.buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}

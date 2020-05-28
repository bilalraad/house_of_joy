import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  final String phoneNo;
  final String fullName;
  final String email;
  final String userName;
  final String imageUrl;
  final List<String> postIds;

  User({
    @required this.uid,
    this.phoneNo = '',
    @required this.fullName,
    @required this.email,
    this.userName,
    this.imageUrl = '',
    this.postIds = const [],
  });

  User copyWith({
    String uid,
    String phoneNo,
    String fullName,
    String email,
    String userName,
    String imageUrl,
    List<String> postIds,
  }) {
    return User(
      uid: uid ?? this.uid,
      phoneNo: phoneNo ?? this.phoneNo,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      imageUrl: imageUrl ?? this.imageUrl,
      postIds: postIds ?? this.postIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNo': phoneNo,
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'imageUrl': imageUrl,
      'postIds': postIds,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc, String uid) {
    if (doc.data == null) return null;
    return User(
        uid: uid,
        phoneNo: doc['phoneNo'],
        fullName: doc['fullName'],
        userName: doc['userName'],
        email: doc['email'],
        imageUrl: doc['imageUrl'],
        postIds: List<String>.from(doc['postIds']));
  }

  @override
  String toString() {
    return 'User(uid: $uid, phoneNo: $phoneNo, fullName: $fullName, email: $email, userName: $userName, imageUrl: $imageUrl, postIds: $postIds)';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  final String phoneNo;
  final String fullName;
  final String email;
  final String userName;
  final String imageUrl;

  User({
    @required this.uid,
    this.phoneNo = '',
    @required this.fullName,
    @required this.email,
    this.userName,
    this.imageUrl = '',
  });

  @override
  String toString() => 'User(uid: $uid)';

  User copyWith({
    String uid,
    String phoneNo,
    String fullName,
    String email,
    String userName,
    String imageUrl,
  }) {
    return User(
      uid: uid ?? this.uid,
      phoneNo: phoneNo ?? this.phoneNo,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNo': this.phoneNo,
      'full_name': this.fullName,
      'user_name': this.userName,
      'email': this.email,
      'imageUrl': this.imageUrl,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc, String uid) {
    if (doc == null) return null;
    return User(
      uid: uid,
      phoneNo: doc['phoneNo'],
      fullName: doc['full_name'],
      userName: doc['user_name'],
      email: doc['email'],
      imageUrl: doc['imageUrl'],
    );
  }
}

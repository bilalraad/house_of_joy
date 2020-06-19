import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String phoneNo;
  final String fullName;
  final String email;
  final String userName;
  final String imageUrl;

  User({
    @required this.uid,
    @required this.phoneNo,
    @required this.fullName,
    @required this.email,
    this.userName,
    this.imageUrl = '',
  });

  User copyWith({
    String uid,
    String phoneNo,
    String fullName,
    String email,
    String userName,
    String imageUrl,
    List<Activity> activities,
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
      'uid': uid,
      'phoneNo': phoneNo,
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'imageUrl': imageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var user = User(
      uid: map['uid'],
      phoneNo: map['phoneNo'],
      fullName: map['fullName'],
      userName: map['userName'],
      email: map['email'],
      imageUrl: map['imageUrl'],
    );
    return user;
  }

  @override
  String toString() {
    return 'User(uid: $uid, phoneNo: $phoneNo, fullName: $fullName, email: $email, userName: $userName, imageUrl: $imageUrl)';
  }

  factory User.fromDocument(DocumentSnapshot doc, String uid) {
    if (doc.data == null) return null;
    return User(
      uid: uid,
      phoneNo: doc.data['phoneNo'],
      fullName: doc.data['fullName'],
      email: doc.data['email'],
      userName: doc.data['userName'],
      imageUrl: doc.data['imageUrl'],
    );
  }
}

class Activity {
  final bool isReaded;
  final bool isLike; //if false then its comment
  final String postId;
  final String userId;
  final DateTime activityTime;

  Activity({
    @required this.userId,
    this.isReaded = false,
    this.activityTime,
    @required this.isLike,
    @required this.postId,
  });

  Activity copyWith({
    bool isReaded,
    bool isLike,
    String postId,
    String userImageUrl,
    String userName,
    String userId,
    String activityTime,
  }) {
    return Activity(
      isReaded: isReaded ?? this.isReaded,
      isLike: isLike ?? this.isLike,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      activityTime: activityTime ?? this.activityTime,
    );
  }

  @override
  String toString() {
    return 'Activity(isReaded: $isReaded, isLike: $isLike, postId: $postId, userId: $userId, activityTime: $activityTime)';
  }

  Map<String, dynamic> toMap() {
    return {
      'isReaded': isReaded,
      'isLike': isLike,
      'postId': postId,
      'userId': userId,
      'activityTime':
          activityTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Activity(
      isReaded: map['isReaded'],
      isLike: map['isLike'],
      postId: map['postId'],
      userId: map['userId'],
      activityTime: DateTime.parse(map['activityTime']),
    );
  }
}

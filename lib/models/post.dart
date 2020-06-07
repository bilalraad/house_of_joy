import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Post {
  final String postId;
  final String userId;
  final List<String> imagesUrl;
  final String description;
  final String category;
  final List<Like> likes;
  final List<Comment> comments;

  Post({
    @required this.postId,
    @required this.userId,
    @required this.imagesUrl,
    @required this.description,
    @required this.category,
    @required this.likes,
    @required this.comments,
  });

  Post copyWith({
    String postId,
    String userId,
    String userName,
    List<String> imagesUrl,
    String description,
    String category,
    List<Like> likes,
    List<Comment> comments,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  @override
  String toString() {
    return 'Post(postId: $postId, user: $userId, imagesUrl: $imagesUrl, description: $description, category: $category, likes: $likes, comments: $comments)';
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'imagesUrl': imagesUrl,
      'description': description,
      'category': category,
      'likes': likes?.map((x) => x?.toMap())?.toList(),
      'comments': comments?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Post.fromDocument(DocumentSnapshot doc, String uid) {
    if (doc.data == null) return null;
    return Post(
      postId: doc['postId'],
      userId: doc['userId'],
      imagesUrl: List<String>.from(doc['imagesUrl']),
      description: doc['description'],
      category: doc['category'],
      likes: List<Like>.from(doc['likes']?.map((x) => Like.fromMap(x))),
      comments:
          List<Comment>.from(doc['comments']?.map((x) => Comment.fromMap(x))),
    );
  }
}

class Comment {
  final String userId;
  final String comment;

  Comment({
    @required this.userId,
    @required this.comment,
  });

  Comment copyWith({
    String userId,
    String comment,
  }) {
    return Comment(
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Comment(
      userId: map['userId'],
      comment: map['comment'],
    );
  }
}

class Like {
  final String userId;

  Like({this.userId});

  Like copyWith({
    String uid,
  }) {
    return Like(
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() => 'Like(uid: $userId)';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Like(
      userId: map['userId'],
    );
  }
}

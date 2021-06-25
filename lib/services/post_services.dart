import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './data_base.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostServices {
  final String postId;

  PostServices(this.postId);

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('Posts');

  Future<String> likeUnlikePost(
    List<Like> likes,
    Activity activity,
    String postOwnerId,
  ) async {
    if (await connected()) {
      await postsCollection.doc(postId).update(
        {
          'likes': likes.map((e) => e.toMap()).toList(),
        },
      );
      if (activity != null) {
        DatabaseService(postOwnerId).updateUserActivities(activity);
      }
      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  Future<String> addComment(
    List<Comment> comments, {
    Activity activity,
    String postOwnerId,
  }) async {
    if (await connected()) {
      await postsCollection
          .doc(postId)
          .update({'comments': comments.map((e) => e.toMap()).toList()});
      if (activity != null) {
        DatabaseService(postOwnerId).updateUserActivities(activity);
      }

      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  ///this can be used to add new post or update an existing one
  Future<String> updatePostData(Post post) async {
    if (await connected()) {
      await postsCollection.doc(postId).set(post.toMap());
      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  ///this will get post data by the giving postId
  Future<Post> getPostData() async {
    if (await connected()) {
      final postQurey = await postsCollection.doc(postId).get();
      return Post.fromDocument(postQurey, postQurey.id);
    }
    return null;
  }

  Future<String> deletePost() async {
    if (await connected()) {
      await deletePostImages();
      await postsCollection.doc(postId).delete();
      deletePostActivities(postId);

      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  ///if the user deleted a post this will delete all the activities that connected to that post
  Future<void> deletePostActivities(String postId) async {
    // final activities = await getCurrentUserActivities();
    final user = await DatabaseService('').getCurrentUserData();
    await DatabaseService(user.uid)
        .userActivtiesReference
        .get()
        .then((value) => value.docs.forEach((element) {
              DatabaseService(user.uid)
                  .userActivtiesReference
                  .doc(postId)
                  .delete();
            }));
  }

  ///this will delete all post images from firestore when post is deleted
  Future<void> deletePostImages() async {
    final post = await getPostData();

    post.imagesUrl.forEach((img) async {
      final photoRef = await FirebaseStorage.instance.refFromURL(img);
      photoRef.delete().catchError((e) {
        /// '$e if([deletion_error]) this is not a big error so just ignore it';
      });
    });
  }

  List<Post> _postsListFromSnapshot(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return Post.fromDocument(doc, doc.id);
    }).toList();
  }

  List<Comment> _commentsListFromSnapshot(DocumentSnapshot doc) {
    return List<Comment>.from(doc['comments']?.map((x) => Comment.fromMap(x)));
  }

  Stream<List<Post>> getPostsByCategory(String category) {
    return postsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map(_postsListFromSnapshot);
  }

  Stream<List<Comment>> get comments {
    return postsCollection
        .doc(postId)
        .snapshots()
        .map(_commentsListFromSnapshot);
  }

  Future<List<Post>> getUserPosts([String uid]) async {
    final firebaseuser = await FirebaseAuth.instance.authStateChanges().first;
    if (firebaseuser == null) return null;

    return _postsListFromSnapshot(await postsCollection
        .where('userId', isEqualTo: uid ?? firebaseuser.uid)
        .get());
  }
}

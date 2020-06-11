import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';

class PostServices {
  final String postId;

  PostServices(this.postId);

  CollectionReference postsCollection = Firestore.instance.collection('Posts');

  Future<String> likeUnlikePost(
    List<Like> likes,
    Activity activity,
    String postOwnerId,
  ) async {
    if (await connected()) {
      await postsCollection.document(postId).updateData(
        {
          'likes': likes.map((e) => e.toMap()).toList(),
        },
      );
      if (activity != null)
        DatabaseService(postOwnerId).updateUserActivities(activity);
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
          .document(postId)
          .updateData({'comments': comments.map((e) => e.toMap()).toList()});
      if (activity != null)
        DatabaseService(postOwnerId).updateUserActivities(activity);

      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  Future<String> updatePostData(Post post) async {
    //this can be used to add new family or update an exsisting one
    if (await connected()) {
      await postsCollection.document(postId).setData(post.toMap());
      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  Future<String> deletePost() async {
    if (await connected()) {
      await postsCollection.document(postId).delete();
      return null;
    }
    return 'عذرا لا يوجد اتصال بالانترنت';
  }

  List<Post> _postsListFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return Post.fromDocument(doc, doc.documentID);
    }).toList();
  }

  List<Comment> _commentsListFromSnapshot(DocumentSnapshot doc) {
    return List<Comment>.from(
        doc.data['comments']?.map((x) => Comment.fromMap(x)));
  }

  Stream<List<Post>> getPostsByCategory(String category) {
    return postsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map(_postsListFromSnapshot);
  }

  Stream<List<Comment>> get comments {
    return postsCollection
        .document(postId)
        .snapshots()
        .map(_commentsListFromSnapshot);
  }

  Future<List<Post>> getUserPosts([String uid]) async {
    final firebaseuser = await FirebaseAuth.instance.onAuthStateChanged.first;
    if (firebaseuser == null) return null;

    return _postsListFromSnapshot(await postsCollection
        .where('userId', isEqualTo: uid ?? firebaseuser.uid)
        .getDocuments());
  }
}

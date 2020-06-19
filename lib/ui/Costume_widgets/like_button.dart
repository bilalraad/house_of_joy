import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../functions/show_overlay.dart';
import '../../services/post_services.dart';

class LikeButton extends StatefulWidget {
  final List<Like> likes;
  final String postId;
  final String postOwnerId;
  final User user;

  LikeButton(this.likes, this.postId, this.postOwnerId, {this.user});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Color colorLike = Colors.red;
  Color colorNotlike = const Color(0xffBDADE0);
  bool islike = false;
  Like like;

  @override
  Widget build(BuildContext context) {
    final user = widget.user ?? Provider.of<User>(context);
    if (user != null && widget.likes.any((like) => like.userId == user.uid)) {
      setState(() {
        islike = true;
      });
    }
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.favorite),
          color: islike ? colorLike : colorNotlike,
          iconSize: 30,
          onPressed: () async {
            setState(() => islike = !islike);
            List<Like> updatedLikes;
            like = Like(userId: user.uid);
            Activity newActivity;

            if (islike) {
              updatedLikes = widget.likes..add(like);
              if (widget.postOwnerId != user.uid) {
                newActivity = Activity(
                  isLike: true,
                  postId: widget.postId,
                  userId: user.uid,
                );
              }
            } else {
              updatedLikes = widget.likes
                ..removeWhere((like) => like.userId == user.uid);
            }
            var error = await PostServices(widget.postId).likeUnlikePost(
              updatedLikes,
              newActivity,
              widget.postOwnerId,
            );

            if (error != null) {
              setState(() => islike = !islike);
              showOverlay(context: context, text: error);
            }
          },
        ),
        Text(
          '${widget.likes.length}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

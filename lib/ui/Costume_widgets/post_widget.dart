import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/ui/Costume_widgets/view_images.dart';
import 'package:provider/provider.dart';

import '../../show_overlay.dart';
import '../comments.dart';
import '../order.dart';
import '../profileUser.dart';

Widget buildPostWidget(Post post, BuildContext context) {
  return FutureBuilder<User>(
    future: DatabaseService(post.userId).getUserData(),
    builder: (context, snapshot) {
      var postUser = snapshot.data;
      return !snapshot.hasData
          ? Container()
          : Container(
              padding: EdgeInsets.only(right: 8),
              child: Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: !postUser.imageUrl.isNotEmpty
                                ? Image.asset('images/personal.png')
                                : LoadImage(
                                    url: postUser.imageUrl,
                                    fit: BoxFit.cover,
                                    boxShape: BoxShape.circle,
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${postUser.fullName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'ae_Sindibad',
                            ),
                          ),
                          Expanded(
                            child: SizedBox(width: 10),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserProfile(outSideUser: postUser);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Text(
                      '${post.description}',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ae_Sindibad'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    color: Color(0xffF9F5F7),
                    child: Column(
                      children: <Widget>[
                        ViewImages(imagesUrl: post.imagesUrl),
                        SizedBox(height: 10),
                        Divider(height: 5, color: Colors.black),
                        Container(
                          child: Row(
                            children: <Widget>[
                              LikeButton(post.likes, post.postId, post.userId),
                              Expanded(
                                child: SizedBox(
                                  width: 3,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.mode_comment),
                                  color: Color(0xffBDADE0),
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Comments(
                                          postId: post.postId,
                                          postOwnerId: post.userId,
                                        ),
                                      ),
                                    );
                                  }),
                              Text(
                                '${post.comments.length}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Expanded(
                                child: SizedBox(width: 3),
                              ),
                              IconButton(
                                icon: Icon(faf.FontAwesomeIcons.shoppingCart),
                                color: Color(0xffBDADE0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Order(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
    },
  );
}

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
  Color colorNotlike = Color(0xffBDADE0);
  bool islike = false;
  Like like;
  @override
  Widget build(BuildContext context) {
    final user = widget.user ?? Provider.of<User>(context, listen: false);
    if (user != null && widget.likes.any((like) => like.userId == user.uid)) {
      setState(() {
        islike = true;
      });
    }
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          color: islike ? colorLike : colorNotlike,
          iconSize: 30,
          onPressed: () async {
            setState(() {
              islike = !islike;
            });
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
              setState(() {
                islike = false;
              });
              showOverlay(context: context, text: error);
            }
          },
        ),
        Text(
          '${widget.likes.length}',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class LoadImage extends StatefulWidget {
  const LoadImage(
      {@required this.url,
      this.fit = BoxFit.contain,
      this.boxShape = BoxShape.rectangle});

  final String url;
  final BoxFit fit;
  final BoxShape boxShape;

  @override
  _LoadImageState createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      fit: widget.fit,
      shape: widget.boxShape,
      width: MediaQuery.of(context).size.width * 0.75,
      cache: true,
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
        );
      },
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {

          ///if you don't want override completed widget
          ///please return null or state.completedWidget
          //return null;
          //return state.completedWidget;
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                fit: widget.fit,
                image: state.extendedImageInfo?.image,
              ),
            );
            break;
          case LoadState.failed:
            _controller.reset();
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('خطا غير معروف'),
                  Text(
                    "اضغط لأعادة تحميل الصورة",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;

          default:
            return null;
        }
      },
    );
  }
}

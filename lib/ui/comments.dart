import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/services/shered_Preference.dart';

import 'Costume_widgets/loading_dialog.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;

  const Comments({
    @required this.postId,
    @required this.postOwnerId,
  });
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<Comment> _comments;
  var _controllercomment = TextEditingController();
  bool enable = false;

  @override
  void dispose() {
    _controllercomment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
      stream: PostServices(widget.postId).comments,
      builder: (context, snapshot) {
        _comments = snapshot.data;
        return Scaffold(
          backgroundColor: Color(0xffFAFBFD),
          body: Container(
            child: Transform.translate(
              offset: Offset(0, 24),
              child: FutureBuilder<User>(
                future: SharedPrefs().getUser(),
                builder: (context, snapshot) {
                  var currentUser =
                      snapshot.data ?? User(email: '', fullName: '', uid: '');
                  return Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'images/backgroundImage.jpg',
                                ),
                                fit: BoxFit.cover)),
                        child: Container(
                          color: Color.fromRGBO(250, 251, 253, 75),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      _comments == null
                          ? LoadingDialog()
                          : Transform.translate(
                              offset: Offset(0, 120),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: ListView.builder(
                                  itemCount: _comments.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: commentContainer(
                                          _comments[i], currentUser),
                                    );
                                  },
                                ),
                              ),
                            ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Expanded(
                            child: SizedBox(
                              width: 3,
                            ),
                          ),
                          Text(
                            'التعليقات',
                            style: TextStyle(
                                color: Color(0xffE10586),
                                fontSize: 26,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 3,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.home),
                              iconSize: 30,
                              onPressed: () {
                                showCostumeDialog(context);
                              }),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(0, -23),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Color(0xffFFAADC),
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    padding: EdgeInsets.only(
                                      top: 13,
                                      left: 25,
                                      right: 16,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5),
                                        ]),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextField(
                                        controller: _controllercomment,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'أضف تعليق',
                                          isDense: true,
                                          hintStyle: TextStyle(
                                            fontFamily: 'Cambo',
                                            color: Color(0xffA2A2A2),
                                          ),
                                        ),
                                        onChanged: (input) {
                                          if (!input.startsWith(' '))
                                            setState(() {
                                              enable = input.isNotEmpty;
                                            });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Transform.translate(
                                    offset: Offset(-5, -5),
                                    child: !enable
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            color: Color(0xffFFAADC),
                                            enableFeedback: true,
                                            onPressed: () =>
                                                FocusScope.of(context)
                                                    .unfocus(),
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.arrow_upward),
                                            color: Color(0xffFFAADC),
                                            enableFeedback: true,
                                            onPressed: () =>
                                                submmetComment(currentUser),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void submmetComment(User user) async {
    setState(() {
      enable = false;
    });
    Activity newActivity;
    if (widget.postOwnerId != user.uid) {
      newActivity = Activity(
        isLike: false,
        postId: widget.postId,
        userId: user.uid,
      );
    }
    var error = await PostServices(widget.postId).addComment(
        _comments
          ..add(
            Comment(
              comment: _controllercomment.text,
              userId: user.uid,
            ),
          ),
        postOwnerId: widget.postOwnerId,
        activity: newActivity);
    if (error == null) {
      _controllercomment.clear();
    } else {
      showFlushSnackBar(context, error);
    }
  }

  Widget commentContainer(Comment comment, User currentUser) {
    return FutureBuilder<User>(
      future: DatabaseService(comment.userId).getUserData(),
      builder: (context, snapshot) {
        var commentUser = snapshot.data;
        return snapshot.data == null
            ? Container()
            : Container(
                padding: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        Text(
                          '${commentUser.fullName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'ae_Sindibad',
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: commentUser.imageUrl.isNotEmpty
                                    ? NetworkImage(
                                        commentUser.imageUrl,
                                      )
                                    : AssetImage(
                                        'images/personalPhoto.jpg',
                                      ),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        '${comment.comment}',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/data_base.dart';
import '../../functions/show_dialog.dart';
import '../../functions/validations.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/loading_dialog.dart';

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
  final _controllercomment = TextEditingController();
  bool enable = false;

  @override
  void dispose() {
    _controllercomment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    return StreamBuilder<List<Comment>>(
      stream: PostServices(widget.postId).comments,
      builder: (context, snapshot) {
        _comments = snapshot.data;
        return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/backgroundImage.png',
                  ),
                  fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          const Expanded(child: SizedBox(width: 3)),
                          const Text(
                            'التعليقات',
                            style: TextStyle(
                                color: Color(0xffE10586),
                                fontSize: 26,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          const Expanded(child: SizedBox(width: 3)),
                          IconButton(
                              icon: const Icon(Icons.home),
                              iconSize: 30,
                              onPressed: () {
                                showCostumeDialog(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                _comments == null
                    ? const LoadingDialog()
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: ListView.builder(
                          itemCount: _comments.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: buildCommentContainer(_comments[i]),
                            );
                          },
                        ),
                      ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xffFFAADC),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.only(
                            top: 13,
                            left: 25,
                            right: 16,
                          ),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5),
                              ]),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: _controllercomment,
                              autofocus: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'أضف تعليق',
                                isDense: true,
                                hintStyle: TextStyle(
                                  fontFamily: 'Cambo',
                                  color: Color(0xffA2A2A2),
                                ),
                              ),
                              onChanged: (input) {
                                if (!input.startsWith(' ')) {
                                  setState(() {
                                    enable = input.isNotEmpty;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Transform.translate(
                          offset: const Offset(-5, -5),
                          child: !enable
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  color: const Color(0xffFFAADC),
                                  enableFeedback: true,
                                  onPressed: () =>
                                      FocusScope.of(context).unfocus(),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.arrow_upward),
                                  color: const Color(0xffFFAADC),
                                  enableFeedback: true,
                                  onPressed: () => submmetComment(currentUser),
                                ),
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  void submmetComment(User currentUser) async {
    FocusScope.of(context).unfocus();
    setState(() {
      enable = false;
    });
    Activity newActivity;
    if (widget.postOwnerId != currentUser.uid) {
      newActivity = Activity(
        isLike: false,
        postId: widget.postId,
        userId: currentUser.uid,
      );
    }
    var error = await PostServices(widget.postId).addComment(
        _comments
          ..add(
            Comment(
              comment: _controllercomment.text,
              userId: currentUser.uid,
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

  Widget buildCommentContainer(Comment comment) {
    return FutureBuilder<User>(
      future: DatabaseService(comment.userId).getUserData(),
      builder: (context, snapshot) {
        var commentUser = snapshot.data;
        return snapshot.data == null
            ? Container()
            : Container(
                padding: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Expanded(child: SizedBox(width: 10)),
                        Text(
                          '${commentUser.fullName}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'ae_Sindibad',
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: commentUser.imageUrl.isNotEmpty
                                    ? NetworkImage(
                                        commentUser.imageUrl,
                                      )
                                    : const AssetImage('images/personal.png'),
                                fit: BoxFit.cover),
                            boxShadow: [BoxShadow(color: Colors.grey[300])],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        '${comment.comment}',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
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

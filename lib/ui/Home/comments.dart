import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/data_base.dart';
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
  var _enable = false;
  var _loading = false;

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
            extendBodyBehindAppBar: true,
            backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: const Text(
                'التعليقات',
                style: TextStyle(
                    color: Color(0xffE10586),
                    fontSize: 26,
                    fontFamily: 'ae_Sindibad'),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: _comments == null
                      ? const LoadingDialog()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, i) {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: buildCommentContainer(_comments[i]),
                                  ),
                                  i == _comments.length - 1
                                      ? const SizedBox(height: 100)
                                      : Container(),
                                ],
                              );
                            },
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
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
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5),
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
                                    fontFamily: 'ae_Sindibad',
                                    color: Color(0xffA2A2A2),
                                  ),
                                ),
                                onChanged: (input) {
                                  if (!input.startsWith(' ')) {
                                    setState(() {
                                      _enable = input.isNotEmpty;
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
                          child: _loading
                              ? const CircularProgressIndicator(
                                  backgroundColor: Color(0xffFFAADC))
                              : Transform.translate(
                                  offset: const Offset(-5, -5),
                                  child: !_enable
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          color: const Color(0xffFFAADC),
                                          onPressed: () =>
                                              FocusScope.of(context).unfocus(),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.arrow_upward),
                                          color: const Color(0xffFFAADC),
                                          onPressed: () =>
                                              submmetComment(currentUser),
                                        ),
                                ),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void submmetComment(User currentUser) async {
    setState(() => _loading = true);
    FocusScope.of(context).unfocus();

    setState(() {
      _enable = false;
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
      setState(() => _loading = false);
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
            ? Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 50,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Container(color: Colors.grey[300], height: 10),
                    subtitle: Container(color: Colors.grey[300], height: 10),
                    leading: CircleAvatar(
                      radius: 50,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                ),
              )
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

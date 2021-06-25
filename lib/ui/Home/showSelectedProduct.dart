import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;

import './order.dart';
import './comments.dart';
import './publishAPost.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/data_base.dart';
import '../../functions/creat_route.dart';
import '../../functions/validations.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/like_button.dart';
import '../Costume_widgets/view_images.dart';
import '../Costume_widgets/loading_dialog.dart';

enum PopMenuItem {
  editPost,
  removePost,
}

class ShowSelectedProduct extends StatefulWidget {
  final Post post;
  final UserModel user;
  final bool showOptions;

  const ShowSelectedProduct({
    @required this.post,
    @required this.user,
    @required this.showOptions,
  });
  @override
  _ShowSelectedProductState createState() => _ShowSelectedProductState();
}

class _ShowSelectedProductState extends State<ShowSelectedProduct> {
  Color colorLike = Colors.red;
  Color colorNotlike = const Color(0xffBDADE0);
  bool like = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: ModalProgress(
          inAsyncCall: loading,
          costumeIndicator: const LoadingDialog(),
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    SafeArea(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          const Expanded(child: SizedBox(width: 3)),
                          Text(
                            '${widget.post.category}',
                            style: const TextStyle(
                                color: Color(0xffE10586),
                                fontSize: 26,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          const Expanded(child: SizedBox(width: 5)),
                          const SizedBox(width: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildSelectedPost(widget.user),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectedPost(UserModel currentUser) {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Color(0xffFFAADC), shape: BoxShape.circle),
                  child: currentUser.imageUrl.isNotEmpty
                      ? LoadImage(
                          url: currentUser.imageUrl,
                          fit: BoxFit.cover,
                          boxShape: BoxShape.circle,
                        )
                      : Image.asset('images/personal.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  '${currentUser.fullName}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'ae_Sindibad'),
                ),
                const Expanded(child: SizedBox(width: 10)),
                widget.showOptions ? buildPopupMenuButton() : Container(),
                const SizedBox(width: 10)
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              '${widget.post.description}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'ae_Sindibad'),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            color: const Color(0xffF9F5F7),
            child: Column(
              children: <Widget>[
                ViewImages(imagesUrl: widget.post.imagesUrl),
                const Divider(
                  height: 5,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      LikeButton(
                        widget.post.likes,
                        widget.post.postId,
                        widget.post.userId,
                        user: currentUser,
                      ),
                      const Expanded(
                        child: SizedBox(width: 3),
                      ),
                      IconButton(
                          icon: const Icon(Icons.mode_comment),
                          color: const Color(0xffBDADE0),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              createRoute(
                                FutureProvider<UserModel>(
                                  initialData: null,
                                  create: (context) =>
                                      DatabaseService('').getCurrentUserData(),
                                  child: Comments(
                                    postId: widget.post.postId,
                                    postOwnerId: widget.post.userId,
                                  ),
                                ),
                              ),
                            );
                          }),
                      Text(
                        '${widget.post.comments.length}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Expanded(child: SizedBox(width: 3)),
                      IconButton(
                          icon: const Icon(faf.FontAwesomeIcons.shoppingCart),
                          color: const Color(0xffBDADE0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Order(userNumber: currentUser.phoneNo),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildPopupMenuButton() {
    return Container(
      color: Colors.white24,
      width: 40,
      height: 40,
      child: PopupMenuButton(
        onSelected: (selectedItem) async {
          switch (selectedItem) {
            case PopMenuItem.editPost:
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishAPsostTab(
                      oldPost: widget.post, currentUser: widget.user),
                ),
              );
              break;
            case PopMenuItem.removePost:
              // Navigator.pop(context);
              setState(() => loading = true);
              final err = await PostServices(widget.post.postId).deletePost();
              setState(() => loading = false);
              if (err == null) {
                Navigator.of(context).pushReplacementNamed('/');
              } else {
                showFlushSnackBar(context, err);
              }
              break;
            default:
          }
        },
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: PopMenuItem.editPost,
            child: Text(
              'تعديل',
            ),
          ),
          const PopupMenuItem(
            value: PopMenuItem.removePost,
            child: Text(
              'حذف',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/creat_route.dart';
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/ui/Costume_widgets/loading_dialog.dart';
import 'package:house_of_joy/ui/Costume_widgets/post_widget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/ui/Costume_widgets/view_images.dart';
import 'package:house_of_joy/ui/screens/publishAPost.dart';
import 'package:provider/provider.dart';

import 'comments.dart';
import 'order.dart';


enum PopMenuItem {
  editPost,
  removePost,
}

class ShowSelectedProduct extends StatefulWidget {
  final Post post;
  final User user;
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
  Color colorNotlike = Color(0xffBDADE0);
  bool like = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 251, 253, 75),
        body: ModalProgress(
          inAsyncCall: loading,
          costumeIndicator: LoadingDialog(),
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    SafeArea(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Expanded(child: SizedBox(width: 3)),
                          Text(
                            '${widget.post.category}',
                            style: TextStyle(
                                color: Color(0xffE10586),
                                fontSize: 26,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          Expanded(child: SizedBox(width: 5)),
                          Container(child: SizedBox(width: 50)),
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

  Widget buildSelectedPost(User currentUser) {
    return Container(
      padding: EdgeInsets.only(top: 100),
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
                  child: LoadImage(
                    url: currentUser.imageUrl,
                    fit: BoxFit.cover,
                    boxShape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${currentUser.fullName}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'ae_Sindibad'),
                ),
                Expanded(child: SizedBox(width: 10)),
                widget.showOptions ? buildPopupMenuButton() : Container(),
                SizedBox(width: 10)
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              '${widget.post.description}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'ae_Sindibad'),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            color: Color(0xffF9F5F7),
            child: Column(
              children: <Widget>[
                ViewImages(imagesUrl: widget.post.imagesUrl),
                Divider(
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
                      Expanded(
                        child: SizedBox(width: 3),
                      ),
                      IconButton(
                          icon: Icon(Icons.mode_comment),
                          color: Color(0xffBDADE0),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              createRoute(
                                FutureProvider<User>(
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
          SizedBox(height: 20),
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
        onSelected: (PopMenuItem selectedItem) async {
          switch (selectedItem) {
            case PopMenuItem.editPost:
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublishAPsost(oldPost: widget.post),
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
        icon: Icon(Icons.more_vert),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: PopMenuItem.editPost,
            child: Text(
              'تعديل',
            ),
          ),
          PopupMenuItem(
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

import 'package:flutter/material.dart';

import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/ui/Costume_widgets/post_widget.dart';
import 'package:house_of_joy/ui/showSelectedProduct.dart';
import 'package:provider/provider.dart';

import 'Costume_widgets/loading_dialog.dart';

class UserProfile extends StatefulWidget {
  final User outSideUser;

  const UserProfile({Key key, this.outSideUser}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    List<Post> posts;
    if (widget.outSideUser == null) {
      posts = Provider.of<List<Post>>(context);
    } else if (user.uid == widget.outSideUser.uid) {
      posts = Provider.of<List<Post>>(context);
    } else {
      user = widget.outSideUser;
      posts = [];
    }
    return Scaffold(
      body: user == null
          ? LoadingDialog()
          : Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 23,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'images/backgroundImage.jpg',
                                      ),
                                      fit: BoxFit.fitWidth)),
                              child: Container(
                                color: Color.fromRGBO(250, 251, 253, 75),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: <Widget>[
                                          widget.outSideUser != null
                                              ? IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_back_ios),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                              : Container(),
                                          Expanded(
                                            child: SizedBox(
                                              width: 5,
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.home),
                                              iconSize: 30,
                                              onPressed: () {
                                                showCostumeDialog(context);
                                              })
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Color(0xffFFAADC),
                                          shape: BoxShape.circle),
                                      child: !user.imageUrl.isNotEmpty
                                          ? Image.asset('images/personal.png')
                                          : LoadImage(
                                              url: user.imageUrl,
                                              fit: BoxFit.cover,
                                              boxShape: BoxShape.circle,
                                            ),
                                    ),
                                    Text(
                                      user.fullName,
                                      style: TextStyle(
                                        fontFamily: 'ae_Sindibad',
                                        fontSize: 20,
                                        color: Color(0xff460053),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  widget.outSideUser != null &&
                          user.uid != widget.outSideUser.uid
                      ? _buildOutSideUserPostsGridView()
                      : Transform.translate(
                          offset: Offset(0, 200),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 200),
                            child: posts == null
                                ? LoadingDialog()
                                : GridView.builder(
                                    itemCount: posts.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return containerImage(
                                          posts[index], user, true);
                                    },
                                  ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildOutSideUserPostsGridView() {
    return StreamBuilder<List<Post>>(
        stream: PostServices('').listenToUserPosts(widget.outSideUser.uid),
        builder: (context, snapshot) {
          var posts = snapshot.data;
          return Transform.translate(
            offset: Offset(0, 200),
            child: Container(
              padding: EdgeInsets.only(bottom: 200),
              child: posts == null
                  ? LoadingDialog()
                  : GridView.builder(
                      itemCount: posts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return containerImage(
                            posts[index], widget.outSideUser, false);
                      },
                    ),
            ),
          );
        });
  }

  Widget containerImage(Post post, User user, bool showOptions) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 3,
          height: 80,
          child: LoadImage(
            url: post.imagesUrl.first,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowSelectedProduct(
                post: post,
                user: user,
                showOptions: showOptions,
              ),
            ),
          );
        },
      ),
    );
  }
}

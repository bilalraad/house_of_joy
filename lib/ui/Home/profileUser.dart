import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import './showSelectedProduct.dart';
import '../../functions/show_dialog.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/view_images.dart';
import '../Costume_widgets/loading_dialog.dart';

class UserProfileTab extends StatefulWidget {
  final User outSideUser;

  const UserProfileTab({Key key, this.outSideUser}) : super(key: key);
  @override
  _UserProfileTabState createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  @override
  Widget build(BuildContext context) {
    final user = widget.outSideUser ?? Provider.of<User>(context);
    final posts =
        widget.outSideUser == null ? Provider.of<List<Post>>(context) : null;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: user == null
            ? const LoadingDialog()
            : Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 23),
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: <Widget>[
                                      widget.outSideUser != null
                                          ? IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_back_ios),
                                              onPressed: () =>
                                                  Navigator.pop(context))
                                          : Container(),
                                      const Expanded(child: SizedBox(width: 5)),
                                      IconButton(
                                          icon: const Icon(Icons.home),
                                          iconSize: 30,
                                          onPressed: () =>
                                              showCostumeDialog(context))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      color: Color(0xffFFAADC),
                                      shape: BoxShape.circle),
                                  child: user.imageUrl.isNotEmpty
                                      ? LoadImage(
                                          url: user.imageUrl,
                                          fit: BoxFit.cover,
                                          boxShape: BoxShape.circle,
                                        )
                                      : Image.asset('images/personal.png'),
                                ),
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontFamily: 'ae_Sindibad',
                                    fontSize: 20,
                                    color: Color(0xff460053),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  widget.outSideUser != null &&
                          user.uid == widget.outSideUser.uid
                      // posts == null
                      ? _buildOutSideUserPostsGridView()
                      : Container(
                          padding: const EdgeInsets.only(top: 200),
                          child: posts == null
                              ? const LoadingDialog()
                              : posts.isEmpty
                                  ? const Center(
                                      child: Text('لم يتم نشر اي منشورات هنا'))
                                  : GridView.builder(
                                      itemCount: posts.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemBuilder: (context, index) {
                                        return buidPostFirstImageContainer(
                                            posts[index], user,
                                            showOptions: true);
                                      },
                                    ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildOutSideUserPostsGridView() {
    return FutureBuilder<List<Post>>(
      future: PostServices('').getUserPosts(widget.outSideUser.uid),
      builder: (context, snapshot) {
        var posts = snapshot.data;
        return Container(
          padding: const EdgeInsets.only(top: 200),
          child: posts == null
              ? const LoadingDialog()
              : GridView.builder(
                  itemCount: posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return buidPostFirstImageContainer(
                        posts[index], widget.outSideUser,
                        showOptions: false);
                  },
                ),
        );
      },
    );
  }

  Widget buidPostFirstImageContainer(Post post, User user, {bool showOptions}) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(10),
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

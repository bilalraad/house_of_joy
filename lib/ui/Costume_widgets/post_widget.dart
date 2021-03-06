import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;

import '../Home/order.dart';
import './like_button.dart';
import './view_images.dart';
import '../Home/comments.dart';
import './loading_dialog.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../Home/profileUser.dart';
import '../../services/data_base.dart';
import '../../functions/creat_route.dart';

Widget buildPostWidget(Post post, BuildContext context, int index) {
  return FutureBuilder<UserModel>(
    future: DatabaseService(post.userId).getUserData(),
    builder: (context, snapshot) {
      var postUser = snapshot.data;
      return !snapshot.hasData
          ? post != null && index == 0
              ? const LoadingDialog()
              : Container()
          : FutureProvider.value(
              initialData: null,
              value: DatabaseService('').getCurrentUserData(),
              child: Container(
                padding: const EdgeInsets.only(right: 8),
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
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12),
                                  ]),
                              child: !postUser.imageUrl.isNotEmpty
                                  ? Image.asset('images/personal.png')
                                  : LoadImage(
                                      url: postUser.imageUrl,
                                      fit: BoxFit.cover,
                                      boxShape: BoxShape.circle,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${postUser.fullName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'ae_Sindibad',
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(width: 10),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserProfileTab(outSideUser: postUser);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Text(
                        '${post.description}',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'ae_Sindibad'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      color: const Color(0xffF9F5F7),
                      child: Column(
                        children: <Widget>[
                          ViewImages(imagesUrl: post.imagesUrl),
                          const SizedBox(height: 10),
                          const Divider(height: 5, color: Colors.black),
                          Container(
                            child: Row(
                              children: <Widget>[
                                LikeButton(
                                    post.likes, post.postId, post.userId),
                                const Expanded(child: SizedBox(width: 3)),
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
                                                DatabaseService('')
                                                    .getCurrentUserData(),
                                            child: Comments(
                                              postId: post.postId,
                                              postOwnerId: post.userId,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                Text(
                                  '${post.comments.length}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Expanded(child: SizedBox(width: 3)),
                                IconButton(
                                  icon: const Icon(
                                      faf.FontAwesomeIcons.shoppingCart),
                                  color: const Color(0xffBDADE0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Order(userNumber: postUser.phoneNo),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
    },
  );
}

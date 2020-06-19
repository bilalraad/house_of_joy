import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import './showSelectedProduct.dart';
import '../../services/data_base.dart';
import '../../functions/creat_route.dart';
import '../../functions/show_dialog.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/view_images.dart';
import '../Costume_widgets/loading_dialog.dart';

class ActivitiesTab extends StatefulWidget {
  const ActivitiesTab();
  @override
  _ActivitiesTabState createState() => _ActivitiesTabState();
}

class _ActivitiesTabState extends State<ActivitiesTab> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<User>(context, listen: true);
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: StreamBuilder<List<Activity>>(
            stream: DatabaseService(currentUser?.uid ?? '').activities,
            builder: (context, snapshot) {
              var activities = snapshot.data;
              activities?.sort((a,b)=>b.activityTime.compareTo(a.activityTime));
              return ModalProgress(
                inAsyncCall: activities == null || currentUser == null,
                costumeIndicator: const LoadingDialog(),
                opacity: 0,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 23),
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: <Widget>[
                                  const Expanded(
                                    child: SizedBox(width: 5),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.home),
                                      iconSize: 30,
                                      onPressed: () {
                                        showCostumeDialog(context);
                                      })
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                            const Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'النشاطات',
                                  style: TextStyle(
                                      color: Color(0xFFCA39E3),
                                      fontSize: 24,
                                      fontFamily: 'ae_Sindibad'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: activities == null
                          ? Container()
                          : activities.isEmpty
                              ? const Center(child: Text('لايوجد نشاطات'))
                              : ListView.builder(
                                  cacheExtent: 8,
                                  // itemExtent: 5,
                                  itemCount: activities.length,
                                  itemBuilder: (context, i) {
                                    DatabaseService(currentUser.uid)
                                        .markAllActivitiesAsReaded();

                                    return buildAlertContainer(
                                        activities[i], currentUser);
                                  }),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildAlertContainer(Activity activity, User currentUser) {
    return FutureBuilder<User>(
      future: DatabaseService(activity.userId).getUserData(),
      builder: (context, snapshot) {
        var activityByTheUser = snapshot.data;
        return activityByTheUser == null
            ? Container(
                width: 100,
                height: 20,
                color: Colors.grey[300],
                margin: const EdgeInsets.all(5),
              )
            : InkWell(
                onTap: () {
                  Navigator.of(context).push(createRoute(
                    TempPage(
                      postId: activity.postId,
                      currentUser: currentUser,
                    ),
                  ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.grey[300])],
                              shape: BoxShape.circle),
                          child: activityByTheUser.imageUrl.isNotEmpty
                              ? LoadImage(
                                  url: activityByTheUser.imageUrl,
                                  fit: BoxFit.cover,
                                  boxShape: BoxShape.circle,
                                )
                              : Image.asset('images/personal.png'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${activityByTheUser.fullName}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'ae_Sindibad'),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          activity.isLike
                              ? 'قام بالاعجاب بمنشورك'
                              : 'قام بالتعليق على منشورك',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'ae_Sindibad'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class TempPage extends StatelessWidget {
  final String postId;
  final User currentUser;
  const TempPage({this.postId, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Post>(
        future: PostServices(postId).getPostData(),
        builder: (context, snapshot) {
          var post = snapshot.data;
          return ModalProgress(
            inAsyncCall: post == null,
            child: post == null
                ? Container()
                : FutureProvider<User>(
                    create: (_) => DatabaseService('').getCurrentUserData(),
                    child: ShowSelectedProduct(
                      post: post,
                      showOptions: true,
                      user: currentUser,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

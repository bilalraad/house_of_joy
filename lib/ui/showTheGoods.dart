import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'Costume_widgets/loading_dialog.dart';
import 'Costume_widgets/post_widget.dart';

class ShowThwGoods extends StatefulWidget {
  final String _title;

  ShowThwGoods(
    this._title,
  );

  @override
  _ShowThwGoodsState createState() => _ShowThwGoodsState(_title);
}

class _ShowThwGoodsState extends State<ShowThwGoods> {
  String _title;

  _ShowThwGoodsState(this._title);

  Color colorLike = Colors.red;
  Color colorNotlike = Color(0xffBDADE0);
  List<Post> posts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: PostServices('').getPostsByCategory(_title),
      builder: (context, snapshot) {
        posts = snapshot.data;
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   showAlertDialog(context);
        // } else {
        //   Navigator.of(context).pop();
        // }
        return Scaffold(
          backgroundColor: Color(0xffFAFBFD),
          body: Container(
            child: Transform.translate(
              offset: Offset(0, 24),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/backgroundImage.jpg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Container(
                      color: Color.fromRGBO(250, 251, 253, 75),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  ModalProgress(
                    costumeIndicator: LoadingDialog(),
                    inAsyncCall:
                        snapshot.connectionState == ConnectionState.waiting
                            ? true
                            : false,
                    child: Transform.translate(
                      offset: Offset(0, 120),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 150),
                        child: posts == null
                            ? Container()
                            : posts.isEmpty
                                ? Center(child: Text('لايوجد مشاريع هنا'))
                                : ListView.builder(
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      return buildPostWidget(
                                          posts[index], context);
                                    },
                                  ),
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
                        child: SizedBox(width: 3),
                      ),
                      Text(
                        '$_title',
                        style: TextStyle(
                            color: Color(0xffE10586),
                            fontSize: 26,
                            fontFamily: 'ae_Sindibad'),
                      ),
                      Expanded(
                        child: SizedBox(width: 3),
                      ),
                      IconButton(
                        icon: Icon(Icons.home),
                        iconSize: 30,
                        onPressed: () {
                          showCostumeDialog(context);
                        },
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -23),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

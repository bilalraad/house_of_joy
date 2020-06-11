import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/ui/Costume_widgets/loading_dialog.dart';
import 'package:house_of_joy/ui/Costume_widgets/post_widget.dart';


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
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/backgroundImage.png',
                  ),
                  fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 251, 253, 75),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  ModalProgress(
                    costumeIndicator: LoadingDialog(),
                    inAsyncCall: !snapshot.hasData,
                    child: Container(
                      padding: EdgeInsets.only(top: 100),
                      child: posts == null
                          ? Container()
                          : posts.isEmpty
                              ? Center(child: Text('لايوجد مشاريع هنا'))
                              : ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return buildPostWidget(
                                        posts[index], context,index);
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

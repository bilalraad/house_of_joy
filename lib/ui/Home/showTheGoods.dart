import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/post_widget.dart';
import '../Costume_widgets/loading_dialog.dart';

class ShowThwGoods extends StatefulWidget {
  final String title;

  ShowThwGoods(this.title);

  @override
  _ShowThwGoodsState createState() => _ShowThwGoodsState(title);
}

class _ShowThwGoodsState extends State<ShowThwGoods> {
  final String _title;

  _ShowThwGoodsState(this._title);

  Color colorLike = Colors.red;
  Color colorNotlike = const Color(0xffBDADE0);
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
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/backgroundImage.png',
                  ),
                  fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                '$_title',
                style: const TextStyle(
                    color: Color(0xffE10586),
                    fontSize: 26,
                    fontFamily: 'ae_Sindibad'),
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  ModalProgress(
                    costumeIndicator: const LoadingDialog(),
                    inAsyncCall: !snapshot.hasData,
                    opacity: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: posts == null
                          ? Container()
                          : posts.isEmpty
                              ? const Center(child: Text('لايوجد مشاريع هنا'))
                              : ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return buildPostWidget(
                                        posts[index], context, index);
                                  },
                                ),
                    ),
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

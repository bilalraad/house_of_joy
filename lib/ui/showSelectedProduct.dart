import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/comments.dart';
import 'package:house_of_joy/ui/order.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/ui/publishAPost.dart';

class ShowSelectedProduct extends StatefulWidget {
  final bool _showOptions;
  ShowSelectedProduct(this._showOptions);
  @override
  _ShowSelectedProductState createState() =>
      _ShowSelectedProductState(_showOptions);
}

class _ShowSelectedProductState extends State<ShowSelectedProduct> {
  _ShowSelectedProductState(this.showOptions);
  bool showOptions;
  List getinfo;
  Color colorLike = Colors.red;
  Color colorNotlike = Color(0xffBDADE0);
  bool like = false;
  String _title;
  void initState() {
    super.initState();
    _title = 'مواد تجميل';
    getinfo = [
      {
        "name": "منى محمد",
        'describation': "وصف المشروع",
        'numberOfComment': "10",
        'numberOfLike': "20"
      },
    ];
  }

  Widget containerShowOptions(context) {
    if (showOptions == true) {
      return GestureDetector(
        child: Container(
          color: Colors.white24,
          width: 40,
          height: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 5,
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: 5,
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: 5,
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              )
            ],
          ),
        ),
        onTap: () {
          _showDialog(context);
        },
      );
    } else
      return Text('');
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(
              content: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('تعديل'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PublishAPsost(null)));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حذف'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFAFBFD),
        body: ListView(
          children: <Widget>[
            Container(
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
                            fit: BoxFit.cover)),
                    child: Container(
                      color: Color.fromRGBO(250, 251, 253, 75),
                      alignment: Alignment.topLeft,
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
                        child: SizedBox(
                          width: 3,
                        ),
                      ),
                      Text(
                        '$_title',
                        style: TextStyle(
                            color: Color(0xffE10586),
                            fontSize: 26,
                            fontFamily: 'ae_Sindibad'),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 3,
                        ),
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
            containerShowTheGoods(getinfo),
          ],
        ));
  }

  Widget containerShowTheGoods(List<dynamic> info) {
    return Container(
      padding: EdgeInsets.only(right: 8),
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/personalPhoto.jpg',
                          ),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${info[0]["name"]}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'ae_Sindibad'),
                ),
                Expanded(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                containerShowOptions(context),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              '${info[0]["describation"]}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: Colors.black, fontSize: 18, fontFamily: 'ae_Sindibad'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            color: Color(0xffF9F5F7),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      'images/photo.jpg',
                    ),
                    fit: BoxFit.cover,
                  )),
                ),
                Divider(
                  height: 5,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.favorite),
                          color: like ? colorLike : colorNotlike,
                          iconSize: 30,
                          onPressed: () {
                            setState(() {});
                          }),
                      Text(
                        '${getinfo[0]['numberOfLike']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 3,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.mode_comment),
                          color: Color(0xffBDADE0),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comments()));
                          }),
                      Text(
                        '${getinfo[0]['numberOfComment']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 3,
                        ),
                      ),
                      IconButton(
                          icon: Icon(faf.FontAwesomeIcons.shoppingCart),
                          color: Color(0xffBDADE0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Order()));
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
}

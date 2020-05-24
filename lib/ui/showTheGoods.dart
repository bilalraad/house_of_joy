import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/ui/Auth/logout.dart';
import 'package:house_of_joy/ui/aboutCodeForIraq.dart';
import 'package:house_of_joy/ui/aboutTheApplication.dart';
import 'package:house_of_joy/ui/comments.dart';
import 'package:house_of_joy/ui/editProfile.dart';
import 'package:house_of_joy/ui/order.dart';
import 'package:house_of_joy/ui/profileUser.dart';
import 'package:house_of_joy/ui/staff.dart';

class ShowThwGoods extends StatefulWidget {
  final String _title;

  ShowThwGoods(this._title);

  @override
  _ShowThwGoodsState createState() => _ShowThwGoodsState(_title);
}

class _ShowThwGoodsState extends State<ShowThwGoods> {
  String _title;
  List<dynamic> getinfo;

  _ShowThwGoodsState(this._title);

  Color colorLike = Colors.red;
  Color colorNotlike = Color(0xffBDADE0);
  bool like = false;

  @override
  void initState() {
    super.initState();
    getinfo = [
      {"name": "منى محمد", 'describation': "وصف المشروع",'numberOfComment': "10",'numberOfLike': "20"},
      {"name": "ندى علي", 'describation': "وصف المشروع",'numberOfComment': "5",'numberOfLike': "32"},
      {"name": "شهد قاسم", 'describation': "وصف المشروع",'numberOfComment': "12",'numberOfLike': "23"},
      {"name": "رنا وليد", 'describation': "وصف المشروع",'numberOfComment': "23",'numberOfLike': "44"}
    ];
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(

              content: SingleChildScrollView(
                child:  Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('تعديل الملف الشخصي'),
                        onTap: () {

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('تسجيل الخروج'),
                        onTap: () {

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Logout()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول التطبيق'),
                        onTap: () {

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutTheApp()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول المبادرة'),
                        onTap: () {

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutCodeForIraq()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('فريق العمل'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Staff()));
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
        body: Container(

          child: Transform.translate(offset: Offset(0,24),
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
                Transform.translate(offset: Offset(0,120),
                  child:Container(
                    height: MediaQuery.of(context).size.height*0.75,
                    child:  ListView.builder(
                        itemCount: getinfo.length,
                        itemBuilder: (context,position){

                          return  containerShowTheGoods(getinfo,position);

                        }),

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
                    IconButton(icon: Icon(Icons.home),
                        iconSize: 30,
                        onPressed: () {
                      _showDialog(context);
                        }),
                  ],
                ),
                Transform.translate(offset: Offset(0,-23),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,

                    ),
                  ),)
              ],
            ),),

        ));
  }

  Widget containerShowTheGoods(List<dynamic> info, int index) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      width: MediaQuery.of(context).size.width / 1.1,
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
                      '${info[index]["name"]}',
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



                  ],
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileUser(null,false)));
                },
              ),),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              '${info[index]["describation"]}',
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
                            setState(() {

                            });
                          }),

                      Text('${getinfo[index]['numberOfLike']}',style: TextStyle(color: Colors.grey),),
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
                      Text('${getinfo[index]['numberOfComment']}',style: TextStyle(color: Colors.grey),),
                      Expanded(
                        child: SizedBox(
                          width: 3,
                        ),
                      ),
                      IconButton(
                          icon: Icon(faf.FontAwesomeIcons.shoppingCart),
                          color: Color(0xffBDADE0),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Order()));
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

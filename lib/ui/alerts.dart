import 'dart:io';

import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/Auth/logout.dart';
import 'package:house_of_joy/ui/aboutCodeForIraq.dart';
import 'package:house_of_joy/ui/aboutTheApplication.dart';
import 'package:house_of_joy/ui/editProfile.dart';
import 'package:house_of_joy/ui/profileUser.dart';
import 'package:house_of_joy/ui/publishAPost.dart';
import 'package:house_of_joy/ui/staff.dart';

class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
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
  File imageFile;
  // dynamic _decideImageView() {
  //   if (imageFile == null)
  //     return AssetImage('images/personal.png');
  //   else
  //     return FileImage(imageFile);
  // }
  List getinfo;
  void initState() {
    super.initState();
    getinfo = [
      {"name": "منى محمد", 'describation': "وصف المشروع"},
      {"name": "ندى علي", 'describation': "وصف المشروع"},
      {"name": "شهد قاسم", 'describation': "وصف المشروع"},
      {"name": "رنا وليد", 'describation': "وصف المشروع"}
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child:
              Column(
                children: <Widget>[
                  SizedBox(height: 23,),

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
                                    IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      onPressed:(){
                                        Navigator.pop(context);
                                      } ,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 5,
                                      ),
                                    ),
                                    IconButton(icon: Icon(Icons.home),
                                        iconSize: 30,
                                        onPressed: (){
                                          _showDialog(context);

                                        })
                                  ],
                                ),
                              ),
                              SizedBox(height:60,),

                          Padding(
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
                            ),),


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: getinfo.length,
                          itemBuilder: (context,position){
                        return containerAlert(getinfo, position);
                      }),
                    ),
                  )
                ],
              ),

            ),




            Transform.translate(offset: Offset(0,-20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(

                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xffFCFCFC),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home),
                        color: Color(0xffC5C3E3),
                        iconSize: 30,
                        onPressed: (){
                          Navigator.pop(context);
                        },

                      ),
                      IconButton(
                        icon: Icon(Icons.person_pin),
                        color: Color(0xffC5C3E3),
                        iconSize: 30,
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileUser(null,true)));
                        },

                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Color(0xffC5C3E3),
                        iconSize: 30,
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PublishAPsost(null)));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        color: Color(0xffFD85CB),
                        iconSize: 30,
                        onPressed: (){

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),



    );
  }

  Widget containerAlert(List info,int index){
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child: Directionality(
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
        ),),
    );
  }

}

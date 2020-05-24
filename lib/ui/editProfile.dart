import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'Auth/changePassword.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  File imageFile;
  _openGellery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _decideImageView() {
    if (imageFile == null)
      return AssetImage('images/personal.png');
    else
      return FileImage(imageFile);
  }



  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('اختر صورة'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('المعرض'),
                      onTap: () {
                        _openGellery(context);
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      child: Text('الكاميرا'),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
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
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cansel',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Done',
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 75,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Color(0xFFCA39E3),
                                    fontSize: 24,
                                    fontFamily: 'Cambo'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color(0xffFFAADC),
                        image: DecorationImage(
                            image: _decideImageView(), fit: BoxFit.cover),
                        shape: BoxShape.circle),
                  ),
                  Transform.translate(
                    offset: Offset(72, 0),
                    child: GestureDetector(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/camera.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      onTap: () {
                        _showDialog(context);
                      },
                    ),
                  )
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFFAADC))),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFFAADC))),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFFAADC))),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFFAADC))),
                          hintText: 'Phone number',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                        ),
                      ),
                      GestureDetector(
                        child: Stack(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffFFAADC))),
                                hintText: 'Change password',
                                hintStyle: TextStyle(
                                    fontFamily: 'Cambo',
                                    color: Color(0xffA2A2A2)),
                              ),
                              readOnly: true,
                            ),
                            Transform.translate(
                              offset: Offset(0, 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onPressedDone() {
    Navigator.pop(context);
  }
}

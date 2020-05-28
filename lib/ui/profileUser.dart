import 'dart:io';

import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/ui/alerts.dart';
import 'package:house_of_joy/ui/publishAPost.dart';
import 'package:house_of_joy/ui/showSelectedProduct.dart';

class ProfileUser extends StatefulWidget {
  final int _id;
  final bool _showOpitions;

  ProfileUser(this._id, this._showOpitions);

  @override
  _ProfileUserState createState() => _ProfileUserState(_id, _showOpitions);
}

class _ProfileUserState extends State<ProfileUser> {
  int id;
  bool showOpitions;

  _ProfileUserState(this.id, this.showOpitions);

  List imageList = [
    'images/handWork.jpg',
    'images/google.png',
    'images/cosmeticMateral.jpg',
    'images/skinCare.jpg',
    'images/easternEating.jpg',
    'images/westernEting.jpg',
    'images/candy.jpg',
    'images/occasions.jpg',
    'images/sewing.jpg',
    'images/photogrphy.jpg',
    'images/printPhoto.jpg',
    'images/cushions.jpg',
    'images/accessories.jpg',
    'images/book.jpg',
    'images/codeForIraq.jpg',
    'images/camera.png',
    'images/personal.png',
    'images/whatsApp.png',
    'images/viber.png',
    'images/photo.jpg',
    'images/personalPhoto.jpg',
    'images/backgroundImage.jpg',
    'images/backgroundImageStart.jpg'
  ];

  File imageFile;
  _decideImageView() {
    if (imageFile == null)
      return AssetImage('images/personal.png');
    else
      return FileImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFAFBFD),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 23,
                    ),
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
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 5,
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.home),
                                          iconSize: 30,
                                          onPressed: () {
                                            showCostumeDialog(context);
                                          })
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFAADC),
                                      image: DecorationImage(
                                          image: _decideImageView(),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                ),
                                Text(
                                  'اسم المستخدم',
                                  style: TextStyle(
                                      fontFamily: 'ae_Sindibad',
                                      fontSize: 18,
                                      color: Color(0xff460053)),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, 200),
                child: Container(
                  padding: EdgeInsets.only(bottom: 200),
                  child: GridView.builder(
                    itemCount: imageList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, position) {
                      return containerImage(context, position, showOpitions);
                    },
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -20),
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person_pin),
                          color: Color(0xffFD85CB),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          color: Color(0xffC5C3E3),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PublishAPsost(null)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications),
                          color: Color(0xffC5C3E3),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Alerts()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget containerImage(
      BuildContext context, int position, bool _showOpitions) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 3,
          height: 80,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('${imageList[position]}'),
                  fit: BoxFit.cover)),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowSelectedProduct(_showOpitions)));
          print('$position');
        },
      ),
    );
  }
}

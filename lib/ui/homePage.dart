import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:house_of_joy/functions/show_dialog.dart';

import 'package:house_of_joy/ui/alerts.dart';
import 'package:house_of_joy/ui/homePageDetails/bookPage.dart';
import 'package:house_of_joy/ui/homePageDetails/cookingPage.dart';
import 'package:house_of_joy/ui/homePageDetails/cosmetic.dart';
import 'package:house_of_joy/ui/homePageDetails/craftWorks.dart';
import 'package:house_of_joy/ui/homePageDetails/photographyPage.dart';
import 'package:house_of_joy/ui/homePageDetails/sewingPage.dart';
import 'package:house_of_joy/ui/profileUser.dart';
import 'package:house_of_joy/ui/publishAPost.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 5, length: 6, vsync: this);
  }

  Widget build(BuildContext context) {
    Color colorpink = Color(0xffFFAADC);
    return Scaffold(
        body: Transform.translate(
      offset: Offset(0, 23),
      child: Stack(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'images/backgroundImage.jpg',
                      ),
                      fit: BoxFit.fitWidth)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Color.fromRGBO(250, 251, 253, 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Transform.translate(
                      offset:
                          Offset(MediaQuery.of(context).size.width * 0.71, 50),
                      child: Container(
                        child: Text(
                          'التصنيفات',
                          style: TextStyle(
                            color: Color(0xffE10586),
                            fontFamily: 'ae_Sindibad',
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: AppBar(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                elevation: 0,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: 'الكتب',
                    ),
                    Tab(
                      text: 'الأعمال اليدوية',
                    ),
                    Tab(
                      text: 'التصوير',
                    ),
                    Tab(
                      text: 'الخياطة',
                    ),
                    Tab(
                      text: 'الطبخ',
                    ),
                    Tab(
                      text: 'التجميل',
                    ),
                  ],
                  controller: _tabController,
                  indicatorColor: colorpink,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Color(0xff460053),
                  labelStyle: TextStyle(
                      fontFamily: 'ae_Sindibad',
                      fontSize: 18,
                      color: Colors.black),
                  isScrollable: true,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              0,
              200,
            ),
            child: Container(
              height: 500,
              color: Color(0xffFAFBFD),
              child: TabBarView(
                children: <Widget>[
                  BookPage(),
                  CraftworksPage(),
                  PhotographyPage(),
                  SewingPage(),
                  CookingPage(),
                  CosmeticPage(),
                ],
                controller: _tabController,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, -35),
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
                      color: Color(0xffFD85CB),
                      iconSize: 30,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.person_pin),
                      color: Color(0xffC5C3E3),
                      iconSize: 30,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileUser(null, true)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      color: Color(0xffC5C3E3),
                      iconSize: 30,
                      onPressed: () {
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Alerts()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-5, 5),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon(Icons.home),
                  iconSize: 30,
                  onPressed: () {
                    showCostumeDialog(context);
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}

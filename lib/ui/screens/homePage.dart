import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/models/category.dart';
import 'package:house_of_joy/ui/Costume_widgets/category_tab_view.dart';

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

  List<Tab> tabs = [
    Tab(text: 'الكتب'),
    Tab(text: 'الأعمال اليدوية'),
    Tab(text: 'التصوير'),
    Tab(text: 'الخياطة'),
    Tab(text: 'الطبخ'),
    Tab(text: 'التجميل'),
  ];

  Widget build(BuildContext context) {
    Color colorpink = Color(0xffFFAADC);

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
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 100),
                      Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          'التصنيفات',
                          style: TextStyle(
                            color: Color(0xffE10586),
                            fontFamily: 'ae_Sindibad',
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ],
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
                      tabs: tabs,
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
                    children: List<Widget>.generate(tabs.length, (index) {
                      return CategoryTabView(
                        type: CategoryTabType.values[index],
                        category: tabs[index].text,
                      );
                    }),
                    controller: _tabController,
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

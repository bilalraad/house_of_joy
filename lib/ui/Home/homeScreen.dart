import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './activities.dart';
import './profileUser.dart';
import './publishAPost.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../models/category.dart';
import '../../services/data_base.dart';
import '../../functions/validations.dart';
import '../../functions/show_dialog.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/category_tab_view.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final int initialIndex;
  HomeScreen({this.userId, this.initialIndex = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> taps = [
    const HomePageTab(),
    const UserProfileTab(),
    const PublishAPsostTab(),
    const ActivitiesTab(),
  ];

  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.configure(
      onMessage: (message) async {
        print(message);
        showFlushSnackBar(context, message['notification']['body']);
      },
      onLaunch: (message) async {
        print("onLaunch: $message");
      },
      onResume: (message) async {
        print("onresum: $message");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> activities;
    return Scaffold(
      body: MultiProvider(
        providers: [
          FutureProvider<User>.value(
              value: DatabaseService('').getCurrentUserData()),
          FutureProvider<List<Post>>.value(
              value: PostServices('').getUserPosts()),
        ],
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: taps[_currentIndex]),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          bottom: 15,
          right: 65,
          left: 65,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: const Color(0xffFCFCFC),
            selectedItemColor: const Color(0xffFD85CB),
            unselectedItemColor: const Color(0xffC5C3E3),
            iconSize: 35,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_pin),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_circle_outline),
                title: Container(),
              ),
              BottomNavigationBarItem(
                title: Container(),
                icon: Stack(
                  children: <Widget>[
                    const Icon(Icons.notifications),
                    Positioned(
                      // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: StreamBuilder(
                        stream: DatabaseService(widget.userId).activities,
                        builder: (context, snapshot) {
                          activities = snapshot.data;
                          return activities != null &&
                                  activities.any((element) => !element.isReaded)
                              ? const Icon(
                                  Icons.brightness_1,
                                  size: 8.0,
                                  color: Colors.redAccent,
                                )
                              : Container();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageTab extends StatefulWidget {
  const HomePageTab();
  @override
  _HomePageTabState createState() {
    return _HomePageTabState();
  }
}

class _HomePageTabState extends State<HomePageTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 5, length: 6, vsync: this);
  }

  List<Tab> tabs = [
    const Tab(text: 'الكتب'),
    const Tab(text: 'الأعمال اليدوية'),
    const Tab(text: 'التصوير'),
    const Tab(text: 'الخياطة'),
    const Tab(text: 'الطبخ'),
    const Tab(text: 'التجميل'),
  ];

  Widget build(BuildContext context) {
    final colorpink = const Color(0xffFFAADC);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            iconSize: 30,
            onPressed: () {
              showCostumeDialog(context);
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'images/backgroundImage.png',
                ),
                fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
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
                        const SizedBox(height: 100),
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          child: const Text(
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
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: AppBar(
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      elevation: 0,
                      bottom: TabBar(
                        tabs: tabs,
                        controller: _tabController,
                        indicatorColor: colorpink,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color(0xff460053),
                        labelStyle: const TextStyle(
                            fontFamily: 'ae_Sindibad',
                            fontSize: 18,
                            color: Colors.black),
                        isScrollable: true,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 200),
                  child: Container(
                    height: 500,
                    color: const Color(0xffFAFBFD),
                    child: TabBarView(
                      children: List<Widget>.generate(
                        tabs.length,
                        (index) {
                          return CategoryTabView(
                            type: CategoryTabType.values[index],
                            category: tabs[index].text,
                          );
                        },
                      ),
                      controller: _tabController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

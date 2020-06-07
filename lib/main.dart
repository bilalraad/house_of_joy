import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/services/shered_Preference.dart';
import 'package:house_of_joy/ui/alerts.dart';
import 'package:house_of_joy/ui/homePage.dart';
import 'package:house_of_joy/ui/profileUser.dart';
import 'package:house_of_joy/ui/publishAPost.dart';
import 'package:house_of_joy/ui/start.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

User _user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _user = await SharedPrefs().getUser();
  runApp(
    MultiProvider(
      providers: [
        FutureProvider<User>.value(
            value: DatabaseService(_user?.uid).getUserData()),
        StreamProvider<List<Post>>.value(
            value: PostServices('').listenToUserPosts(_user?.uid)),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        color: Colors.black.withOpacity(1),
        theme: ThemeData(primaryColor: Colors.black12),
        initialRoute: '/',
        // showPerformanceOverlay: true,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => Wrapper()),
        home: Wrapper(
          isLogesdIn: _user != null ? true : false,
        ),
      ),
    ),
  );
}

class Wrapper extends StatefulWidget {
  final bool isLogesdIn;
  Wrapper({Key key, this.isLogesdIn}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _currentIndex = 0;
  List<Widget> taps = [
    HomePage(),
    UserProfile(),
    PublishAPsost(),
    Alerts(),
  ];

  @override
  Widget build(BuildContext context) {
    List<Activity> activities;

    return !widget.isLogesdIn
        ? Start()
        : Scaffold(
            body: taps[_currentIndex],
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(
                bottom: 15,
                right: 65,
                left: 65,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  backgroundColor: Color(0xffFCFCFC),
                  selectedItemColor: Color(0xffFD85CB),
                  unselectedItemColor: Color(0xffC5C3E3),
                  iconSize: 35,
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Container(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_pin),
                      title: Container(),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle_outline),
                      title: Container(),
                    ),
                    new BottomNavigationBarItem(
                      title: Container(),
                      icon: Stack(
                        children: <Widget>[
                          Icon(Icons.notifications),
                          Positioned(
                            // draw a red marble
                            top: 0.0,
                            right: 0.0,
                            child: StreamBuilder(
                              stream: DatabaseService(_user.uid).activities,
                              // initialData: initialData ,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                activities = snapshot.data;
                                return activities != null &&
                                        activities
                                            .any((element) => !element.isReaded)
                                    ? Icon(
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

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/services/shered_Preference.dart';
import 'package:house_of_joy/ui/homePage.dart';
import 'package:house_of_joy/ui/start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var user = await SharedPrefs().getUser();
  user != null
      ? runApp(
          new MaterialApp(
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            debugShowCheckedModeBanner: false,
            color: Colors.black.withOpacity(1),
            theme: ThemeData(
              primaryColor: Colors.black12
            ),
            home: HomePage(),
          ),
        )
      : runApp(
          new MaterialApp(
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            debugShowCheckedModeBanner: false,
            home: Start(),
          ),
        );
}

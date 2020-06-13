import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/auth.dart';
import './ui/Auth/start.dart';
import './ui/Home/homeScreen.dart';
import './services/shered_Preference.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      StreamProvider<AuthState>.value(value: Auth.authState.stream),
      FutureProvider<String>.value(value: SharedPrefs().getUserId()),
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
      home: Wrapper(),
    ),
  ));
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<String>(context);
    final authState = Provider.of<AuthState>(context);

    return authState != null && authState == AuthState.lohedIn || userId != null
        ? HomeScreen(userId: userId)
        : Start();
  }
}


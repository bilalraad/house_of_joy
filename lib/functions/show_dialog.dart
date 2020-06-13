import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './creat_route.dart';
import '../models/user.dart';
import '../ui/Home/about.dart';
import '../ui/Auth/logout.dart';
import '../ui/home/editProfile.dart';



///this func. will show a dialog when u press the home icon on the top right corner 
Future<void> showCostumeDialog(BuildContext context) {
  final user = Provider.of<User>(context, listen: false);
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text('تعديل الملف الشخصي'),
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(EditProfile(user: user)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: const Text('تسجيل الخروج'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(Logout()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: const Text('حول التطبيق'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const About()));
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: const Text('حول المبادرة'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            createRoute(const About(isAboutApp: false)));
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: const Text('فريق العمل'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createRoute(Staff()));
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

import 'package:flutter/material.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/ui/Auth/logout.dart';
import 'package:house_of_joy/ui/screens/about.dart';
import 'package:house_of_joy/ui/screens/editProfile.dart';
import 'package:provider/provider.dart';

import 'creat_route.dart';

Future<void> showCostumeDialog(BuildContext context) {
  final user = Provider.of<User>(context, listen: false);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('تعديل الملف الشخصي'),
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(EditProfile(user: user)),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Text('تسجيل الخروج'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(Logout()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Text('حول التطبيق'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => About()));
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Text('حول المبادرة'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context, createRoute(About(isAboutApp: false)));
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Text('فريق العمل'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createRoute(Staff()));
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

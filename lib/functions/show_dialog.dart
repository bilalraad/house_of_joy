  import 'package:flutter/material.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/shered_Preference.dart';
import 'package:house_of_joy/ui/Auth/logout.dart';
import 'package:house_of_joy/ui/aboutCodeForIraq.dart';
import 'package:house_of_joy/ui/aboutTheApplication.dart';
import 'package:house_of_joy/ui/editProfile.dart';
import 'package:house_of_joy/ui/staff.dart';

Future<void> showCostumeDialog(BuildContext context) {
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
                          User user = await SharedPrefs().getUser();

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(user: user),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('تسجيل الخروج'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Logout(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول التطبيق'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutTheApp()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول المبادرة'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutCodeForIraq()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('فريق العمل'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Staff()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
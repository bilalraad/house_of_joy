import 'dart:io';

import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/show_dialog.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:provider/provider.dart';

class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<User>(context);
    var activities = currentUser.activities.reversed.toList();

    return Scaffold(
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
                              SizedBox(
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'النشاطات',
                                    style: TextStyle(
                                        color: Color(0xFFCA39E3),
                                        fontSize: 24,
                                        fontFamily: 'ae_Sindibad'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, i) {
                            DatabaseService(currentUser.uid)
                                .markAllActivitiesAsReaded();
                            return containerAlert(activities[i], currentUser);
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerAlert(Activity activity, User currentUser) {
    return FutureBuilder<User>(
      future: DatabaseService(activity.userId).getUserData(),
      builder: (context, snapshot) {
        var activityByTheUser = snapshot.data;
        return activityByTheUser == null
            ? Container()
            : Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'images/personalPhoto.jpg',
                                ),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${activityByTheUser.fullName}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'ae_Sindibad'),
                      ),
                      SizedBox(width: 20),
                      Text(
                        activity.isLike
                            ? 'قام بالاعجاب بمنشورك'
                            : 'قام بالتعليق على منشورك',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'ae_Sindibad'),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

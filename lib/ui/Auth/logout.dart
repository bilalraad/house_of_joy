import 'package:flutter/material.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/services/shered_Preference.dart';

import '../../main.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() {
    return _LogoutState();
  }
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 251, 253, 75),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  SizedBox(height: 75),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                            color: Color(0xFFCA39E3),
                            fontSize: 24,
                            fontFamily: 'ae_Sindibad'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 95),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(240, 240, 240, 50),
                        boxShadow: [
                          BoxShadow(color: Color(0xffE8E8E8), blurRadius: 10),
                        ]),
                  ),
                  Transform.translate(
                    offset: Offset(0, -5),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'هل تريد تسجيل الخروج؟',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'ae_Sindibad'),
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Color.fromRGBO(240, 240, 240, 50),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffE8E8E8), blurRadius: 10),
                              ]),
                        ),
                        Transform.translate(
                          offset: Offset(0, -5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.4,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: FlatButton(
                              onPressed: () async {
                                await SharedPrefs().deleteUser();
                                await Auth().signOut();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Wrapper(),
                                    ),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text(
                                'نعم',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff06E306),
                                    fontFamily: 'ae_Sindibad'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(child: SizedBox(width: 3)),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Color.fromRGBO(240, 240, 240, 50),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffE8E8E8), blurRadius: 10),
                              ]),
                        ),
                        Transform.translate(
                          offset: Offset(0, -5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.4,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'لا',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xffFF0000),
                                    fontFamily: 'ae_Sindibad'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

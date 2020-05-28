import 'package:flutter/material.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/services/shered_Preference.dart';
import 'package:house_of_joy/ui/start.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() {
    return _LogoutState();
  }
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
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
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          SizedBox(
                            height: 75,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Color(0xFFCA39E3),
                                    fontSize: 24,
                                    fontFamily: 'Cambo'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 80,
              ),
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
                            'Are you sure you want to log out ?',
                            style: TextStyle(fontSize: 18, fontFamily: 'Cambo'),
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
                                      builder: (context) => Start(),
                                    ),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff06E306),
                                    fontFamily: 'Cambo'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 3,
                      ),
                    ),
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
                                    'No',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xffFF0000),
                                        fontFamily: 'Cambo'),
                                  ))),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

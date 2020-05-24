
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget{
  @override
  _ChangePasswordState createState() {
    return _ChangePasswordState();
  }



}
class _ChangePasswordState extends State<ChangePassword>{

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
                              child: Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cansel',style: TextStyle(fontSize: 18),),
                                  ),
                                  Expanded(child: SizedBox(width: 5,),),
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('Done',style: TextStyle(fontSize: 18)),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                            height: 75,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Change password',
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

              Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: <Widget>[

                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 25, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5),
                            ]),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'New Password',
                              hintStyle: TextStyle(
                                  fontFamily: 'Cambo', color: Color(0xffA2A2A2))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 25, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5),
                            ]),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm New password',
                              hintStyle: TextStyle(
                                  fontFamily: 'Cambo', color: Color(0xffA2A2A2))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Text('Check your email & follow the link',style: TextStyle(color: Colors.grey,fontSize: 16),)
                    ],
                  )
              ),
              SizedBox(
                height: 15,
              ),


            ],
          ),
        ],
      ),
    );
  }
  _onPressedDone(){


    Navigator.pop(context);
  }

}
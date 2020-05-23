import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Veritfication extends StatefulWidget {
  @override
  _Veritfication createState() {
    return _Veritfication();
  }
}

class _Veritfication extends State<Veritfication> {
  TextEditingController _controllertxt1 = new TextEditingController();
  TextEditingController _controllertxt2 = new TextEditingController();
  TextEditingController _controllertxt3 = new TextEditingController();
  TextEditingController _controllertxt4 = new TextEditingController();
  FocusNode _focusNode2;
  FocusNode _focusNode3;
  FocusNode _focusNode4;
  FocusNode _focusNode5;
  Color _colorpink = Color(0xffFFAADC);

  @override
  void initState() {
    super.initState();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
    _focusNode5 = FocusNode();
  }

  @override
  void dispose() {
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/backgroundImage.jpg',
                              ),
                              fit: BoxFit.cover)),
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
                                  'Veritfication',
                                  style: TextStyle(
                                      color: _colorpink,
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
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    ' We just sent veritfication link to your email address.Please verify your email and login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       width: 30,
                //       child: TextFormField(
                //         controller: _controllertxt1,
                //         keyboardType: TextInputType.number,
                //         autofocus: true,
                //         decoration: InputDecoration(
                //             enabledBorder: UnderlineInputBorder(
                //                 borderSide: BorderSide(color: _colorpink))),
                //         onChanged: (input) {
                //           FocusScope.of(context).requestFocus(_focusNode2);
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Container(
                //       width: 30,
                //       child: TextField(
                //         keyboardType: TextInputType.number,
                //         focusNode: _focusNode2,
                //         controller: _controllertxt2,
                //         decoration: InputDecoration(
                //             enabledBorder: UnderlineInputBorder(
                //                 borderSide: BorderSide(color: _colorpink))),
                //         onChanged: (input) {
                //           FocusScope.of(context).requestFocus(_focusNode3);
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Container(
                //       width: 30,
                //       child: TextField(
                //         keyboardType: TextInputType.number,
                //         focusNode: _focusNode3,
                //         controller: _controllertxt3,
                //         decoration: InputDecoration(
                //             enabledBorder: UnderlineInputBorder(
                //                 borderSide: BorderSide(color: _colorpink))),
                //         onChanged: (input) {
                //           FocusScope.of(context).requestFocus(_focusNode4);
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Container(
                //       width: 30,
                //       child: TextField(
                //         keyboardType: TextInputType.number,
                //         focusNode: _focusNode4,
                //         controller: _controllertxt4,
                //         decoration: InputDecoration(
                //             enabledBorder: UnderlineInputBorder(
                //                 borderSide: BorderSide(color: _colorpink))),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 30,
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width / 1.8,
                //   height: 45,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(50)),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(color: Colors.black12, blurRadius: 5),
                //       ]),
                //   child: RaisedButton(
                //     focusNode: _focusNode5,
                //     onPressed: () => {
                //       //  Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()),),
                //     },
                //     color: _colorpink,
                //     child: Text(
                //       'Verify',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 24,
                //       ),
                //     ),
                //     padding: const EdgeInsets.all(5.0),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // bool inputText(String input) {
  //   if (input == '0' ||
  //       input == '1' ||
  //       input == '2' ||
  //       input == '3' ||
  //       input == '4' ||
  //       input == '5' ||
  //       input == '6' ||
  //       input == '7' ||
  //       input == '8' ||
  //       input == '9') {
  //     return true;
  //   } else
  //     return false;
  // }
}

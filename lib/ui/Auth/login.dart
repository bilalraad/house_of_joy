import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/ui/Auth/forgetPassword.dart';
import 'package:house_of_joy/ui/homePage.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  bool test = false;
  bool _obscureText = true;
  bool isUsername = false;
  bool loading = false;

  final userNameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailOrUNError = '';
  String passwordNError = '';

  @override
  void dispose() {
    userNameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget showError(String val) {
    return val.isNotEmpty
        ? Text(
            val,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.red,
            ),
          )
        : Container();
  }

  int _validate() {
    String userNameOrEmail = userNameOrEmailController.text;
    String password = passwordController.text;
    int errors = 0;

    var emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (userNameOrEmail.isEmpty) {
      emailOrUNError = 'الرجاء ملء الحقل';
      errors++;
    } else if (!emailRegEx.hasMatch(userNameOrEmail)) {
      isUsername = true;
    }

    if (password.isEmpty) {
      passwordNError = 'الرجاء ادخال كلمة السر';
      errors++;
    } else if (password.length < 6) {
      passwordNError = 'كلمة السر خاطئة';
      errors++;
    }
    setState(() {});
    return errors;
  }

  @override
  Widget build(BuildContext context) {
    bool showOrHidenPassword() {
      setState(() {
        if (test == true) {
          test = false;
          _obscureText = true;
        } else {
          test = true;
          _obscureText = false;
        }
      });
      return test;
    }

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
                                'Login',
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
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                padding:
                    EdgeInsets.only(top: 4, left: 25, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ]),
                child: TextField(
                  controller: userNameOrEmailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Username or email',
                    hintStyle: TextStyle(
                        fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                  ),
                  onChanged: (value) {
                    if (emailOrUNError.isNotEmpty)
                      setState(() {
                        emailOrUNError = '';
                      });
                  },
                ),
              ),
              showError(emailOrUNError),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                padding:
                    EdgeInsets.only(top: 4, left: 25, right: 16, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ]),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: TextField(
                        key: ValueKey('txtPassword'),
                        obscureText: _obscureText,
                        onChanged: (value) {
                          if (passwordNError.isNotEmpty)
                            setState(() {
                              passwordNError = '';
                            });
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      child: IconButton(
                          icon: test
                              ? Icon(Icons.visibility, color: Color(0xffFFAADC))
                              : Icon(Icons.visibility_off,
                                  color: Color(0xffFFAADC)),
                          onPressed: () {
                            showOrHidenPassword();
                          }),
                    )
                  ],
                ),
              ),
              showError(passwordNError),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ));
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Color(0xFFCA39E3),
                          fontSize: 16,
                          fontFamily: 'Cambo'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ]),
                child: RaisedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            loading = true;
                          });
                          var errors = _validate();
                          if (errors == 0) {
                            var error = await Auth().signIn(
                              isUsername ? '' : userNameOrEmailController.text,
                              passwordController.text,
                              isUsername ? userNameOrEmailController.text : '',
                            );
                            if (error == null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              showFlushSnackBar(context,error);
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                  color: Color(0xffFFAADC),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don‘t have an account?',
                      style: TextStyle(fontSize: 16, fontFamily: 'Cambo'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        ' Sign in',
                        style: TextStyle(
                          color: Color(0xffFFAADC),
                          fontSize: 14,
                          fontFamily: 'Cambo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

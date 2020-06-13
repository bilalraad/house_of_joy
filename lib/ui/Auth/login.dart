import 'package:flutter/material.dart';

import '../../main.dart';
import '../Auth/signUp.dart';
import '../../services/auth.dart';
import '../Auth/forgetPassword.dart';
import '../../functions/validations.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  var _obscureText = true;
  var _isUsername = false;
  var _loading = false;
  var _emailOrUNError = '';
  var _passwordNError = '';

  final _userNameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget showError(String val) {
    return val.isNotEmpty
        ? Text(
            val,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.red,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    showOrHidenPassword() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'images/backgroundImage.png',
                            ),
                            fit: BoxFit.fitWidth)),
                    child: Container(
                      color: const Color.fromRGBO(250, 251, 253, 75),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          const SizedBox(height: 75),
                          const Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'تسجيل الدخول',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Color(0xFFCA39E3),
                                    fontSize: 24,
                                    fontFamily: 'ae_Sindibad'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 45,
                  padding: const EdgeInsets.only(right: 25),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ]),
                  child: TextField(
                    controller: _userNameOrEmailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'البريد الالكتروني او اسم المستخدم',
                      hintStyle: TextStyle(
                          fontFamily: 'ae_Sindibad', color: Color(0xffA2A2A2)),
                    ),
                    onChanged: (value) {
                      if (_emailOrUNError.isNotEmpty) {
                        setState(() {
                          _emailOrUNError = '';
                        });
                      }
                    },
                  ),
                ),
              ),
              showError(_emailOrUNError),
              const SizedBox(height: 15),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 45,
                  padding: const EdgeInsets.only(left: 16, right: 25),
                  decoration: const BoxDecoration(
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
                          key: const ValueKey('txtPassword'),
                          obscureText: _obscureText,
                          onChanged: (value) {
                            if (_passwordNError.isNotEmpty) {
                              setState(() {
                                _passwordNError = '';
                              });
                            }
                          },
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'كلمة السر',
                            hintStyle: TextStyle(
                                fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        child: IconButton(
                            icon: _obscureText
                                ? const Icon(Icons.visibility,
                                    color: Color(0xffFFAADC))
                                : const Icon(Icons.visibility_off,
                                    color: Color(0xffFFAADC)),
                            onPressed: showOrHidenPassword),
                      ),
                    ],
                  ),
                ),
              ),
              showError(_passwordNError),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ));
                    },
                    child: const Text(
                      'هل نسيت كلمة السر؟',
                      style: TextStyle(
                          color: Color(0xFFCA39E3),
                          fontSize: 16,
                          fontFamily: 'ae_Sindibad'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ]),
                child: RaisedButton(
                  onPressed: _loading ? null : _onLogInPressd,
                  color: const Color(0xffFFAADC),
                  child: const Text(
                    'تسجيل',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'ae_Sindibad'),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'انشاء حساب',
                          style:
                              TextStyle(color: Color(0xffFFAADC), fontSize: 18),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(fontSize: 20),
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

  void _onLogInPressd() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
    });
    var errors = _validate();
    if (errors == 0) {
      var error = await Auth().signIn(
        _isUsername ? '' : _userNameOrEmailController.text,
        _passwordController.text,
        _isUsername ? _userNameOrEmailController.text : '',
      );
      if (error == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
          (route) => false,
        );
      } else {
        showFlushSnackBar(context, error);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  int _validate() {
    final userNameOrEmail = _userNameOrEmailController.text;
    final password = _passwordController.text;
    var errors = 0;

    var emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (userNameOrEmail.isEmpty) {
      _emailOrUNError = 'الرجاء ملء الحقل';
      errors++;
    } else if (!emailRegEx.hasMatch(userNameOrEmail)) {
      _isUsername = true;
    }

    if (password.isEmpty) {
      _passwordNError = 'الرجاء ادخال كلمة السر';
      errors++;
    } else if (password.length < 6) {
      _passwordNError = 'كلمة السر خاطئة';
      errors++;
    }
    setState(() {});
    return errors;
  }
}

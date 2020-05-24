import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/ui/Auth/login.dart';
import 'package:house_of_joy/ui/Auth/veritfication.dart';
import 'package:house_of_joy/ui/homePage.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUp createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool lenth = false;
  bool char = false;
  bool insertPassord = false;
  bool loading = false;

  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNoController = TextEditingController();
  String emailErrorText = '';
  String passwordErrorText = '';
  String userNameErrorText = '';
  String numberErrorText = '';
  String nameErrorText = '';

  @override
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNoController.dispose();
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

  Future<int> _validate() async {
    var fullName = fullNameController.text;
    var userName = userNameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var phoneNo = phoneNoController.text;
    emailErrorText = '';
    passwordErrorText = '';
    userNameErrorText = '';
    numberErrorText = '';
    nameErrorText = '';
    int errors = 0;

    if (fullName == null || fullName.isEmpty) {
      nameErrorText = "الرجاء ادخال الاسم";
      errors++;
    } else if (fullName.length < 8) {
      nameErrorText = "رجاءا ادخل الاسم الكامل";
      errors++;
    }
    var userNrexEx =
        RegExp(r"^(?=.{4,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$");
    bool isUserNameExcist =
        await DatabaseService('').checkUserNameExcist(userName);

    if (userName.isNotEmpty) {
      if (isUserNameExcist != null && isUserNameExcist) {
        userNameErrorText = "اسم المستخدم تم اختياره سابقا";
        errors++;
      } else if (userName.length <= 4) {
        userNameErrorText = "اسم المستخدم قصير جدا";
        errors++;
      } else if (!userNrexEx.hasMatch(userName)) {
        userNameErrorText =
            "يجب ان  لا يحتوي على نقط او فراغات مثلا: sara_ali2";
        errors++;
      }
    }

    var emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (email == null || email.isEmpty) {
      emailErrorText = "الرجاء ادخال الايميل";
      errors++;
    } else if (!emailRegEx.hasMatch(email)) {
      emailErrorText = "الرجاء ادخال ايميل صحيح";
      errors++;
    }

    if (password == null || password.isEmpty) {
      passwordErrorText = "الرجاء ادخال الباسوورد";
      errors++;
    } else if (password.length < 6) {
      passwordErrorText = "رجاءا ادخال باسوورد اقوى";
      errors++;
    }

    var phoneRegEx = RegExp(r"07[3-9][0-9]{8}");
    if (phoneNo.isNotEmpty && !phoneRegEx.hasMatch(phoneNo) ||
        phoneNo.length > 11) {
      numberErrorText = "الرقم غير صحيح";
      errors++;
    }

    setState(() {});
    return errors;
  }

  @override
  Widget build(BuildContext context) {
    void showOrHidenPassword() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    print('hello');

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
                                icon: Icon(Icons.arrow_back),
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
                                'Sign up',
                                style: TextStyle(
                                    color: Color(0xFFCA39E3),
                                    fontSize: 26,
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
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 40),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
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
                        child: TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
                            hintStyle: TextStyle(
                                fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                          ),
                        ),
                      ),
                      showError(nameErrorText),
                      SizedBox(
                        height: 15,
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
                        child: TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                            hintStyle: TextStyle(
                                fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                          ),
                        ),
                      ),
                      showError(userNameErrorText),
                      SizedBox(
                        height: 15,
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
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                          ),
                        ),
                      ),
                      showError(emailErrorText),
                      SizedBox(
                        height: 15,
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
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Cambo',
                                      color: Color(0xffA2A2A2)),
                                ),
                                onChanged: checkChangePassword,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              child: IconButton(
                                icon: !_obscureText
                                    ? Icon(Icons.visibility,
                                        color: Color(0xffFFAADC))
                                    : Icon(Icons.visibility_off,
                                        color: Color(0xffFFAADC)),
                                onPressed: () {
                                  showOrHidenPassword();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      showError(passwordErrorText),
                      SizedBox(
                        height: 15,
                      ),
                      checkYourPassword(context),
                      SizedBox(
                        height: 15,
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
                        child: TextFormField(
                          controller: phoneNoController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone number',
                              hintStyle: TextStyle(
                                  fontFamily: 'Cambo',
                                  color: Color(0xffA2A2A2))),
                        ),
                      ),
                      showError(numberErrorText),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: RaisedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var errorss = await _validate();
                                  print(errorss);
                                  if (errorss == 0) {
                                    final number = phoneNoController
                                            .text.isNotEmpty
                                        ? '+964${phoneNoController.text.substring(1)}'
                                        : '';
                                    var tempUser = User(
                                      uid: '', //will get it from firesbase
                                      fullName: fullNameController.text,
                                      email: emailController.text,
                                      phoneNo: number,
                                      userName: userNameController.text,
                                    );
                                    var isSignedUp = await Auth().signUp(
                                        tempUser.email,
                                        passwordController.text,
                                        tempUser);

                                    if (isSignedUp) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Veritfication(),
                                        ),
                                      );
                                    }
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                          color: Color(0xffFFAADC),
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.black26,
                              ),
                            ),
                            SizedBox(
                                width: 30,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'OR',
                                    style: TextStyle(fontFamily: 'Cambo'),
                                  ),
                                )),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.black26,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: FlatButton(
                                onPressed: loading
                                    ? null
                                    : () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        var isSignedIn =
                                            await Auth().signInWithFacebook();
                                        if (isSignedIn) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                color: Color(0xff6B6BD9),
                                disabledColor: Colors.grey,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 5, right: 7, top: 5),
                                      child: Icon(
                                        faf.FontAwesomeIcons.facebookF,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Facebook',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Color(0xFFCA39E3)),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                width: MediaQuery.of(context).size.width / 3,
                                child: FlatButton(
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          var isSignedIn =
                                              await Auth().signInWithGoogle();

                                          if (isSignedIn) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false,
                                            );
                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                        },
                                  color: Color(0xffffffff),
                                  disabledColor: Colors.grey,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 3, bottom: 3, right: 5),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            child: Image(
                                              image: AssetImage(
                                                  'images/google.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Text(
                                        'Google',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 24),
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already have account?',
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              ),
                              child: Text(
                                ' Login',
                                style: TextStyle(
                                    color: Color(0xffFFAADC),
                                    fontFamily: 'Cambo'),
                              ),
                            ),
                          ],
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
        ],
      ),
    );
  }

  void checkChangePassword(String input) {
    if (input.length > 7)
      lenth = true;
    else
      lenth = false;
    int x = 0;
    for (int i = 0; i < input.length; i++)
      if (input.codeUnitAt(i) > 66 &&
          input.codeUnitAt(input.length - 1) < 122) {
        x++;
      }

    if (x > 0)
      char = true;
    else
      char = false;

    if (input.isEmpty)
      insertPassord = false;
    else
      insertPassord = true;

    setState(() {});
  }

  Widget checkYourPassword(BuildContext context) {
    bool one = false;
    bool two = false;
    if (lenth || char) one = true;
    if (lenth && char) two = true;
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: insertPassord ? Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: one ? Color(0xffFFAADC) : Colors.grey,
                shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: one ? Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: two ? Color(0xffFFAADC) : Colors.grey,
                shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: two ? Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

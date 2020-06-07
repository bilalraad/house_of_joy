import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/ui/Auth/login.dart';
import 'package:house_of_joy/ui/Auth/veritfication.dart';
import 'package:house_of_joy/ui/Costume_widgets/bloc_text_form_field.dart';
import '../../main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  bool _obscureText = true;
  bool lenth = false;
  bool char = false;
  bool insertPassord = false;
  bool loading = false;
  FieldValidationFormBloc _formBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          BlocProvider(
            create: (context) => FieldValidationFormBloc(),
            child: Builder(builder: (context) {
              _formBloc = BlocProvider.of<FieldValidationFormBloc>(context);
              return Column(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        BlocTextFormField(
                          hint: 'Full Name',
                          textFieldBloc: _formBloc.fullName,
                        ),
                        BlocTextFormField(
                          hint: 'User Name',
                          textFieldBloc: _formBloc.username,
                        ),
                        BlocTextFormField(
                          hint: 'Email',
                          textFieldBloc: _formBloc.email,
                        ),
                        BlocTextFormField(
                          hint: 'Password',
                          textFieldBloc: _formBloc.password,
                          obscure: _obscureText,
                          onChanged: checkChangePassword,
                        ),
                        SizedBox(
                          height: 30,
                          child: checkYourPassword(context),
                        ),
                        BlocTextFormField(
                          hint: 'Phone number',
                          textFieldBloc: _formBloc.number,
                        ),
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
                                    _formBloc.submit();
                                    var data = _formBloc.onSubmitting(
                                      hasEmail: true,
                                      hasFullName: true,
                                      hasNumber: true,
                                      hasPassword: true,
                                      hasUsername: true,
                                    );
                                    if (data != null) {
                                      final number = data['number'].isNotEmpty
                                          ? '+964${data['number'].substring(1)}'
                                          : '';
                                      var tempUser = User(
                                        uid: '', //will get it from firesbase
                                        fullName: data['fullName'],
                                        email: data['email'],
                                        phoneNo: number,
                                        userName: data['username'],
                                      );
                                      var error = await Auth().signUp(
                                        tempUser.email,
                                        data['password'],
                                        tempUser,
                                      );

                                      if (error == null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Veritfication(),
                                          ),
                                        );
                                      } else {
                                        showFlushSnackBar(context, error);
                                      }
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                            color: Color(0xffFFAADC),
                            child: Text(
                              'Sign up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
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
                                          var error =
                                              await Auth().signInWithFacebook();
                                          if (error == null &&
                                              error.isNotEmpty) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Wrapper(
                                                      isLogesdIn: true)),
                                              (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            if (error.isNotEmpty)
                                              showFlushSnackBar(context, error);
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
                                            var error =
                                                await Auth().signInWithGoogle();

                                            if (error == null) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Wrapper(
                                                            isLogesdIn: true)),
                                                (Route<dynamic> route) => false,
                                              );
                                            } else {
                                              showFlushSnackBar(context, error);
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
                                              color: Colors.black,
                                              fontSize: 24),
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
                                onTap: () => Navigator.pop(context),
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
                ],
              );
            }),
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

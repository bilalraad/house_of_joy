import 'package:flutter/material.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/show_overlay.dart';
import 'package:house_of_joy/ui/Costume_widgets/costume_text_field.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() {
    return _ForgetPassword();
  }
}

class _ForgetPassword extends State<ForgetPassword> {
  final Color _colorpink = Color(0xffFFAADC);
  final emailController = TextEditingController();
  String emailErrorText = '';
  bool loading = false;
  int error = 0;

  @override
  void dispose() {
    emailController.dispose();
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
                                  'Forgot Password?',
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
                    'Enter the email address associated with your acoount.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    'We will email you a link to reset your password.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: emailController,
                  hint: 'Your Email',
                  onChanged: (newValue) => setState(() => emailErrorText = ''),
                ),
                emailErrorText.isNotEmpty
                    ? Text(
                        emailErrorText,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: RaisedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() {
                              loading = true;
                            });
                            var emailRegEx = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            var email = emailController.text;

                            if (email == null || email.isEmpty) {
                              emailErrorText = "الرجاء ادخال الايميل";
                              error++;
                            } else if (!emailRegEx.hasMatch(email)) {
                              emailErrorText = "الايميل غير صحيح";
                              error++;
                            } else if (!await DatabaseService('')
                                .checkEmailExcist(email)) {
                              emailErrorText = "الايميل غير موجود";
                              error++;
                            }
                            if (error != 0) {
                              setState(() {});
                              print('cc');
                            } else {
                              Auth().resetPassword(email);
                              emailController.clear();
                              showOverlay(
                                  context: context,
                                  text: 'تم ارسال رسالة الى الايميل الخاص بك');
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                    color: _colorpink,
                    child: Text(
                      'Send',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

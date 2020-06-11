import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/show_overlay.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/services/data_base.dart';
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
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
                                  'images/backgroundImage.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Container(
                          color: Color.fromRGBO(250, 251, 253, 75),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              SizedBox(height: 75),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'تاكيد حسابك',
                                    style: TextStyle(
                                      color: _colorpink,
                                      fontSize: 24,
                                      fontFamily: 'ae_Sindibad',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, right: 30),
                      child: Text(
                        'ادخل بريدك الالكتروني المرتبط بحسابك',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ae_Sindibad',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 20),
                    child: Text(
                      'سوف نرسل لك رابط يمكنك استخدامه لتغيير كلمة المرور.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: emailController,
                    hint: 'بريدك الالكتروني',
                    onChanged: (newValue) =>
                        setState(() => emailErrorText = ''),
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
                  SizedBox(height: 30),
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
                      onPressed: loading ? null : _onSendPressed,
                      color: _colorpink,
                      child: Text(
                        'ارسال',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendPressed() async {
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
    } else if (!await DatabaseService('').checkEmailExcist(email)) {
      emailErrorText = "الايميل غير موجود";
      error++;
    }
    if (error != 0) {
      setState(() {});
    } else {
      Auth().resetPassword(email);
      emailController.clear();
      showOverlay(
          context: context, text: 'تم ارسال رسالة الى الايميل الخاص بك');
    }
    setState(() {
      loading = false;
    });
  }
}

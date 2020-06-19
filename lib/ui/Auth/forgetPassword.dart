import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/data_base.dart';
import '../../functions/show_overlay.dart';
import '../Costume_widgets/loading_dialog.dart';
import '../Costume_widgets/costume_text_field.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() {
    return _ForgetPassword();
  }
}

class _ForgetPassword extends State<ForgetPassword> {
  final _colorpink = const Color(0xffFFAADC);
  final _emailController = TextEditingController();
  var _emailErrorText = '';
  var _loading = false;
  var _error = 0;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: ModalProgress(
          inAsyncCall: _loading,
          costumeIndicator: const LoadingDialog(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          const SizedBox(height: 75),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
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
                          const SizedBox(height: 20),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Align(
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
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, right: 20),
                        child: Text(
                          'سوف نرسل لك رابط يمكنك استخدامه لتغيير كلمة المرور.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _emailController,
                        hint: 'بريدك الالكتروني',
                        onChanged: (newValue) =>
                            setState(() => _emailErrorText = ''),
                      ),
                      _emailErrorText.isNotEmpty
                          ? Text(
                              _emailErrorText,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(color: Colors.red),
                            )
                          : Container(),
                      const SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        height: 45,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5),
                          ],
                        ),
                        child: RaisedButton(
                          onPressed: _loading ? null : _onSendPressed,
                          color: _colorpink,
                          child: const Text(
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
        ),
      ),
    );
  }

  void _onSendPressed() async {
    setState(() {
      _loading = true;
    });
    var emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    var email = _emailController.text;

    if (email == null || email.isEmpty) {
      _emailErrorText = "الرجاء ادخال البريد الالكتروني";
      _error++;
    } else if (!emailRegEx.hasMatch(email)) {
      _emailErrorText = "البريد الالكتروني غير صحيح";
      _error++;
    } else if (!await DatabaseService('').checkEmailExcist(email)) {
      _emailErrorText = "البريد الالكتروني غير موجود";
      _error++;
    }
    if (_error != 0) {
      setState(() {});
    } else {
      Auth().resetPassword(email);
      _emailController.clear();
      showOverlay(
          context: context,
          text: 'تم ارسال رسالة الى البريد الالكتروني الخاص بك');
    }
    setState(() {
      _loading = false;
    });
  }
}

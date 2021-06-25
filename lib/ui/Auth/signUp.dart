import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import './veritfication.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../functions/validations.dart';
import '../Costume_widgets/loading_dialog.dart';
import '../Costume_widgets/bloc_text_form_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  final _obscureText = true;
  var _lenth = false;
  var _char = false;
  var _insertPassord = false;
  var _loading = false;
  FieldValidationFormBloc _formBloc;

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
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => FieldValidationFormBloc(),
              child: Builder(builder: (context) {
                _formBloc = BlocProvider.of<FieldValidationFormBloc>(context);
                return Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SafeArea(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        const SizedBox(height: 75),
                        const Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'أنشاء حساب',
                              style: TextStyle(
                                  color: Color(0xFFCA39E3),
                                  fontSize: 26,
                                  fontFamily: 'ae_Sindibad'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 15),
                          BlocTextFormField(
                            hint: 'الاسم الكامل',
                            textFieldBloc: _formBloc.fullName,
                          ),
                          BlocTextFormField(
                            hint: 'اسم المستخدم',
                            textFieldBloc: _formBloc.username,
                          ),
                          BlocTextFormField(
                            hint: 'البريد الالكتروني',
                            textFieldBloc: _formBloc.email,
                          ),
                          BlocTextFormField(
                            hint: 'كلمة السر',
                            textFieldBloc: _formBloc.password,
                            obscure: _obscureText,
                            onChanged: checkChangePassword,
                          ),
                          BlocTextFormField(
                            hint: 'تاكيد كلمة السر',
                            textFieldBloc: _formBloc.passwordConfirm,
                          ),
                          SizedBox(
                            height: 30,
                            child: checkYourPassword(context),
                          ),
                          BlocTextFormField(
                            hint: 'رقم الهاتف',
                            textFieldBloc: _formBloc.number,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.5,
                            child: const Text(
                              'يجب ان يكون الرقم مربوط بالواتساب الخاص بك ليتمكن\n المشترون من مراسلتك',
                              style: TextStyle(color: Colors.grey),
                              // textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: ElevatedButton(
                              onPressed: _loading ? null : onSignUpPressed,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                primary: const Color(0xffFFAADC),
                              ),
                              child: const Text(
                                'انشاء حساب',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'ae_Sindibad'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                const SizedBox(
                                    width: 30,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('OR'),
                                    )),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'تسجيل دخول',
                                    style: TextStyle(
                                        color: Color(0xffFFAADC),
                                        fontFamily: 'ae_Sindibad'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'لديك حساب قديم؟',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void onSignUpPressed() async {
    setState(() => _loading = true);
    _formBloc.submit();
    var data = _formBloc.onSubmitting(
      hasEmail: true,
      hasFullName: true,
      hasNumber: true,
      hasPassword: true,
      hasUsername: true,
    );
    if (data != null) {
      final number =
          data['number'].isNotEmpty ? '+964${data['number'].substring(1)}' : '';
      var tempUser = UserModel(
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
            builder: (context) => Veritfication(),
          ),
        );
      } else {
        showFlushSnackBar(context, error);
      }
    }
    setState(() => _loading = false);
  }

  void checkChangePassword(String input) {
    if (input.length > 7) {
      _lenth = true;
    } else {
      _lenth = false;
    }
    var x = 0;
    for (var i = 0; i < input.length; i++) {
      if (input.codeUnitAt(i) > 66 &&
          input.codeUnitAt(input.length - 1) < 122) {
        x++;
      }
    }

    if (x > 0) {
      _char = true;
    } else {
      _char = false;
    }

    if (input.isEmpty) {
      _insertPassord = false;
    } else {
      _insertPassord = true;
    }

    setState(() {});
  }

  Widget checkYourPassword(BuildContext context) {
    var one = false;
    var two = false;
    if (_lenth || _char) one = true;
    if (_lenth && _char) two = true;
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _insertPassord ? const Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: one ? const Color(0xffFFAADC) : Colors.grey,
                shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: one ? const Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: two ? const Color(0xffFFAADC) : Colors.grey,
                shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: two ? const Color(0xffFFAADC) : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

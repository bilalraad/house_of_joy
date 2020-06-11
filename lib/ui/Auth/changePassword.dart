import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/services/auth.dart';
import 'package:house_of_joy/ui/Costume_widgets/bloc_text_form_field.dart';
import 'package:house_of_joy/ui/Costume_widgets/costume_text_field.dart';
import 'package:house_of_joy/ui/Costume_widgets/loading_dialog.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  FieldValidationFormBloc _formBloc;
  String oldPasswordErrorText = '';

  @override
  void dispose() {
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          _formBloc = BlocProvider.of<FieldValidationFormBloc>(context);
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'images/backgroundImage.png',
                    ),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Color.fromRGBO(250, 251, 253, 75),
              body: FutureBuilder<bool>(
                future: Auth().isSigendInWithEmailAndPassword(),
                builder: (context, snapshot) {
                  var isChangeable = snapshot.hasData ? snapshot.data : true;
                  return snapshot == null
                      ? LoadingDialog()
                      : ListView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'الغاء',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontFamily:
                                                      'ae_Sindibad'),
                                            ),
                                          ),
                                          Expanded(
                                              child:
                                                  SizedBox(width: 5)),
                                          FlatButton(
                                            onPressed: isChangeable
                                                ? () {
                                                    _formBloc.submit();
                                                    var data = _formBloc
                                                        .onSubmitting(
                                                      hasPassword: true,
                                                      hasConfirmPassword:
                                                          true,
                                                    );

                                                    return _onPressedDone(
                                                        data['Password'] ??
                                                            '');
                                                  }
                                                : null,
                                            child: Text(
                                              'تم',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontFamily:
                                                      'ae_Sindibad'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 75),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 30),
                                      child: Align(
                                        alignment:
                                            Alignment.bottomRight,
                                        child: Text(
                                          'تغيير كلمة السر',
                                          style: TextStyle(
                                              color: Color(0xFFCA39E3),
                                              fontSize: 24,
                                              fontFamily:
                                                  'ae_Sindibad'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 60),
                                      Form(
                                        key: _formKey,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: CustomTextField(
                                            key: _formKey,
                                            controller: oldPasswordController,
                                            validator: (value) {
                                              oldPasswordErrorText =
                                                  validatePassword(value);
                                              if (oldPasswordErrorText != null)
                                                return oldPasswordErrorText;
                                              return null;
                                            },
                                            hint: 'كلمة السر القديمة',
                                            readOnly: !isChangeable,
                                          ),
                                        ),
                                      ),
                                      BlocTextFormField(
                                        hint: 'كلمة السر جديدة',
                                        textFieldBloc: _formBloc.password,
                                        obscure: true,
                                      ),
                                      BlocTextFormField(
                                        hint: 'تاكيد كلمة السر الجديدة',
                                        textFieldBloc:
                                            _formBloc.passwordConfirm,
                                        // obscure: true,
                                      ),
                                      SizedBox(height: 20),
                                      !isChangeable
                                          ? Text(
                                              'لا يمكنتك تغيير كلمة المرور لانك سجلت باستخدام كوكل او فبس بوك',
                                              textAlign: TextAlign.center,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _onPressedDone(String newPassord) async {
    if (_formKey.currentState.validate() && newPassord.isNotEmpty) {
      var error =
          await Auth().changePassword(oldPasswordController.text, newPassord);
      if (error == null)
        Navigator.of(context).pop();
      else
        showFlushSnackBar(context, error);
    }
  }
}

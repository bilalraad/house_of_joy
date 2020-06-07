import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:house_of_joy/functions/validations.dart';

class FieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final passwordConfirm = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final fullName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final number = TextFieldBloc();

  FieldValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [
      username,
      email,
      password,
      fullName,
      number,
      passwordConfirm,
    ]);
    fullName.addValidators([validateFullName]);
    password.addValidators([validatePassword]);
    email.addAsyncValidators([validateEmail]);
    number.addValidators([validatePhoneNo]);
    passwordConfirm
        .addValidators([FieldBlocValidators.confirmPassword(password)]);

    username.addAsyncValidators([validateUsername]);
  }

  @override
  Map<String, String> onSubmitting({
    bool hasEmail = false,
    bool hasPassword = false,
    bool hasConfirmPassword = false,
    bool hasNumber = false,
    bool hasUsername = false,
    bool hasFullName = false,
  }) {
    Map<String, String> data = {
      'email': email.value,
      'password': password.value,
      'fullName': fullName.value,
      'username': username.value,
      'number': number.value,
    };
    if (!email.state.isValid && hasEmail) {
      return null;
    } else if (!hasEmail) {
      data.remove('email');
    }
    if (!password.state.isValid && hasPassword) {
      return null;
    } else if (!hasPassword) {
      data.remove('password');
    }
    if (!passwordConfirm.state.isValid && hasConfirmPassword) {
      return null;
    }
    if (!fullName.state.isValid && hasFullName) {
      return null;
    } else if (!hasFullName) {
      data.remove('fullName');
    }
    if (!username.state.isValid && hasUsername) {
      return null;
    } else if (!hasUsername) {
      data.remove('username');
    }
    if (!number.state.isValid && hasNumber) {
      return null;
    } else if (!hasNumber) {
      data.remove('number');
    }
    return data;
  }
}

class BlocTextFormField extends StatelessWidget {
  final FormBlocSubmitting<String, String> onSubmitting;
  final FormBlocSuccess<String, String> onSuccsess;
  final FormFieldSetter<String> onChanged;
  final String hint;
  final bool obscure;
  final TextFieldBloc<dynamic> textFieldBloc;

  const BlocTextFormField({
    this.onSubmitting,
    this.onSuccsess,
    this.hint,
    this.textFieldBloc,
    this.obscure = false,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3), width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            child: FormBlocListener<FieldValidationFormBloc, String, String>(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.15,
                child: TextFieldBlocBuilder(
                  onChanged: onChanged,
                  // obscureText: obscure,
                  textFieldBloc: textFieldBloc,
                  suffixButton: obscure
                      ? SuffixButton.obscureText
                      : SuffixButton.asyncValidating,
                  obscureTextFalseIcon:
                      Icon(Icons.visibility, color: Color(0xffFFAADC)),
                  obscureTextTrueIcon:
                      Icon(Icons.visibility_off, color: Color(0xffFFAADC)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: 'Cambo',
                      color: Color(0xffA2A2A2),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



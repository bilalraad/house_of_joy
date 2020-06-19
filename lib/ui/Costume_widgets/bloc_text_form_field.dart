import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../functions/validations.dart';

///this is a costume text feid that  can accepte aysnc validators
class FieldValidationFormBloc extends FormBloc<String, String> {
  final TextFieldBloc username = TextFieldBloc(
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  final TextFieldBloc email = TextFieldBloc(
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  final TextFieldBloc password = TextFieldBloc();

  final TextFieldBloc passwordConfirm = TextFieldBloc();

  final TextFieldBloc fullName = TextFieldBloc();
  final TextFieldBloc number = TextFieldBloc();

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

  ///this will check the validation of the wanted data and return them if validated
  @override
  Map<String, String> onSubmitting({
    bool hasEmail = false,
    bool hasPassword = false,
    bool hasConfirmPassword = false,
    bool hasNumber = false,
    bool hasUsername = false,
    bool hasFullName = false,
  }) {
    final data = {
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
                  borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0), width: 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0), width: 0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: FormBlocListener<FieldValidationFormBloc, String, String>(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    // height: 55,
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                      minHeight: 40,
                    ),
                    child: TextFieldBlocBuilder(
                      onChanged: onChanged,
                      // obscureText: obscure,
                      textFieldBloc: textFieldBloc,
                      suffixButton: obscure
                          ? SuffixButton.obscureText
                          : SuffixButton.asyncValidating,
                      obscureTextFalseIcon: const Icon(Icons.visibility,
                          color: Color(0xffFFAADC)),
                      obscureTextTrueIcon: const Icon(Icons.visibility_off,
                          color: Color(0xffFFAADC)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: hint,
                        hintStyle: const TextStyle(
                          fontFamily: 'ae_Sindibad',
                          color: Color(0xffA2A2A2),
                        ),
                      ),
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

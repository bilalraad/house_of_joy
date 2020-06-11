import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/services/data_base.dart';

Future<String> validateEmail(String email) async {
  var emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if (email == null || email.isEmpty) {
    return "الرجاء ادخال البريد الالكتروني";
  } else if (!emailRegEx.hasMatch(email)) {
    return "الرجاء ادخال بريد الكتروني صحيح";
  } else if (await DatabaseService('').checkEmailExcist(email)) {
    return 'البريد الالكتروني مستخدم سابقا';
  }
  return null;
}

String validatePassword(String password) {
  if (password == null || password.isEmpty) {
    return "الرجاء ادخال كلمة السر";
  } else if (password.length < 6) {
    return 'كلمة السر قصيرة جدا';
  } else if (password.contains(' '))
    return 'يجب ان لا تحتوي كلمة السر على مسافات';
  return null;
}

Future<String> validateUsername(String userName) async {
  var userNrexEx =
      RegExp(r"^(?=.{4,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$");
  bool isUserNameExcist =
      await DatabaseService('').checkUserNameExcist(userName);
  if (userName.isNotEmpty) {
    if (isUserNameExcist != null && isUserNameExcist) {
      return "اسم المستخدم تم اختياره سابقا";
    } else if (userName.length <= 4) {
      return "اسم المستخدم قصير جدا";
    } else if (!userNrexEx.hasMatch(userName)) {
      return "يجب ان  لا يحتوي اسم المستخدم على نقط او فراغات";
    }
  }
  return null;
}

String validatePhoneNo(String phoneNo) {
  var phoneRegEx = RegExp(r"07[3-9][0-9]{8}");
  if (phoneNo.isEmpty == null || phoneNo.isEmpty) {
    return "رجاءا ادخل رقم الهاتف";
  } else if (!phoneRegEx.hasMatch(phoneNo) || phoneNo.length > 11) {
    return "الرقم غير صحيح";
  }
  return null;
}

String validateFullName(String fullName) {
  if (fullName == null || fullName.isEmpty) {
    return "الرجاء ادخال الاسم";
  } else if (fullName.length < 8) {
    return "الاسم قصير جدا";
  }
  return null;
}

void showFlushSnackBar(BuildContext context, String messege) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Text(
      messege,
      textDirection: TextDirection.rtl,
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(seconds: 3),
  )..show(context);
}

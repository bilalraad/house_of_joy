import 'package:bot_toast/bot_toast.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/services/data_base.dart';

Future<String> validateEmail(String email) async {
  var emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if (email == null || email.isEmpty) {
    return "الرجاء ادخال الايميل";
  } else if (!emailRegEx.hasMatch(email)) {
    return "الرجاء ادخال ايميل صحيح";
  } else if (await DatabaseService('').checkEmailExcist(email)) {
    return 'Email alredy in use';
  }
  return null;
}

String validatePassword(String password) {
  if (password == null || password.isEmpty) {
    return "الرجاء ادخال الباسوورد";
  } else if (password.length < 6) {
    return "رجاءا ادخال باسوورد اقوى";
  } else if (password.contains(' ')) return 'it should\'t have spaces';
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
      return "يجب ان  لا يحتوي على نقط او فراغات مثلا: sara_ali2";
    }
  }
  return null;
}

String validatePhoneNo(String phoneNo) {
  var phoneRegEx = RegExp(r"07[3-9][0-9]{8}");
  if (phoneNo.isNotEmpty && !phoneRegEx.hasMatch(phoneNo) ||
      phoneNo.length > 11) {
    return "الرقم غير صحيح";
  }
  return null;
}

String validateFullName(String fullName) {
  if (fullName == null || fullName.isEmpty) {
    return "الرجاء ادخال الاسم";
  } else if (fullName.length < 8) {
    return "رجاءا ادخل الاسم الكامل";
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

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SharedPrefs {
  Future<void> setUser({
    @required String phoneNo,
    @required String uid,
    @required String fullName,
    @required String userName,
    @required String imageUrl,
    @required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNo', phoneNo);
    await prefs.setString('uid', uid);
    await prefs.setString('user_name', userName);
    await prefs.setString('full_name', fullName);
    await prefs.setString('image_url', imageUrl);
    await prefs.setString('email', email);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNo = prefs.getString('phoneNo');
    final uid = prefs.getString('uid');
    final userName = prefs.getString('user_name');
    final fullName = prefs.getString('full_name');
    final imageUrl = prefs.getString('image_url');
    final email = prefs.getString('email');
    return uid != null
        ? User(
            uid: uid,
            phoneNo: phoneNo,
            email: email,
            userName: userName,
            fullName: fullName,
            imageUrl: imageUrl,
          )
        : null;
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

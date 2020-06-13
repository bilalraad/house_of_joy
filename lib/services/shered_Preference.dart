import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  ///store user id offline
  Future<void> setUserId({
    @required String uid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }
  
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    return uid;
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import './data_base.dart';
import '../models/user.dart';
import './shered_Preference.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password, String userName);

  Future<String> signUp(String email, String password, User user);

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<String> signInWithGoogle();

  Future<bool> googleSignout();

  Future<bool> facebookSignout();

  Future<void> resetPassword(String email);
  //for future use
  // Future<String> changePassword(String oldPassword, String newPassword);

  Future<String> signInWithFacebook();
}

enum AuthState {
  lohedIn,
  notLogedIn,
  error, //this added for future use
}

class Auth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = FacebookLogin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static StreamController<AuthState> authState = StreamController.broadcast();

  static void dispose() {
    authState.close();
  }

  Future<String> signIn(String email, String password, String userName) async {
    if (userName.isNotEmpty) {
      email = await DatabaseService('').getEmailByUsername(userName);
      if (email == null || email.isEmpty) {
        addState(AuthState.notLogedIn);

        return 'اسم المستخدم غير موجود';
      }
    }
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var firebaseuser = result.user;
      if (firebaseuser.isEmailVerified) {
        final user = await DatabaseService(firebaseuser.uid).getUserData();
        _saveDeviceToken(user.uid);

        SharedPrefs().setUserId(uid: user.uid);
        addState(AuthState.lohedIn);

        return null;
      } else {
        addState(AuthState.notLogedIn);
        return 'رجاء،اقم بتاكيد الحساب الخاص بك اولا';
      }
    } catch (e) {
      addState(AuthState.error);
      if (e is PlatformException) {
        var errorMessege = '';
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          errorMessege = 'عذرا لا يوجد حساب بهذا البريد الالكتروني';
        } else {
          if (e.code == 'ERROR_WRONG_PASSWORD') {
            errorMessege = 'كلمة السر غير صحيحة';
          } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
            errorMessege = 'لايوجد اتصال بالانترنت';
          } else {
            errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';
          }
        }

        return errorMessege;
      } else {
        // debugPrint(e);
      }
    }
    return null;
  }

  Future<String> signUp(String email, String password, User user) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = result.user;
      await DatabaseService(firebaseUser.uid)
          .updateUserData(user.copyWith(uid: firebaseUser.uid));
      await firebaseUser.sendEmailVerification();
      return null;
    } catch (e) {
      addState(AuthState.error);

      if (e is PlatformException) {
        var errorMessege = '';
        if (e.code == 'ERROR_INVALID_EMAIL') {
          errorMessege = 'عذرا لايمكن التسجيل باستخدام هذا البريد الالكتروني';
        } else {
          if (e.code == 'ERROR_WEAK_PASSWORD') {
            errorMessege = 'الباسوورد ضعيف جدا';
          } else {
            if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
              errorMessege = 'الايميل مستخدم سابقا';
            } else {
              if (e.code == 'network_error') {
                errorMessege = 'لايوجد اتصال بالانترنت';
              } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                errorMessege = await _getEmailAlreadyInUseError(email);
              } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
                errorMessege = 'لايوجد اتصال بالانترنت';
              } else {
                errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';
              }
            }
          }
        }

        return errorMessege;
      } else {
        // debugPrint(e);
        return 'حدث خطا غير معروف';
      }
    }
  }

  Future<void> signOut() async {
    addState(AuthState.notLogedIn);

    await SharedPrefs().deleteUser();
    _firebaseAuth.signOut();
    await googleSignout();
    await facebookSignout();
  }

  /// this func. will send a link to user's email not a code
  Future<void> sendEmailVerification() async {
    final user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<String> signInWithGoogle() async {
    User user;
    String email;
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      email = googleUser.email;
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = authResult.user;
      assert(firebaseUser.email != null, 'the email is null');
      assert(firebaseUser.displayName != null, 'the display name is null');
      assert(!firebaseUser.isAnonymous, 'the user is anonymous');
      assert(await firebaseUser.getIdToken() != null, 'test1');
      //If the user already excists in the data base then get his data
      user = await DatabaseService(firebaseUser.uid).getUserData() ??
          User(
            uid: firebaseUser.uid,
            fullName: firebaseUser.displayName ?? '',
            userName: '',
            phoneNo: '',
            email: firebaseUser.email ?? "",
            imageUrl: googleUser.photoUrl ?? '',
          );

      if (user.phoneNo.isEmpty) {
        await DatabaseService(firebaseUser.uid).updateUserData(user);
        _saveDeviceToken(user.uid);
      }

      SharedPrefs().setUserId(uid: user.uid);
      addState(AuthState.lohedIn);
      return null;
    } catch (e) {
      addState(AuthState.error);
      if (e is PlatformException) {
        var errorMessege = '';
        if (e.code == 'sign_in_failed') {
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة مرة اخرى';
        } else if (e.code == 'network_error') {
          errorMessege = 'لايوجد اتصال بالانترنت';
        } else if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          errorMessege = await _getEmailAlreadyInUseError(email);
        } else {
          errorMessege = e.message;
        }
        return errorMessege;
      }
      print(e);
    }
    return 'تم الغاء تسجيل الدخول';
  }

  Future<bool> googleSignout() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    return true;
  }

  ///this func. will sent link to user's email to reset the password from the link
  Future<void> resetPassword(String email) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return;
    }
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    BotToast.showSimpleNotification(
      title: 'تم ارسال رابط تغيير كلمة السر الى البريد الالكتروني الخاص بك',
      align: Alignment.topRight,
    );
  }
  //for future use
  // Future<String> changePassword(
  //   String oldPassword,
  //   String newPassword,
  // ) async {
  //   try {
  //     final user = await _firebaseAuth.currentUser();
  //     final email = user.email;
  //     final result = await user.reauthenticateWithCredential(
  //         EmailAuthProvider.getCredential(email: email, password: oldPassword));
  //     await result.user.updatePassword(newPassword);
  //     return null;
  //   } catch (error) {
  //     if (error is PlatformException) {
  //       if (error.code == 'ERROR_WRONG_PASSWORD') {
  //         return 'كلمة السر غير صحيحة';
  //       } else if (error.code == 'ERROR_NETWORK_REQUEST_FAILED') {
  //         return 'تاكد من اتصالك بالانترنت';
  //       } else {
  //         return 'حدث خطا غير معروف الرجاء المحاولة لاحقا';
  //       }
  //     }
  //   }
  //   return null;
  // }

  Future<String> _getEmailAlreadyInUseError(String email) async {
    final signInMethodsLinkedToEmail =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: email);

    if (signInMethodsLinkedToEmail.first == 'password') {
      return ('اليريد الالكتروني مربوط  سابقا بحساب اخر');
    } else if (signInMethodsLinkedToEmail.first == 'google.com') {
      return ('البريد الالكتروني مربوط  سابقا بحساب كوكل');
    } else {
      return ('البريد الالكتروني مربوط سابقا بحساب فيسبوك');
    }
  }

  Future<bool> isSigendInWithEmailAndPassword() async {
    final user = await _firebaseAuth.currentUser();
    final signInMethodsLinkedToEmail =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: user.email);

    if (signInMethodsLinkedToEmail.contains('password')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> signInWithFacebook() async {
    String email;
    try {
      final result = await facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          var credential =
              FacebookAuthProvider.getCredential(accessToken: token);

          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
          final profile = json.decode(graphResponse.body);
          email = profile['email'];
          User user;
          final authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          user = await DatabaseService(firebaseUser.uid).getUserData() ??
              User(
                uid: firebaseUser.uid,
                fullName: profile['name'] ?? '',
                userName: '',
                phoneNo: '',
                email: profile['email'] ?? "",
                imageUrl: profile['picture']["data"]["url"],
              );
          if (user.userName.isEmpty) {
            await DatabaseService(firebaseUser.uid).updateUserData(user);
          }
          _saveDeviceToken(user.uid);
          SharedPrefs().setUserId(uid: user.uid);
          addState(AuthState.lohedIn);
          return null;
          break;
        case FacebookLoginStatus.cancelledByUser:
          addState(AuthState.notLogedIn);
          // debugPrint('Login cancelled by the user.');
          return '';

          break;
        case FacebookLoginStatus.error:
          addState(AuthState.error);
          return 'حدث خطا غير معروف، الرجاء المحاولة مرة اخرى';

          break;
      }
    } catch (e) {
      addState(AuthState.error);
      if (e is PlatformException) {
        var errorMessege = '';
        if (e.code == 'sign_in_failed') {
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة مرة اخرى';
        } else if (e.code == 'network_error') {
          errorMessege = 'لايوجد اتصال بالانترنت';
        } else if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          errorMessege = await _getEmailAlreadyInUseError(email);
        } else {
          errorMessege = e.message;
        }
        return errorMessege;
      }
      // debugPrint(e);
    }
    return null;
  }

  @override
  Future<bool> facebookSignout() async {
    if (await facebookSignIn.isLoggedIn) await facebookSignIn.logOut();
    return true;
  }

  void _saveDeviceToken(String uid) async {
    final _fcm = FirebaseMessaging();
    // Get the token for this device
    final fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = DatabaseService('')
          .usersCollection
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
      });
    }
  }

  static void addState(AuthState state) {
    authState.sink.add(state);
  }
}

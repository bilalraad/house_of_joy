import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/shered_Preference.dart';

abstract class BaseAuth {
  Future<bool> signIn(String email, String password, String userName);

  Future<void> signUp(String email, String password, User user);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<void> signUpWithGoogle();

  Future<bool> googleSignout();

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password, String userName) async {
    if (userName.isNotEmpty) {
      email = await DatabaseService('').getEmailByUsername(userName);
      if(email.isEmpty){
        showCostumeFireBaseErrorNotif('اسم المستخدم غير موجود');
        return false;
      }
    }
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser firebaseuser = result.user;
      if (firebaseuser.isEmailVerified) {
        final user = await DatabaseService(firebaseuser.uid).getUserData();
        SharedPrefs().setUser(
          uid: user.uid,
          email: user.email,
          fullName: user.fullName,
          imageUrl: user.imageUrl,
          phoneNo: user.phoneNo,
          userName: user.userName,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
        if (e.code == 'ERROR_USER_NOT_FOUND')
          errorMessege = 'عذرا لا يوجد حساب بهذا الايميل';
        else if (e.code == 'ERROR_WRONG_PASSWORD')
          errorMessege = 'كلمة السر غير صحيحة';
        else
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';

        showCostumeFireBaseErrorNotif(errorMessege);
      } else {
        showCostumeFireBaseErrorNotif(e);
      }
    }
    return null;
  }

  Future<bool> signUp(String email, String password, User user) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      await DatabaseService(firebaseUser.uid).updateUserData(user);
      print(firebaseUser.email);
      await firebaseUser.sendEmailVerification();
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
        if (e.code == 'ERROR_INVALID_EMAIL')
          errorMessege = 'عذرا لايمكن التسجيل باستخدام هذا الايميل';
        else if (e.code == 'ERROR_WEAK_PASSWORD')
          errorMessege = 'الباسوورد ضعيف جدا';
        else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
          errorMessege = 'الايميل مستخدم سابقا';
        else
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';

        showCostumeFireBaseErrorNotif(errorMessege);
      } else {
        showCostumeFireBaseErrorNotif(e);
      }
    }
    return true;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> signUpWithGoogle() async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      SharedPrefs().setUser(
        uid: user.uid,
        fullName: user.displayName,
        userName: '',
        phoneNo: user.phoneNumber,
        email: user.email,
        imageUrl: googleUser.photoUrl,
      );

      print(currentUser);
      print("User Name : ${currentUser.displayName}");
    } catch (e) {}
  }

  Future<bool> googleSignout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    return true;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

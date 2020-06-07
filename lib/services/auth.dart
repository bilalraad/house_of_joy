import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/shered_Preference.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password, String userName);

  Future<String> signUp(String email, String password, User user);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<String> signInWithGoogle();

  Future<bool> googleSignout();

  Future<bool> facebookSignout();

  Future<void> resetPassword(String email);

  Future<String> signInWithFacebook();
}

class Auth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password, String userName) async {
    if (userName.isNotEmpty) {
      email = await DatabaseService('').getEmailByUsername(userName);
      if (email == null || email.isEmpty) {
        return 'اسم المستخدم غير موجود';
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
        return null;
      } else {
        return 'رجاء،اقم بتاكيد الحساب الخاص بك اولا';
      }
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
        if (e.code == 'ERROR_USER_NOT_FOUND')
          errorMessege = 'عذرا لا يوجد حساب بهذا الايميل';
        else if (e.code == 'ERROR_WRONG_PASSWORD')
          errorMessege = 'كلمة السر غير صحيحة';
        else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED')
          errorMessege = 'لايوجد اتصال بالانترنت';
        else
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';

        return errorMessege;
      } else {
        print(e);
      }
    }
    return null;
  }

  Future<String> signUp(String email, String password, User user) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      await DatabaseService(firebaseUser.uid)
          .updateUserData(user.copyWith(uid: firebaseUser.uid));
      await firebaseUser.sendEmailVerification();

      return null;
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
        if (e.code == 'ERROR_INVALID_EMAIL')
          errorMessege = 'عذرا لايمكن التسجيل باستخدام هذا الايميل';
        else if (e.code == 'ERROR_WEAK_PASSWORD')
          errorMessege = 'الباسوورد ضعيف جدا';
        else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
          errorMessege = 'الايميل مستخدم سابقا';
        else if (e.code == 'network_error')
          errorMessege = 'لايوجد اتصال بالانترنت';
        else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
          errorMessege = await _getEmailAlreadyInUseError(email);
        else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED')
          errorMessege = 'لايوجد اتصال بالانترنت';
        else
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';

        return errorMessege;
      } else {
        print(e);
        return '';
      }
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    await googleSignout();
    await facebookSignout();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<String> signInWithGoogle() async {
    User user;
    String email;
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      email = googleUser.email;
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser firebaseUser = authResult.user;
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
            activities: [],
          );

      if (user.userName.isEmpty)
        await DatabaseService(firebaseUser.uid).updateUserData(user);

      SharedPrefs().setUser(
        uid: user.uid,
        fullName: user.fullName,
        userName: '',
        phoneNo: user.phoneNo,
        email: user.email,
        imageUrl: user.imageUrl,
      );

      return null;
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
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
    return '';
  }

  Future<bool> googleSignout() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    return true;
  }

  Future<void> resetPassword(String email) async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    BotToast.showSimpleNotification(
        title: 'reset passwod link was sent to your email');
  }

  Future<String> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      String email = user.email;
      AuthResult result = await user.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(email: email, password: oldPassword));
      await result.user.updatePassword(newPassword);
      return null;
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_WRONG_PASSWORD')
          return 'كلمة السر غير صحيحة';
        else if (error.code == 'ERROR_NETWORK_REQUEST_FAILED')
          return 'تاكد من اتصالك بالانترنت';
        else
          return 'حدث خطا غير معروف الرجاء المحاولة لاحقا';
      }
    }
    return null;
  }

  Future<String> _getEmailAlreadyInUseError(String email) async {
    var signInMethodsLinkedToEmail =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: email);

    if (signInMethodsLinkedToEmail.first == 'password') {
      return ('الايميل مربوط  سابقا بحساب اخر');
    } else if (signInMethodsLinkedToEmail.first == 'google.com') {
      return ('الايميل مربوط  سابقا بحساب كوكل');
    } else {
      return ('الايميل مربوط سابقا بحساب فيسبوك');
    }
  }

  Future<bool> isSigendInWithEmailAndPassword() async {
    final user = await _firebaseAuth.currentUser();
    var signInMethodsLinkedToEmail =
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
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

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
          final AuthResult authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          // if (await _isAlreadyLinked(profile['email'], toFacebook: true)) {
          user = await DatabaseService(firebaseUser.uid).getUserData() ??
              User(
                uid: firebaseUser.uid,
                fullName: profile['name'] ?? '',
                userName: '',
                phoneNo: '',
                email: profile['email'] ?? "",
                imageUrl: profile['picture']["data"]["url"],
                activities: [],
              );
          // } else {
          if (user.userName.isEmpty)
            await DatabaseService(firebaseUser.uid).updateUserData(user);
          // }
          SharedPrefs().setUser(
            uid: user.uid,
            fullName: user.fullName,
            userName: '',
            phoneNo: user.phoneNo,
            email: user.email,
            imageUrl: user.imageUrl,
          );
          return null;
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          return '';

          break;
        case FacebookLoginStatus.error:
          print('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          return 'حدث خطا غير معروف، الرجاء المحاولة مرة اخرى';

          break;
      }
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';
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
    return null;
  }

  @override
  Future<bool> facebookSignout() async {
    if (await facebookSignIn.isLoggedIn) await facebookSignIn.logOut();
    return true;
  }
}

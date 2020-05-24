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
  Future<bool> signIn(String email, String password, String userName);

  Future<void> signUp(String email, String password, User user);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> signInWithGoogle();

  Future<bool> googleSignout();

  Future<void> resetPassword(String email);

  Future<bool> signInWithFacebook();
}

class Auth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(String email, String password, String userName) async {
    if (userName.isNotEmpty) {
      email = await DatabaseService('').getEmailByUsername(userName);
      if (email != null && email.isEmpty) {
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
      print(e);
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
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return false;
    }
    try {
      print(await _firebaseAuth.fetchSignInMethodsForEmail(email: email));
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      await DatabaseService(firebaseUser.uid).updateUserData(user);
      print(firebaseUser.email);
      await firebaseUser.sendEmailVerification();

      return true;
    } catch (e) {
      print(e);

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
          _showEmailAlreadyInUseError(email);
        else
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة لاحقا';

        showCostumeFireBaseErrorNotif(errorMessege);
      } else {
        showCostumeFireBaseErrorNotif(e);
      }
      return false;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    if (!await connected()) {
      showCostumeFireBaseErrorNotif('عذرا لا يوجد اتصال بالانترنت');
      return null;
    }
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  // Future<bool> isEmailVerified() async {
  //   FirebaseUser user = await _firebaseAuth.currentUser();
  //   return user.isEmailVerified;
  // }

  Future<bool> signInWithGoogle() async {
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
      print(googleUser.id);
      print(firebaseUser.uid);

      if (await _isAlreadyLinked(googleUser.email, togoogle: true)) {
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
      } else {
        //if not creat new user
        await DatabaseService(firebaseUser.uid).updateUserData(user);
      }

      SharedPrefs().setUser(
        uid: user.uid,
        fullName: user.fullName,
        userName: '',
        phoneNo: user.phoneNo,
        email: user.email,
        imageUrl: user.imageUrl,
      );

      print(user.toString());
      return true;
    } catch (e) {
      if (e is PlatformException) {
        String errorMessege = '';

        if (e.code == 'sign_in_failed') {
          errorMessege = 'حدث خطا غير معروف الرجاء المحاولة مرة اخرى';
        } else if (e.code == 'network_error') {
          errorMessege = 'لايوجد اتصال بالانترنت';
        } else if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          _showEmailAlreadyInUseError(email);
        } else {
          errorMessege = e.message;
        }
        showCostumeFireBaseErrorNotif(errorMessege);
      }
      print(e);
      return false;
    }
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

  Future<bool> _isAlreadyLinked(
    String email, {
    bool toFacebook = false,
    bool togoogle = false,
  }) async {
    var signInMethodsLinkedToEmail =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
    if (toFacebook) {
      if (signInMethodsLinkedToEmail.first == 'facebook.com') {
        return true;
      }
    } else if (togoogle) {
      if (signInMethodsLinkedToEmail.first == 'google.com') {
        return true;
      }
    }
    return false;
  }

  Future<void> _showEmailAlreadyInUseError(String email) async {
    var signInMethodsLinkedToEmail =
        await _firebaseAuth.fetchSignInMethodsForEmail(email: email);

    if (signInMethodsLinkedToEmail.first == 'password') {
      showCostumeFireBaseErrorNotif(
          'الايميل مربوط  سابقا بحساب خاص ببيت الفرح');
    } else if (signInMethodsLinkedToEmail.first == 'google.com') {
      showCostumeFireBaseErrorNotif('الايميل مربوط  سابقا بحساب كوكل');
    } else {
      showCostumeFireBaseErrorNotif('الايميل مربوط سابقا بحساب فيسبوك');
    }
  }

  @override
  Future<bool> signInWithFacebook() async {
    String email;
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          var credential =
              FacebookAuthProvider.getCredential(accessToken: token);

          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
          final profile = json.decode(graphResponse.body);
          email = profile['email'];
          User user;
          final AuthResult authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          if (await _isAlreadyLinked(profile['email'], toFacebook: true)) {
            user = await DatabaseService(firebaseUser.uid).getUserData() ??
                User(
                  uid: firebaseUser.uid,
                  fullName: profile['name'] ?? '',
                  userName: '',
                  phoneNo: '',
                  email: profile['email'] ?? "",
                  imageUrl: '',
                );
          } else {
            await DatabaseService(firebaseUser.uid).updateUserData(user);
          }
          print(user.toString());
          SharedPrefs().setUser(
            uid: user.uid,
            fullName: user.fullName,
            userName: '',
            phoneNo: user.phoneNo,
            email: user.email,
            imageUrl: user.imageUrl,
          );
          return false;
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          return false;

          break;
        case FacebookLoginStatus.error:
          showCostumeFireBaseErrorNotif('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          return false;

          break;
      }
      return true;
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          _showEmailAlreadyInUseError(email);
        }
      }
      print(e);
      return false;
    }
  }
}

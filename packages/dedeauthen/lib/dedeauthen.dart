library dedeauthen;

import 'package:dedeauthen/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_line_liff/flutter_line_liff.dart' show kIsWeb;
import 'repositories/client.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = new UserRepository();
  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

  Future<bool> signInWithLine() async {
    try {
      final result =
          await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);

      return true;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    await _auth.signInWithProvider(appleProvider);
    return true;
  }

  Future<ApiResponse> signInWithEmail(
      String serviceApi, String userName, String passWord) async {
    try {
      final _result =
          await _userRepository.authenUser(serviceApi, userName, passWord);
      return _result;
    } catch (ex) {
      print(ex);
      throw Exception(ex);
    }
  }

  Future<ApiResponse> signUpWithEmail(
      String serviceApi, String userName, String passWord) async {
    try {
      final _result =
          await _userRepository.registerEmail(serviceApi, userName, passWord);
      return _result;
    } catch (ex) {
      print(ex);
      throw Exception(ex);
    }
  }

  Future<dynamic> requestOTP(String phoneNum) async {
    final _result = await _userRepository.requestOPT(phoneNum);
    return _result;
  }

  Future<dynamic> verifyOPT(String token, String pin) async {
    final _result = await _userRepository.verifyOPT(token, pin);
    return _result;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Map<String, dynamic>? _userData;
  String welcome = "Facebook";



  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: ['email']);

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      // Convert AccessToken to JSON and extract the token
      final Map<String, dynamic>? accessTokenJson = result.accessToken?.toJson();
      final String? accessToken = accessTokenJson?['token'];

      if (accessToken != null) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

        return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      } else {
        log('Failed to retrieve access token.');
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: 'Failed to retrieve access token.',
        );
      }
    } else {
      print(result.message);
      throw FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_FAILED',
        message: result.message ?? 'Unknown error occurred during Facebook login.',
      );
    }
  }



}







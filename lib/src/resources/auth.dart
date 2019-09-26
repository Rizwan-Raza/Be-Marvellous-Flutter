import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth({
    @required this.googleSignIn,
    @required this.firebaseAuth,
  });

  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  Future<FirebaseUser> signInWithGoogle() async {
    print("Setp 1");
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    print("Setp 2");
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
    print("Setp 4");
    return (await firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )))
        .user;
  }
}

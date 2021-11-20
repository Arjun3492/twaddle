import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaddle/core/auth/screens/signin_screen.dart';
import 'package:twaddle/core/services/database_service.dart';
import 'package:twaddle/core/services/sharedpref_service.dart';
import 'package:twaddle/screens/home/home.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<User> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User userDetails = result.user!;
    SharedPreference().saveUserEmail(userDetails.email ?? "");
    SharedPreference().saveUserId(userDetails.uid);
    SharedPreference()
        .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
    SharedPreference().saveDisplayName(userDetails.displayName ?? "");
    SharedPreference().saveUserProfilePic(userDetails.photoURL ?? "");
    Map<String, dynamic> userInfo = {
      "userName": userDetails.email!.replaceAll("@gmail.com", ""),
      "displayName": userDetails.displayName,
      "email": userDetails.email,
      "photoURL": userDetails.photoURL,
      "userId": userDetails.uid
    };
    DatabaseService().addUserInfoToDb(userDetails.uid, userInfo).then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));

    throw Exception("Failed to sign in");
  }

  Future signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut().then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInPage())));
  }
}

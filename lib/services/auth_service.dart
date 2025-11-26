import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;

  AuthService() {
    _auth.userChanges().listen((u) => notifyListeners());
  }

  Future<void> signInWithEmail(String email, String pwd) async {
    await _auth.signInWithEmailAndPassword(email: email, password: pwd);
  }

  Future<void> registerWithEmail(String email, String pwd) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('annulé');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async => _auth.signOut();
}￼Enter

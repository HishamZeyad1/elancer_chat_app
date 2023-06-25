import 'dart:async';
import 'dart:io';

import 'package:elancer_chat_app/controllers/fire_store_user_controller.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

typedef AuthStateCallback = void Function(bool loggedIn);

class FbAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FbAuthController _instance = FbAuthController._();

  FbAuthController._();

  factory FbAuthController() {
    return _instance;
  }

  Future<ProcessResponse> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
      // await userCredential.user?.updatePhoneNumber(phoneCredential)
      // await userCredential.user?.linkWithPhoneNumber("0592132855");
      await FirestoreUserController()
          .saveUser(user:/*userCredential.user!*/ _firebaseAuth.currentUser!);
      return ProcessResponse(
          message: 'Account created successfully', success: true);
    } on FirebaseAuthException catch (e) {
      print('Exception');
      return ProcessResponse(
          message: e.message ?? 'Error occurred', success: false);
    } catch (e) {
      print('-- Exception $e');
      return ProcessResponse(message: 'Error occurred', success: false);
    }
  }

  Future<ProcessResponse> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ProcessResponse(message: 'Signed in successfully', success: true);
    } on FirebaseAuthException catch (e) {
      return ProcessResponse(
          message: e.message ?? 'Error occurred', success: false);
    }
  }

  Future<ProcessResponse> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return ProcessResponse(
          message: 'Password reset email sent', success: true);
    } on FirebaseAuthException catch (e) {
      return ProcessResponse(message: e.message ?? '', success: false);
    }
  }

  User get user => _firebaseAuth.currentUser!;

  Future<bool> signOut() async {
    return await _firebaseAuth
        .signOut()
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  bool get loggedIn => _firebaseAuth.currentUser != null;

  StreamSubscription checkUserStatus(
      {required AuthStateCallback authStateCallback}) {
    return _firebaseAuth.authStateChanges().listen((User? user) {
      authStateCallback(user != null);
    });
  }
}

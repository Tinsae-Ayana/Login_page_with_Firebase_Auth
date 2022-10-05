import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user.dart' as myuser;

class SignupWithEmailAndPasswordFailure implements Exception {
  final String message;
  SignupWithEmailAndPasswordFailure(
      [this.message = 'An unknown exception occured']);

  factory SignupWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return SignupWithEmailAndPasswordFailure(
            'Email is not valid and badly formatted');
      case 'user-disabled':
        return SignupWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support for help');
      case 'email-already-in-use':
        return SignupWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support for help');
      case 'Operation-not-allowed':
        return SignupWithEmailAndPasswordFailure(
            'Operation not allowed. Please contact Support');
      case 'weak-password':
        return SignupWithEmailAndPasswordFailure(
            'Please enter stronger password');
      default:
        return SignupWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  final String message;
  LogInWithEmailAndPasswordFailure(
      [this.message = 'An unknown Excepiton occured']);
  factory LogInWithEmailAndPasswordFailure.fromCode(code) {
    switch (code) {
      case 'invalid-email':
        return LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return LogInWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithGoogleFailure implements Exception {
  final String message;
  LogInWithGoogleFailure([this.message = 'unknown error occured']);
  factory LogInWithGoogleFailure.fromCode(code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return LogInWithGoogleFailure();
    }
  }
}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

// signup with email and password
  Future<void> signUp({required String email, required String password}) async {
    try {
      debugPrint('riched this');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint('riched this');
    } on FirebaseAuthException catch (e) {
      throw SignupWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw SignupWithEmailAndPasswordFailure();
    }
  }

// login with email and password
  Future<void> logInWithEmailAndPassword(
      {required String password, required String email}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint('riched this');
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e);
    } catch (_) {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

// signin with google account
  Future<void> signInWithGoogleAccount() async {
    try {
      late final AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw LogInWithGoogleFailure();
    }
  }

// logout
  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Stream<myuser.User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user =
          firebaseUser == null ? myuser.User.empty : firebaseUser.toUser;
      return user;
    });
  }
}

// extendsion method to user in firebase_auth
extension on User {
  myuser.User get toUser =>
      myuser.User(id: uid, email: email, name: displayName, photo: photoURL);
}

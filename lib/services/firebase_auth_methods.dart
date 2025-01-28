import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/show_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  // Sign Up with Email and Password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (!_isPasswordValid(password)) {
        showSnackBar(
          context,
          'Password must be at least 6 characters long and contain at least 2 special characters.',
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification immediately
      await _sendEmailVerification(userCredential.user, context);

      // Sign out immediately to force user to verify the email
      await _auth.signOut();

      showSnackBar(
        context,
        'Account created successfully! A verification email has been sent to $email. Please verify your email before logging in.',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseException(e);
      showSnackBar(context, errorMessage);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Log In with Email and Password
  Future<void> logInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure email is verified before allowing login
      if (!userCredential.user!.emailVerified) {
        // Sign out unverified users
        await _auth.signOut();
        showSnackBar(context, 'Please verify your email before logging in.');
      } else {
        showSnackBar(context, 'Logged in successfully!');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseException(e);
      showSnackBar(context, errorMessage);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Google Sign-In Method
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      showSnackBar(
        context,
        'Google Sign-In successful! Welcome, ${userCredential.user?.displayName ?? 'User'}',
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Google Sign-In failed.');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Handle FirebaseException in a cross-platform way
  String _handleFirebaseException(FirebaseAuthException e) {
    String errorMessage = 'An unknown error occurred.';

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'The email is already in use. Please try another one.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again.';
        break;
      default:
        errorMessage = e.message ?? 'An unknown error occurred.';
        break;
    }

    return errorMessage;
  }

  // Send Email Verification
  Future<void> _sendEmailVerification(User? user, BuildContext context) async {
    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        showSnackBar(context, 'Verification email sent to ${user.email}.');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Could not send verification email.');
    }
  }

  // Validate Password
  bool _isPasswordValid(String password) {
    final specialCharRegex = RegExp(r'[!@#\$&*~]');
    final matches = specialCharRegex.allMatches(password).length;
    return password.length >= 6 && matches >= 2;
  }
}

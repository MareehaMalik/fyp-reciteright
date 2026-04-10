import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GoogleSignIn instance - using dynamic initialization
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthService() {
    // No initialization needed - GoogleSignIn handles platform-specific config automatically
  }

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('🔄 Starting sign up process for: $email');

      // Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        print('✅ Firebase Auth user created: ${user.uid}');
        print('✅ User signed up successfully: ${user.email}');

        // Store user data in Firestore asynchronously (non-blocking)
        // Don't await this - let it happen in the background
        _storeUserDataAsync(user.uid, fullName, email);

        // Send email verification asynchronously (non-blocking)
        // Don't await this - let it happen in the background
        _sendEmailVerificationAsync(user);

        // Keep user signed in after signup - don't sign them out
        // They can now navigate directly to home screen
        print(
          '✅ User account created and signed in - ready to use app',
        );

        return user; // Return the user object to indicate signup was successful and they're logged in
      } else {
        throw Exception('User creation failed - user is null');
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error during sign up: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error during sign up: $e');
      throw 'An unexpected error occurred during sign up: ${e.toString()}';
    }
  }

  // Store user data in Firestore (non-blocking - async fire-and-forget)
  void _storeUserDataAsync(String uid, String fullName, String email) {
    _firestore
        .collection('users')
        .doc(uid)
        .set({
          'fullName': fullName,
          'email': email,
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'authProvider': 'email',
        })
        .then((_) {
          print('✅ User data stored in Firestore');
        })
        .catchError((e) {
          print('⚠ Failed to store user data in Firestore: $e');
        });
  }

  // Send email verification (non-blocking - async fire-and-forget)
  void _sendEmailVerificationAsync(User user) {
    user
        .sendEmailVerification()
        .then((_) {
          print('✅ Email verification sent');
        })
        .catchError((e) {
          print('⚠ Could not send email verification: $e');
        });
  }

  // Login with email and password
  Future<User?> login({required String email, required String password}) async {
    try {
      print('🔄 Starting login process for: $email');

      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        print('✅ User logged in successfully: ${user.email}');
        return user;
      } else {
        throw Exception('Login failed - user is null');
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth error during login: ${e.code} - ${e.message}');

      // If invalid credentials, check if it's a Google user
      if (e.code == 'invalid-credential') {
        print(
          '⚠ Invalid credentials - could be Google user or wrong password',
        );

        // Quickly check Firestore to see if this is a Google user (with timeout)
        try {
          final userQuery = await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get()
              .timeout(
                const Duration(seconds: 3),
                onTimeout: () => throw TimeoutException('Firestore timeout'),
              );

          if (userQuery.docs.isNotEmpty) {
            final authProvider =
                userQuery.docs.first.data()['authProvider'] as String?;
            if (authProvider == 'google') {
              throw 'You signed up with Google. Please use "Sign in with Google" button, or set a password on the signup page to use email/password login.';
            }
          }
        } catch (err) {
          // If it's our custom Google error, throw it
          if (err is String && err.contains('Google') ||
              err.toString().contains('Google')) {
            rethrow;
          }
          // Otherwise, proceed with standard error
          print('ℹ Firestore check failed or unavailable');
        }

        // Standard error for invalid credentials
        throw 'Invalid email or password. Please check and try again.';
      }

      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error during login: $e');
      // Re-throw custom error messages as-is
      if (e is String && e.contains('Google Sign-In')) {
        throw e;
      }
      throw 'An unexpected error occurred during login: ${e.toString()}';
    }
  }

  // Google Sign-In (works for both mobile and web)
  Future<User?> signInWithGoogle() async {
    try {
      print('🔄 Starting Google Sign-In...');

      // If user is already authenticated via Google, just return current user
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        print('ℹ User already authenticated: ${currentUser.email}');
        return currentUser;
      }

      // Perform Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ Google Sign-In was cancelled by user');
        throw 'Google Sign-In was cancelled';
      }

      print('✅ Google User signed in: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the necessary tokens
      if (googleAuth.idToken == null && !kIsWeb) {
        print('⚠ ID Token is null');
        throw Exception('Failed to get Google authentication tokens');
      }

      // Create Firebase credential - use serverAuthCode for web, accessToken for mobile
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        print('✅ User signed in with Google: ${user.email}');

        // Check if email is registered with Email/Password method only
        if (user.email != null) {
          try {
            // Note: fetchSignInMethodsForEmail is deprecated in newer Firebase versions
            // This is for informational purposes only
            print('✅ User authenticated with Google: ${user.email}');
          } catch (e) {
            print('ℹ Could not check sign-in methods: $e');
          }
        }

        // Store/update user data (non-blocking - fire-and-forget)
        _storeOrUpdateGoogleUserDataAsync(
          user.uid,
          user.displayName ?? googleUser.displayName ?? user.email?.split('@')[0] ?? 'User',
          user.email ?? '',
        );

        return user;
      } else {
        throw Exception('Google sign-in failed - user is null');
      }
    } on FirebaseAuthException catch (e) {
      print(
        '❌ Firebase Auth error during Google Sign-In: ${e.code} - ${e.message}',
      );

      // Handle specific case where email is registered with different provider
      if (e.code == 'account-exists-with-different-credential') {
        print(
          '⚠ This email is registered with a different authentication method',
        );
        throw 'This email is registered with Email/Password. Please use Email/Password login instead, or contact support to link accounts.';
      }

      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error during Google Sign-In: $e');
      throw 'An error occurred during Google Sign-In: ${e.toString()}';
    }
  }

  // Google Sign-Up (same as signInWithGoogle for Firebase)
  Future<User?> signUpWithGoogle() async {
    try {
      print('🔄 Starting Google Sign-Up...');
      return await signInWithGoogle();
    } catch (e) {
      print('❌ Google Sign-Up error: $e');
      rethrow;
    }
  }

  // Store or update Google user data (non-blocking - async fire-and-forget)
  void _storeOrUpdateGoogleUserDataAsync(
    String uid,
    String fullName,
    String email,
  ) {
    _firestore
        .collection('users')
        .doc(uid)
        .set({
          'fullName': fullName,
          'email': email,
          'uid': uid,
          'authProvider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true))
        .then((_) {
          print('✅ Google user data stored/updated in Firestore');
        })
        .catchError((e) {
          print('⚠ Failed to store/update Google user data: $e');
        });
  }

    // Sign out from all providers
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      final isSignedIn = _googleSignIn.currentUser != null;
      if (isSignedIn) {
        await _googleSignIn.disconnect();
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      print('✅ User signed out successfully from all providers');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String uid,
    required String fullName,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('❌ Error updating user profile: $e');
      return false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send password reset email: ${e.toString()}';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    print('🔄 Handling auth exception: ${e.code}');

    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak. Please use a stronger password (min 8 characters with letters, numbers, and symbols).';
      case 'email-already-in-use':
        return 'An account with this email already exists. Please log in instead, or use a different email.';
      case 'invalid-email':
        return 'The email address is not valid. Please check your email and try again.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support for assistance.';
      case 'user-not-found':
        return 'No user found with this email. Please check your email or sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please check and try again.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later or reset your password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Email/Password authentication is not enabled. Please contact support.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again.';
      case 'account-exists-with-different-credential':
        return 'This email is already registered with a different login method. Please use the original login method.';
      case 'invalid-credential':
        return 'The credentials are invalid. Please check your email and password.';
      case 'credential-already-in-use':
        return 'This credential is already in use by another account.';
      case 'provider-already-linked':
        return 'This authentication provider is already linked to your account.';
      case 'invalid-cert-hash':
        return 'Certificate verification failed. Please try using Email/Password login instead.';
      default:
        // Provide more specific error messages
        if (e.message != null && e.message!.contains('invalid-cert-hash')) {
          return 'Certificate verification failed. Please try using Email/Password login instead.';
        }
        if (e.message != null && e.message!.contains('IDP')) {
          return 'Google authentication error. Please try again or contact support.';
        }
        if (e.message != null && e.message!.contains('EMAIL_EXISTS')) {
          return 'This email is already registered. Please log in instead.';
        }
        return 'An authentication error occurred: ${e.message ?? "Unknown error. Please try again."}';
    }
  }

  // Check if user is authenticated
  bool isUserAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  // Streams
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Stream<User?> get userState => _firebaseAuth.userChanges();

  // Get user document stream
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
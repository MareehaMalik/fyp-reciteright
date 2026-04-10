import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemoAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  /// Demo login - creates a demo user for testing
  Future<User?> demoLogin(String email) async {
    try {
      print('🔄 Starting Demo Login with: $email');

      // Use a demo account
      final demoEmail = 'demo@tajweed.test';
      final demoPassword = 'DemoPassword123!@#';

      // Try to sign in, if fails, create the account
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: demoEmail,
          password: demoPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Create demo account
          await _firebaseAuth.createUserWithEmailAndPassword(
            email: demoEmail,
            password: demoPassword,
          );
        } else {
          rethrow;
        }
      }

      final user = _firebaseAuth.currentUser;

      if (user != null) {
        print('✅ Demo user signed in: ${user.email}');

        // Store demo user data in Firestore
        await _firestore.collection('users').doc(user.uid).set(
          {
            'email': user.email,
            'displayName': 'Demo User',
            'avatar': null,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
            'isDemo': true,
          },
          SetOptions(merge: true),
        );

        return user;
      }

      throw Exception('Failed to create demo user');
    } catch (e) {
      print('❌ Demo login error: $e');
      throw 'Demo login failed: $e';
    }
  }

  /// Alternative: Email-based login
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Signing in with email: $email');

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Email sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'User account has been disabled.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

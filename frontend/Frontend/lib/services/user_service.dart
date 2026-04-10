import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUser == null) return null;
      
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      
      return doc.data();
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String fullName,
    String? profileImageUrl,
    String? bio,
  }) async {
    try {
      if (currentUser == null) return false;

      final updates = {
        'fullName': fullName,
        'updatedAt': DateTime.now(),
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        if (bio != null) 'bio': bio,
      };

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(updates);

      print('✅ User profile updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating user profile: $e');
      return false;
    }
  }

  // Get user recitation stats
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      if (currentUser == null) {
        return {
          'totalRecitations': 0,
          'thisWeek': 0,
          'currentStreak': 0,
          'bestStreak': 0,
        };
      }

      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('stats')
          .doc('overall')
          .get();

      if (doc.exists) {
        return doc.data() ?? {};
      }

      return {
        'totalRecitations': 0,
        'thisWeek': 0,
        'currentStreak': 0,
        'bestStreak': 0,
      };
    } catch (e) {
      print('❌ Error getting user stats: $e');
      return {};
    }
  }

  // Update user stats
  Future<void> updateUserStats({
    required int totalRecitations,
    required int thisWeek,
    required int currentStreak,
    required int bestStreak,
  }) async {
    try {
      if (currentUser == null) return;

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('stats')
          .doc('overall')
          .set({
        'totalRecitations': totalRecitations,
        'thisWeek': thisWeek,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('❌ Error updating user stats: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Error logging out: $e');
      rethrow;
    }
  }
}

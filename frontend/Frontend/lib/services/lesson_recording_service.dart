import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LessonRecordingService {
  static final Map<String, _RecordingSession> _recordingSessions = {};

  static Future<void> startRecording(String lessonId, String lessonTitle) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      // Use current user ID if available, otherwise use test user for development
      final userId = user?.uid ?? 'test_user_${DateTime.now().millisecondsSinceEpoch}';

      final session = _RecordingSession(
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        userId: userId,
        startTime: DateTime.now(),
      );

      _recordingSessions[lessonId] = session;
      print('✅ Recording started for lesson: $lessonTitle');
    } catch (e) {
      print('❌ Error starting recording: $e');
      rethrow;
    }
  }

  static Future<String?> stopRecording(String lessonId) async {
    try {
      final session = _recordingSessions[lessonId];
      if (session == null) {
        throw Exception('No recording session for lesson: $lessonId');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(session.startTime).inSeconds;

      print('✅ Recording stopped');
      print('   Duration: $duration seconds');
      print('   Note: Actual accuracy will be determined by backend DTW comparison');

      // Save recording metadata to Firestore
      // The actual score will be added after API comparison is complete
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('lesson_recordings')
              .add({
            'lessonId': lessonId,
            'lessonTitle': session.lessonTitle,
            'duration': duration,
            'accuracy': null, // Will be set after API returns real score
            'recordedAt': FieldValue.serverTimestamp(),
            'status': 'completed',
          });

          print('💾 Recording metadata saved to Firestore');
        } catch (e) {
          print('⚠️ Could not save to Firestore: $e');
          print('⚠️ Firestore permissions may need to be updated');
        }
      } else {
        print('⚠️ User not authenticated - recording data not persisted');
      }

      _recordingSessions.remove(lessonId);
      return 'Recorded $duration seconds - waiting for analysis...';
    } catch (e) {
      print('❌ Error stopping recording: $e');
      rethrow;
    }
  }

  static Duration? getRecordingDuration(String lessonId) {
    final session = _recordingSessions[lessonId];
    if (session == null) return null;
    return DateTime.now().difference(session.startTime);
  }

  static bool isRecording(String lessonId) {
    return _recordingSessions.containsKey(lessonId);
  }

  /// Get the recording file path for a lesson
  /// Returns a consistent path for storing recording metadata
  static Future<String?> getRecordingPath(String lessonId) async {
    try {
      // Simple path without platform-specific dependencies
      // In production, would save actual audio files to device storage
      return 'recordings/$lessonId.wav';
    } catch (e) {
      print('⚠️ Error creating recording path: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getLessonRecordings(String lessonId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('lesson_recordings')
          .where('lessonId', isEqualTo: lessonId)
          .orderBy('recordedAt', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('❌ Error fetching recordings: $e');
      return [];
    }
  }

  static Future<void> deleteRecording(String recordingId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      // Only delete if user is authenticated (Firestore has security rules)
      if (user == null) {
        print('⚠️ Cannot delete recording without authentication');
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('lesson_recordings')
          .doc(recordingId)
          .delete();

      print('✅ Recording deleted');
    } catch (e) {
      print('❌ Error deleting recording: $e');
      rethrow;
    }
  }

  static void clearSession(String lessonId) {
    _recordingSessions.remove(lessonId);
  }
}

class _RecordingSession {
  final String lessonId;
  final String lessonTitle;
  final String userId;
  final DateTime startTime;

  _RecordingSession({
    required this.lessonId,
    required this.lessonTitle,
    required this.userId,
    required this.startTime,
  });
}


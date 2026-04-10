import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecitationRecord {
  final String id;
  final String lessonId;
  final String lessonTitle;
  final DateTime recordedAt;
  final int duration; // in seconds
  final double accuracy; // 0-100
  final String notes;
  final bool isPerfect; // accuracy >= 90

  RecitationRecord({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.recordedAt,
    required this.duration,
    required this.accuracy,
    required this.notes,
    required this.isPerfect,
  });

  factory RecitationRecord.fromMap(Map<String, dynamic> map, String docId) {
    return RecitationRecord(
      id: docId,
      lessonId: map['lessonId'] ?? '',
      lessonTitle: map['lessonTitle'] ?? '',
      recordedAt: (map['recordedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      duration: map['duration'] ?? 0,
      accuracy: (map['accuracy'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
      isPerfect: map['accuracy'] != null && map['accuracy'] >= 90,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'recordedAt': recordedAt,
      'duration': duration,
      'accuracy': accuracy,
      'notes': notes,
      'isPerfect': isPerfect,
    };
  }
}

class RecitationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a recitation record
  Future<bool> saveRecitation({
    required String lessonId,
    required String lessonTitle,
    required int duration,
    required double accuracy,
    required String notes,
  }) async {
    try {
      if (_auth.currentUser == null) return false;

      final record = RecitationRecord(
        id: '',
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        recordedAt: DateTime.now(),
        duration: duration,
        accuracy: accuracy,
        notes: notes,
        isPerfect: accuracy >= 90,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .add(record.toMap());

      print('✅ Recitation saved successfully');
      return true;
    } catch (e) {
      print('❌ Error saving recitation: $e');
      return false;
    }
  }

  // Get user's recitation history
  Future<List<RecitationRecord>> getRecitationHistory({int limit = 20}) async {
    try {
      if (_auth.currentUser == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .orderBy('recordedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => RecitationRecord.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting recitation history: $e');
      return [];
    }
  }

  // Get recitations for a specific lesson
  Future<List<RecitationRecord>> getRecitationsForLesson(String lessonId) async {
    try {
      if (_auth.currentUser == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .where('lessonId', isEqualTo: lessonId)
          .orderBy('recordedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RecitationRecord.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting lesson recitations: $e');
      return [];
    }
  }

  // Get recitations this week
  Future<List<RecitationRecord>> getRecitationsThisWeek() async {
    try {
      if (_auth.currentUser == null) return [];

      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .where('recordedAt', isGreaterThanOrEqualTo: weekAgo)
          .orderBy('recordedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RecitationRecord.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting weekly recitations: $e');
      return [];
    }
  }

  // Calculate average accuracy
  Future<double> getAverageAccuracy() async {
    try {
      if (_auth.currentUser == null) return 0;

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .get();

      if (snapshot.docs.isEmpty) return 0;

      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['accuracy'] ?? 0).toDouble();
      }

      return total / snapshot.docs.length;
    } catch (e) {
      print('❌ Error calculating average accuracy: $e');
      return 0;
    }
  }

  // Stream recitation history (real-time)
  Stream<List<RecitationRecord>> streamRecitationHistory({int limit = 20}) {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('recitations')
        .orderBy('recordedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecitationRecord.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get total recitation count
  Future<int> getTotalRecitationCount() async {
    try {
      if (_auth.currentUser == null) return 0;

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('recitations')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('❌ Error getting total recitation count: $e');
      return 0;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeklyStats {
  final List<double> accuracyByDay; // 7 days
  final List<int> recitationsByDay;  // 7 days
  final double averageAccuracy;
  final int totalRecitations;
  final int perfectRecitations;
  final int longestStreak;
  final DateTime weekStart;
  final DateTime weekEnd;

  WeeklyStats({
    required this.accuracyByDay,
    required this.recitationsByDay,
    required this.averageAccuracy,
    required this.totalRecitations,
    required this.perfectRecitations,
    required this.longestStreak,
    required this.weekStart,
    required this.weekEnd,
  });
}

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get weekly statistics
  Future<WeeklyStats> getWeeklyStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      return _emptyWeeklyStats();
    }

    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recitations')
          .where('recordedAt', isGreaterThanOrEqualTo: weekStart)
          .where('recordedAt', isLessThanOrEqualTo: weekEnd)
          .get();

      // Initialize arrays for 7 days
      final accuracyByDay = List<double>.filled(7, 0.0);
      final recitationsByDay = List<int>.filled(7, 0);
      final countByDay = List<int>.filled(7, 0);

      double totalAccuracy = 0;
      int perfectCount = 0;
      int totalCount = 0;

      // Process recitations
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['recordedAt'] as Timestamp).toDate();
        final dayIndex = date.weekday - 1;
        final accuracy = (data['accuracy'] as num?)?.toDouble() ?? 0.0;

        recitationsByDay[dayIndex]++;
        accuracyByDay[dayIndex] += accuracy;
        countByDay[dayIndex]++;
        totalAccuracy += accuracy;
        totalCount++;

        if (accuracy >= 90) {
          perfectCount++;
        }
      }

      // Calculate averages
      for (int i = 0; i < 7; i++) {
        if (countByDay[i] > 0) {
          accuracyByDay[i] = accuracyByDay[i] / countByDay[i];
        }
      }

      final averageAccuracy = totalCount > 0 ? totalAccuracy / totalCount : 0.0;
      final longestStreak = await _calculateLongestStreak(user.uid);

      return WeeklyStats(
        accuracyByDay: accuracyByDay,
        recitationsByDay: recitationsByDay,
        averageAccuracy: averageAccuracy,
        totalRecitations: totalCount,
        perfectRecitations: perfectCount,
        longestStreak: longestStreak,
        weekStart: weekStart,
        weekEnd: weekEnd,
      );
    } catch (e) {
      print('❌ Error fetching weekly stats: $e');
      return _emptyWeeklyStats();
    }
  }

  /// Get stats for the last N days
  Future<Map<String, dynamic>> getProgressTrend(int days) async {
    final user = _auth.currentUser;
    if (user == null) {
      return {};
    }

    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recitations')
          .where('recordedAt', isGreaterThanOrEqualTo: startDate)
          .orderBy('recordedAt', descending: true)
          .get();

      List<double> accuracies = [];
      List<DateTime> dates = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final accuracy = (data['accuracy'] as num?)?.toDouble() ?? 0.0;
        final date = (data['recordedAt'] as Timestamp).toDate();

        accuracies.add(accuracy);
        dates.add(date);
      }

      return {
        'accuracies': accuracies,
        'dates': dates,
        'average': accuracies.isEmpty
            ? 0.0
            : accuracies.reduce((a, b) => a + b) / accuracies.length,
        'highest': accuracies.isEmpty ? 0.0 : accuracies.reduce((a, b) => a > b ? a : b),
        'lowest': accuracies.isEmpty ? 0.0 : accuracies.reduce((a, b) => a < b ? a : b),
      };
    } catch (e) {
      print('❌ Error fetching trend: $e');
      return {};
    }
  }

  /// Get most recited lessons
  Future<List<Map<String, dynamic>>> getMostRecitedLessons({int limit = 5}) async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recitations')
          .get();

      final lessonStats = <String, Map<String, dynamic>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final lessonId = data['lessonId'] as String?;
        final lessonTitle = data['lessonTitle'] as String?;
        final accuracy = (data['accuracy'] as num?)?.toDouble() ?? 0.0;

        if (lessonId != null && lessonTitle != null) {
          if (!lessonStats.containsKey(lessonId)) {
            lessonStats[lessonId] = {
              'title': lessonTitle,
              'count': 0,
              'totalAccuracy': 0.0,
              'perfectCount': 0,
            };
          }

          lessonStats[lessonId]!['count']++;
          lessonStats[lessonId]!['totalAccuracy'] += accuracy;
          if (accuracy >= 90) {
            lessonStats[lessonId]!['perfectCount']++;
          }
        }
      }

      final results = lessonStats.values
          .map((stats) => {
                ...stats,
                'averageAccuracy': stats['totalAccuracy'] / stats['count'],
              })
          .toList();

      // Sort by count descending
      results.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      return results.take(limit).toList();
    } catch (e) {
      print('❌ Error fetching most recited lessons: $e');
      return [];
    }
  }

  /// Calculate current streak
  Future<int> _calculateLongestStreak(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('recitations')
          .orderBy('recordedAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) return 0;

      int longestStreak = 1;
      int currentStreak = 1;
      DateTime? previousDate;

      for (var doc in snapshot.docs) {
        final date = (doc['recordedAt'] as Timestamp).toDate();
        final dateOnly = DateTime(date.year, date.month, date.day);

        if (previousDate != null) {
          final previousDateOnly =
              DateTime(previousDate.year, previousDate.month, previousDate.day);
          final daysDifference =
              previousDateOnly.difference(dateOnly).inDays;

          if (daysDifference == 1) {
            currentStreak++;
            longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
          } else if (daysDifference != 0) {
            currentStreak = 1;
          }
        }

        previousDate = date;
      }

      return longestStreak;
    } catch (e) {
      print('❌ Error calculating streak: $e');
      return 0;
    }
  }

  WeeklyStats _emptyWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return WeeklyStats(
      accuracyByDay: List.filled(7, 0.0),
      recitationsByDay: List.filled(7, 0),
      averageAccuracy: 0.0,
      totalRecitations: 0,
      perfectRecitations: 0,
      longestStreak: 0,
      weekStart: weekStart,
      weekEnd: weekStart.add(const Duration(days: 6)),
    );
  }
}

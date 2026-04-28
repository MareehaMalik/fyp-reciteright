import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tajweed_corrector/models/quiz_models.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  QuizService._internal();

  factory QuizService() {
    return _instance;
  }

  /// Save a quiz attempt to Firestore and update streak
  Future<void> saveQuizAttempt(String userId, QuizAttempt attempt) async {
    try {
      // Save the attempt
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_attempts')
          .doc(attempt.id)
          .set(attempt.toJson());

      // Update streak
      await updateStreak(userId, attempt.takenAt);
    } catch (e) {
      print('Error saving quiz attempt: $e');
      rethrow;
    }
  }

  /// Update user\'s quiz streak based on quiz timing
  /// STREAK LOGIC:
  /// 1. If no previous quiz: set streak = 1, streakExpiresAt = quizTakenAt + 24h
  /// 2. If quizTakenAt BEFORE streakExpiresAt (within window): streak stays same (no increment today)
  /// 3. If quizTakenAt AFTER streakExpiresAt but within 48h of lastQuizAt: increment streak, set new streakExpiresAt
  /// 4. If quizTakenAt MORE than 48h after lastQuizAt (missed day): DECREMENT streak (min 0), reset timer
  Future<void> updateStreak(String userId, DateTime quizTakenAt) async {
    try {
      final streakDocRef =
          _firestore.collection('users').doc(userId).collection('quiz_streak').doc('streak');

      final currentStreak = await streakDocRef.get();

      if (!currentStreak.exists) {
        // First quiz ever
        await streakDocRef.set({
          'currentStreak': 1,
          'longestStreak': 1,
          'lastQuizAt': Timestamp.fromDate(quizTakenAt),
          'streakExpiresAt': Timestamp.fromDate(quizTakenAt.add(const Duration(hours: 24))),
          'totalQuizzesTaken': 1,
          'totalScore': 10, // Assuming perfect for now, will be updated correctly in practice
          'averageScore': 10.0,
        });
      } else {
         final data = currentStreak.data()!;
         final lastQuizAt = (data['lastQuizAt'] as Timestamp).toDate();
         final streakExpiresAt = (data['streakExpiresAt'] as Timestamp).toDate();
         int currentStreakValue = data['currentStreak'] ?? 0;
         int longestStreak = data['longestStreak'] ?? 0;
         int totalQuizzes = data['totalQuizzesTaken'] ?? 0;

        // Determine streak status
        if (quizTakenAt.isBefore(streakExpiresAt)) {
          // Still within the same 24-hour window - don't increment
          // (user can take many quizzes per day but streak only increments once per day)
        } else if (quizTakenAt.isAfter(streakExpiresAt) &&
            quizTakenAt.difference(lastQuizAt).inHours < 48) {
          // Exactly on the next day within grace period - increment
          currentStreakValue++;
        } else if (quizTakenAt.difference(lastQuizAt).inHours >= 48) {
          // Missed a day - decrement (minimum 0)
          currentStreakValue = (currentStreakValue - 1).clamp(0, 9999);
        }

        // Update longest streak if needed
        if (currentStreakValue > longestStreak) {
          longestStreak = currentStreakValue;
        }

        // Update totals
        totalQuizzes++;

        // Update scores (fetch latest 10 quizzes for average)
        final recentAttempts = await _firestore
            .collection('users')
            .doc(userId)
            .collection('quiz_attempts')
            .orderBy('takenAt', descending: true)
            .limit(10)
            .get();

        double avgScore = 0.0;
        if (recentAttempts.docs.isNotEmpty) {
          final scores =
              recentAttempts.docs.map((d) => (d['score'] ?? 0).toDouble()).toList();
          avgScore = scores.reduce((a, b) => a + b) / scores.length;
        }

        // Update streak document
        final newExpiresAt = quizTakenAt.add(const Duration(hours: 24));
        await streakDocRef.update({
          'currentStreak': currentStreakValue,
          'longestStreak': longestStreak,
          'lastQuizAt': Timestamp.fromDate(quizTakenAt),
          'streakExpiresAt': Timestamp.fromDate(newExpiresAt),
          'totalQuizzesTaken': totalQuizzes,
          'averageScore': avgScore,
        });
      }
    } catch (e) {
      print('Error updating streak: $e');
      rethrow;
    }
  }

  /// Get current streak data for a user
  Future<QuizStreakData?> getStreakData(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_streak')
          .doc('streak')
          .get();

      if (doc.exists) {
        return QuizStreakData.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting streak data: $e');
      return null;
    }
  }

  /// Get stream of quiz history for a user
  Stream<List<QuizAttempt>> getQuizHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_attempts')
        .orderBy('takenAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => QuizAttempt.fromJson(doc.data()))
          .toList();
    });
  }

  /// Check if streak warning should be shown (expires in < 4 hours)
  Future<bool> shouldShowStreakWarning(String userId) async {
    try {
      final streakData = await getStreakData(userId);
      return streakData != null && streakData.isExpiringSoon && streakData.isStreakActive;
    } catch (e) {
      print('Error checking streak warning: $e');
      return false;
    }
  }

  /// Get grade string based on score
  static String getGrade(int score) {
    if (score == 10) return 'Perfect! 🌟';
    if (score >= 8) return 'Excellent! ✨';
    if (score >= 6) return 'Good Job! 👍';
    if (score >= 4) return 'Keep Practicing 📚';
    return 'Needs More Study 💪';
  }

  /// Get improvement guide based on quiz results
  static String getImprovementGuide(List<QuizQuestionResult> results) {
    // Count correct answers by category
    final categoryStats = <String, Map<String, int>>{
      'tajweed': {'correct': 0, 'total': 0},
      'islamic': {'correct': 0, 'total': 0},
      'quran': {'correct': 0, 'total': 0},
      'prophets': {'correct': 0, 'total': 0},
    };

    for (final result in results) {
      final cat = result.category;
      if (categoryStats.containsKey(cat)) {
        categoryStats[cat]!['total'] = categoryStats[cat]!['total']! + 1;
        if (result.isCorrect) {
          categoryStats[cat]!['correct'] = categoryStats[cat]!['correct']! + 1;
        }
      }
    }

    final guide = <String>[];

    // Tajweed feedback
    final tajTotal = categoryStats['tajweed']!['total']!;
    final tajCorrect = categoryStats['tajweed']!['correct']!;
    if (tajTotal > 0) {
      if (tajCorrect == tajTotal) {
        guide.add('You got all Tajweed questions right! 🎉');
      } else if (tajCorrect >= tajTotal * 0.7) {
        guide.add('Great Tajweed knowledge! 👏 Review the rules you mixed up and practice pronouncing them.');
      } else {
        guide.add('💡 Tajweed needs work. Study the Madd rules, Ghunnah, and Idgham. Practice daily recitation!');
      }
    }

    // Islamic feedback
    final islTotal = categoryStats['islamic']!['total']!;
    final islCorrect = categoryStats['islamic']!['correct']!;
    if (islTotal > 0) {
      if (islCorrect == islTotal) {
        guide.add('Islamic knowledge is strong! 🌙');
      } else if (islCorrect >= islTotal * 0.7) {
        guide.add('Good Islamic foundation! 📖 Focus on the topics you found tricky.');
      } else {
        guide.add('📚 Review Islamic history, the Five Pillars, and major events like the Battle of Badr.');
      }
    }

    // Quran feedback
    final qurTotal = categoryStats['quran']!['total']!;
    final qurCorrect = categoryStats['quran']!['correct']!;
    if (qurTotal > 0) {
      if (qurCorrect == qurTotal) {
        guide.add('Your Quran knowledge is excellent! 📖✨');
      } else if (qurCorrect >= qurTotal * 0.7) {
        guide.add('Good Quranic knowledge! Study Surah divisions, names, and structure.');
      } else {
        guide.add('🕌 Learn the Quran structure: 114 Surahs, 30 Juz, 6,236 Ayahs. Read daily!');
      }
    }

    // Prophets feedback
    final propTotal = categoryStats['prophets']!['total']!;
    final propCorrect = categoryStats['prophets']!['correct']!;
    if (propTotal > 0) {
      if (propCorrect == propTotal) {
        guide.add('Prophetic history mastered! 🎯');
      } else if (propCorrect >= propTotal * 0.7) {
        guide.add('Strong prophetic knowledge! 👳 Review the lives of the prophets mentioned.');
      } else {
        guide.add('☪️ Study the prophets: learn about the 25 mentioned in the Quran and their stories.');
      }
    }

    guide.add('💪 Keep practicing daily. Consistency builds knowledge!');

    return guide.join('\n');
  }

  /// Get statistics across all quizzes for a user
  Future<Map<String, dynamic>> getUserQuizStats(String userId) async {
    try {
      final attempts = await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_attempts')
          .get();

      if (attempts.docs.isEmpty) {
        return {
          'totalQuizzes': 0,
          'averageScore': 0.0,
          'bestScore': 0,
          'worstScore': 0,
          'totalTimeSeconds': 0,
        };
      }

      final quizzes =
          attempts.docs.map((d) => QuizAttempt.fromJson(d.data())).toList();
      final scores = quizzes.map((q) => q.score).toList();
      final totalTime =
          quizzes.fold<int>(0, (sum, q) => sum + q.timeTakenSeconds);

      return {
        'totalQuizzes': quizzes.length,
        'averageScore': scores.reduce((a, b) => a + b) / scores.length,
        'bestScore': scores.reduce((a, b) => a > b ? a : b),
        'worstScore': scores.reduce((a, b) => a < b ? a : b),
        'totalTimeSeconds': totalTime,
      };
    } catch (e) {
      print('Error getting quiz stats: $e');
      return {};
    }
  }

  /// Delete a quiz attempt (for testing or user request)
  Future<void> deleteQuizAttempt(String userId, String attemptId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_attempts')
          .doc(attemptId)
          .delete();
    } catch (e) {
      print('Error deleting quiz attempt: $e');
      rethrow;
    }
  }

  /// Reset user's streak (admin/account deletion scenario)
  Future<void> resetStreak(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('quiz_streak')
          .doc('streak')
          .delete();
    } catch (e) {
      print('Error resetting streak: $e');
      rethrow;
    }
  }
}


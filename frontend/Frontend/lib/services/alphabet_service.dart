import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajweed_corrector/data/arabic_letters.dart';
import 'package:tajweed_corrector/models/arabic_letter.dart';

class AlphabetService {
  static const String _progressKey = 'alphabet_progress';
  static const String _streakKey = 'alphabet_streak_current';
  static const String _bestStreakKey = 'alphabet_streak_best';
  static const String _lastPracticeDateKey = 'alphabet_streak_last_date';

  static const int listenThreshold = 3;
  static const int quizPassScore = 80;

  Future<List<ArabicLetter>> getLetters() async {
    return arabicLetters;
  }

  Future<ArabicLetter?> getLetterById(String id) async {
    try {
      return arabicLetters.firstWhere((letter) => letter.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, ArabicLetterProgress>> _loadProgressMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String, ArabicLetterProgress>{};
    decoded.forEach((key, value) {
      result[key] = ArabicLetterProgress.fromMap(
        Map<String, dynamic>.from(value as Map),
      );
    });
    return result;
  }

  Future<void> _saveProgressMap(Map<String, ArabicLetterProgress> map) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = map.map((key, value) => MapEntry(key, value.toMap()));
    await prefs.setString(_progressKey, jsonEncode(encoded));
  }

  Future<ArabicLetterProgress> getLetterProgress(String letterId) async {
    final progressMap = await _loadProgressMap();
    return progressMap[letterId] ?? ArabicLetterProgress.empty();
  }

  Future<void> markLetterPracticed(String letterId) async {
    final progressMap = await _loadProgressMap();
    final current = progressMap[letterId] ?? ArabicLetterProgress.empty();
    final newTimes = current.timesPracticed + 1;

    final newProgress = current.copyWith(
      timesPracticed: newTimes,
      lastPracticedDate: _todayKey(),
      isMastered: _isMastered(
        timesPracticed: newTimes,
        lastQuizScore: current.lastQuizScore,
      ),
    );

    progressMap[letterId] = newProgress;
    await _saveProgressMap(progressMap);
    await _updateStreak();
  }

  Future<void> recordQuizResult(String letterId, int score,
      {required int totalQuestions, required int correctAnswers}) async {
    final progressMap = await _loadProgressMap();
    final current = progressMap[letterId] ?? ArabicLetterProgress.empty();

    final newProgress = current.copyWith(
      lastQuizScore: score,
      totalQuizAttempts: current.totalQuizAttempts + totalQuestions,
      totalQuizCorrect: current.totalQuizCorrect + correctAnswers,
      isMastered: _isMastered(
        timesPracticed: current.timesPracticed,
        lastQuizScore: score,
      ),
    );

    progressMap[letterId] = newProgress;
    await _saveProgressMap(progressMap);
    await _updateStreak();
  }

  Future<AlphabetProgressSummary> getProgressSummary() async {
    final progressMap = await _loadProgressMap();
    final totalLetters = arabicLetters.length;
    final learnedLetters = progressMap.values
        .where((progress) => progress.isMastered)
        .length;

    final prefs = await SharedPreferences.getInstance();
    final currentStreak = prefs.getInt(_streakKey) ?? 0;
    final bestStreak = prefs.getInt(_bestStreakKey) ?? 0;

    return AlphabetProgressSummary(
      totalLetters: totalLetters,
      learnedLetters: learnedLetters,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
  }

  Future<AlphabetPronunciationResult> comparePronunciation(String letterId) async {
    final random = Random();
    final score = 65 + random.nextInt(36);
    final feedback = score >= 85
        ? 'Great pronunciation!'
        : score >= 75
            ? 'Nice! Try to make the sound clearer.'
            : 'Try again with a slower, deeper sound.';

    return AlphabetPronunciationResult(score: score, feedback: feedback);
  }

  bool _isMastered({required int timesPracticed, required int lastQuizScore}) {
    return timesPracticed >= listenThreshold && lastQuizScore >= quizPassScore;
  }

  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastPracticeDateKey);
    final today = _todayKey();

    if (lastDate == today) {
      return;
    }

    int currentStreak = prefs.getInt(_streakKey) ?? 0;
    if (_isYesterday(lastDate, today)) {
      currentStreak += 1;
    } else {
      currentStreak = 1;
    }

    final bestStreak = max(currentStreak, prefs.getInt(_bestStreakKey) ?? 0);

    await prefs.setInt(_streakKey, currentStreak);
    await prefs.setInt(_bestStreakKey, bestStreak);
    await prefs.setString(_lastPracticeDateKey, today);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool _isYesterday(String? lastDate, String today) {
    if (lastDate == null) return false;
    final last = DateTime.tryParse(lastDate);
    final current = DateTime.tryParse(today);
    if (last == null || current == null) return false;
    return current.difference(last).inDays == 1;
  }
}


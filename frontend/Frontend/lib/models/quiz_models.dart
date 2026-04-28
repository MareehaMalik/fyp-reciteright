import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String category;
  final String explanation;
  final String difficulty;
  final String? arabicText;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.category,
    required this.explanation,
    required this.difficulty,
    this.arabicText,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
      category: json['category'] ?? 'tajweed',
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      arabicText: json['arabicText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'category': category,
      'explanation': explanation,
      'difficulty': difficulty,
      'arabicText': arabicText,
    };
  }

  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctIndex,
    String? category,
    String? explanation,
    String? difficulty,
    String? arabicText,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      category: category ?? this.category,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      arabicText: arabicText ?? this.arabicText,
    );
  }

  @override
  String toString() => 'QuizQuestion($id, $category, $difficulty)';
}

class QuizQuestionResult {
  final String questionId;
  final String questionText;
  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final String explanation;
  final String category;

  QuizQuestionResult({
    required this.questionId,
    required this.questionText,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.explanation,
    required this.category,
  });

  factory QuizQuestionResult.fromJson(Map<String, dynamic> json) {
    return QuizQuestionResult(
      questionId: json['questionId'] ?? '',
      questionText: json['questionText'] ?? '',
      selectedIndex: json['selectedIndex'] ?? -1,
      correctIndex: json['correctIndex'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
      explanation: json['explanation'] ?? '',
      category: json['category'] ?? 'tajweed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'selectedIndex': selectedIndex,
      'correctIndex': correctIndex,
      'isCorrect': isCorrect,
      'explanation': explanation,
      'category': category,
    };
  }

  QuizQuestionResult copyWith({
    String? questionId,
    String? questionText,
    int? selectedIndex,
    int? correctIndex,
    bool? isCorrect,
    String? explanation,
    String? category,
  }) {
    return QuizQuestionResult(
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      correctIndex: correctIndex ?? this.correctIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
    );
  }
}

class QuizAttempt {
  final String id;
  final String userId;
  final DateTime takenAt;
  final int score;
  final int totalQuestions;
  final int timeTakenSeconds;
  final List<QuizQuestionResult> results;
  final String grade;

  QuizAttempt({
    required this.id,
    required this.userId,
    required this.takenAt,
    required this.score,
    required this.totalQuestions,
    required this.timeTakenSeconds,
    required this.results,
    required this.grade,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      takenAt: json['takenAt'] is Timestamp
          ? (json['takenAt'] as Timestamp).toDate()
          : DateTime.parse(json['takenAt'] ?? DateTime.now().toIso8601String()),
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 10,
      timeTakenSeconds: json['timeTakenSeconds'] ?? 0,
      results: (json['results'] as List?)
              ?.map((r) => QuizQuestionResult.fromJson(
                  r is Map<String, dynamic> ? r : Map<String, dynamic>()))
              .toList() ??
          [],
      grade: json['grade'] ?? 'Needs Work',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'takenAt': Timestamp.fromDate(takenAt),
      'score': score,
      'totalQuestions': totalQuestions,
      'timeTakenSeconds': timeTakenSeconds,
      'results': results.map((r) => r.toJson()).toList(),
      'grade': grade,
    };
  }

  QuizAttempt copyWith({
    String? id,
    String? userId,
    DateTime? takenAt,
    int? score,
    int? totalQuestions,
    int? timeTakenSeconds,
    List<QuizQuestionResult>? results,
    String? grade,
  }) {
    return QuizAttempt(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      takenAt: takenAt ?? this.takenAt,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeTakenSeconds: timeTakenSeconds ?? this.timeTakenSeconds,
      results: results ?? this.results,
      grade: grade ?? this.grade,
    );
  }

  String get formattedTime {
    int minutes = timeTakenSeconds ~/ 60;
    int seconds = timeTakenSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  String toString() =>
      'QuizAttempt($id, userId=$userId, score=$score/10, grade=$grade)';
}

class QuizStreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastQuizAt;
  final DateTime? streakExpiresAt;
  final bool isStreakActive;
  final bool isExpiringSoon;
  final int totalQuizzesTaken;
  final double averageScore;

  QuizStreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastQuizAt,
    this.streakExpiresAt,
    required this.isStreakActive,
    required this.isExpiringSoon,
    required this.totalQuizzesTaken,
    required this.averageScore,
  });

  factory QuizStreakData.empty() {
    return QuizStreakData(
      currentStreak: 0,
      longestStreak: 0,
      lastQuizAt: null,
      streakExpiresAt: null,
      isStreakActive: false,
      isExpiringSoon: false,
      totalQuizzesTaken: 0,
      averageScore: 0.0,
    );
  }

  factory QuizStreakData.fromJson(Map<String, dynamic> json) {
    final expiresAt = json['streakExpiresAt'] is Timestamp
        ? (json['streakExpiresAt'] as Timestamp).toDate()
        : (json['streakExpiresAt'] != null ? DateTime.parse(json['streakExpiresAt']) : null);

    final lastQuiz = json['lastQuizAt'] is Timestamp
        ? (json['lastQuizAt'] as Timestamp).toDate()
        : (json['lastQuizAt'] != null ? DateTime.parse(json['lastQuizAt']) : null);

    final now = DateTime.now();
    final isActive = expiresAt != null && expiresAt.isAfter(now);
    final isExpiring = isActive &&
        expiresAt.difference(now).inHours < 4;

    return QuizStreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastQuizAt: lastQuiz,
      streakExpiresAt: expiresAt,
      isStreakActive: isActive,
      isExpiringSoon: isExpiring,
      totalQuizzesTaken: json['totalQuizzesTaken'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastQuizAt': lastQuizAt != null ? Timestamp.fromDate(lastQuizAt!) : null,
      'streakExpiresAt': streakExpiresAt != null ? Timestamp.fromDate(streakExpiresAt!) : null,
      'totalQuizzesTaken': totalQuizzesTaken,
      'averageScore': averageScore,
    };
  }

  QuizStreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastQuizAt,
    DateTime? streakExpiresAt,
    bool? isStreakActive,
    bool? isExpiringSoon,
    int? totalQuizzesTaken,
    double? averageScore,
  }) {
    return QuizStreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastQuizAt: lastQuizAt ?? this.lastQuizAt,
      streakExpiresAt: streakExpiresAt ?? this.streakExpiresAt,
      isStreakActive: isStreakActive ?? this.isStreakActive,
      isExpiringSoon: isExpiringSoon ?? this.isExpiringSoon,
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      averageScore: averageScore ?? this.averageScore,
    );
  }

  String get expiryCountdown {
    if (streakExpiresAt == null) return '';
    final diff = streakExpiresAt!.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  String toString() =>
      'QuizStreakData(current=$currentStreak, longest=$longestStreak, '
      'active=$isStreakActive, total=$totalQuizzesTaken, avg=$averageScore)';
}


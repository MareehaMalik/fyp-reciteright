class ArabicLetter {
  final String id;
  final String glyph;
  final String name;
  final String transliteration;
  final int lessonIndex;
  final String lessonLabel;
  final String? articulation;
  final String? audioUrl;
  final List<String> exampleAudioUrls;
  final List<String> exampleSyllables;

  const ArabicLetter({
    required this.id,
    required this.glyph,
    required this.name,
    required this.transliteration,
    required this.lessonIndex,
    required this.lessonLabel,
    this.articulation,
    this.audioUrl,
    this.exampleAudioUrls = const [],
    this.exampleSyllables = const [],
  });
}

class ArabicLetterProgress {
  final int timesPracticed;
  final int lastQuizScore;
  final int totalQuizAttempts;
  final int totalQuizCorrect;
  final bool isMastered;
  final String? lastPracticedDate;

  const ArabicLetterProgress({
    required this.timesPracticed,
    required this.lastQuizScore,
    required this.totalQuizAttempts,
    required this.totalQuizCorrect,
    required this.isMastered,
    this.lastPracticedDate,
  });

  factory ArabicLetterProgress.empty() {
    return const ArabicLetterProgress(
      timesPracticed: 0,
      lastQuizScore: 0,
      totalQuizAttempts: 0,
      totalQuizCorrect: 0,
      isMastered: false,
      lastPracticedDate: null,
    );
  }

  ArabicLetterProgress copyWith({
    int? timesPracticed,
    int? lastQuizScore,
    int? totalQuizAttempts,
    int? totalQuizCorrect,
    bool? isMastered,
    String? lastPracticedDate,
  }) {
    return ArabicLetterProgress(
      timesPracticed: timesPracticed ?? this.timesPracticed,
      lastQuizScore: lastQuizScore ?? this.lastQuizScore,
      totalQuizAttempts: totalQuizAttempts ?? this.totalQuizAttempts,
      totalQuizCorrect: totalQuizCorrect ?? this.totalQuizCorrect,
      isMastered: isMastered ?? this.isMastered,
      lastPracticedDate: lastPracticedDate ?? this.lastPracticedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timesPracticed': timesPracticed,
      'lastQuizScore': lastQuizScore,
      'totalQuizAttempts': totalQuizAttempts,
      'totalQuizCorrect': totalQuizCorrect,
      'isMastered': isMastered,
      'lastPracticedDate': lastPracticedDate,
    };
  }

  factory ArabicLetterProgress.fromMap(Map<String, dynamic> map) {
    return ArabicLetterProgress(
      timesPracticed: map['timesPracticed'] ?? 0,
      lastQuizScore: map['lastQuizScore'] ?? 0,
      totalQuizAttempts: map['totalQuizAttempts'] ?? 0,
      totalQuizCorrect: map['totalQuizCorrect'] ?? 0,
      isMastered: map['isMastered'] ?? false,
      lastPracticedDate: map['lastPracticedDate'],
    );
  }
}

class AlphabetProgressSummary {
  final int totalLetters;
  final int learnedLetters;
  final int currentStreak;
  final int bestStreak;

  const AlphabetProgressSummary({
    required this.totalLetters,
    required this.learnedLetters,
    required this.currentStreak,
    required this.bestStreak,
  });
}

class AlphabetPronunciationResult {
  final int score;
  final String feedback;

  const AlphabetPronunciationResult({
    required this.score,
    required this.feedback,
  });
}


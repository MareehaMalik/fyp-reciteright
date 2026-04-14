class Mistake {
  final String word;
  final int ayah;
  final int surah;
  final List<String> tajweedRules;
  final String errorType;
  final double similarity;
  final String occurredAt;
  final String sessionId;

  Mistake({
    required this.word,
    required this.ayah,
    required this.surah,
    this.tajweedRules = const [],
    this.errorType = 'mispronunciation',
    this.similarity = 0.0,
    this.occurredAt = '',
    this.sessionId = '',
  });

  factory Mistake.fromJson(Map<String, dynamic> json) {
    return Mistake(
      word: (json['word'] ?? '').toString(),
      ayah: (json['ayah'] as num?)?.toInt() ?? 0,
      surah: (json['surah'] as num?)?.toInt() ?? 0,
      tajweedRules: (json['tajweedRules'] as List?)?.map((e) => e.toString()).toList() ??
          (json['tajweed_rules'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      errorType: (json['errorType'] ?? json['error_type'] ?? 'mispronunciation').toString(),
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0.0,
      occurredAt: (json['occurredAt'] ?? json['occurred_at'] ?? '').toString(),
      sessionId: (json['sessionId'] ?? json['session_id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'ayah': ayah,
        'surah': surah,
        'tajweedRules': tajweedRules,
        'errorType': errorType,
        'similarity': similarity,
        'occurredAt': occurredAt,
        'sessionId': sessionId,
      };
}

class RecitationSession {
  final String id;
  final String userId;
  final int surah;
  final int ayah;
  final String mode;
  final double accuracyScore;
  final double whisperScore;
  final double mfccScore;
  final String dateTime;
  final int durationSeconds;
  final List<Mistake> mistakes;
  final int totalWords;
  final int correctWords;
  final int closeWords;
  final int missingWords;
  final int extraWords;
  final String? referenceAudioUrl;
  final String transcribedText;
  final String correctText;

  RecitationSession({
    required this.id,
    required this.userId,
    required this.surah,
    required this.ayah,
    required this.dateTime,
    this.mode = 'recitation',
    this.accuracyScore = 0.0,
    this.whisperScore = 0.0,
    this.mfccScore = 0.0,
    this.durationSeconds = 0,
    this.mistakes = const [],
    this.totalWords = 0,
    this.correctWords = 0,
    this.closeWords = 0,
    this.missingWords = 0,
    this.extraWords = 0,
    this.referenceAudioUrl,
    this.transcribedText = '',
    this.correctText = '',
  });

  factory RecitationSession.fromJson(Map<String, dynamic> json) {
    return RecitationSession(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      surah: (json['surah'] as num?)?.toInt() ?? 0,
      ayah: (json['ayah'] as num?)?.toInt() ?? 0,
      mode: (json['mode'] ?? 'recitation').toString(),
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ??
          (json['accuracy_score'] as num?)?.toDouble() ??
          0.0,
      whisperScore: (json['whisperScore'] as num?)?.toDouble() ??
          (json['whisper_score'] as num?)?.toDouble() ??
          0.0,
      mfccScore: (json['mfccScore'] as num?)?.toDouble() ??
          (json['mfcc_score'] as num?)?.toDouble() ??
          0.0,
      dateTime: (json['dateTime'] ?? json['date_time'] ?? '').toString(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ??
          (json['duration_seconds'] as num?)?.toInt() ??
          0,
      mistakes: (json['mistakes'] as List?)
              ?.map((e) => Mistake.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalWords: (json['totalWords'] as num?)?.toInt() ??
          (json['total_words'] as num?)?.toInt() ??
          0,
      correctWords: (json['correctWords'] as num?)?.toInt() ??
          (json['correct_words'] as num?)?.toInt() ??
          0,
      closeWords: (json['closeWords'] as num?)?.toInt() ??
          (json['close_words'] as num?)?.toInt() ??
          0,
      missingWords: (json['missingWords'] as num?)?.toInt() ??
          (json['missing_words'] as num?)?.toInt() ??
          0,
      extraWords: (json['extraWords'] as num?)?.toInt() ??
          (json['extra_words'] as num?)?.toInt() ??
          0,
      referenceAudioUrl:
          (json['referenceAudioUrl'] ?? json['reference_audio_url'])?.toString(),
      transcribedText: (json['transcribedText'] ?? json['transcribed_text'] ?? '').toString(),
      correctText: (json['correctText'] ?? json['correct_text'] ?? '').toString(),
    );
  }

  int get daysAgo {
    try {
      return DateTime.now().difference(DateTime.parse(dateTime).toLocal()).inDays;
    } catch (_) {
      return 0;
    }
  }
}

class DailyActivity {
  final String day;
  final String date;
  final bool hasSession;
  final int sessionCount;
  final int totalMinutes;
  final double avgAccuracy;

  DailyActivity({
    required this.day,
    required this.date,
    required this.hasSession,
    this.sessionCount = 0,
    this.totalMinutes = 0,
    this.avgAccuracy = 0.0,
  });

  factory DailyActivity.fromJson(Map<String, dynamic> json) => DailyActivity(
        day: (json['day'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        hasSession: json['hasSession'] == true || json['has_session'] == true,
        sessionCount: (json['sessionCount'] as num?)?.toInt() ??
            (json['session_count'] as num?)?.toInt() ??
            0,
        totalMinutes: (json['totalMinutes'] as num?)?.toInt() ??
            (json['total_minutes'] as num?)?.toInt() ??
            0,
        avgAccuracy: (json['avgAccuracy'] as num?)?.toDouble() ??
            (json['avg_accuracy'] as num?)?.toDouble() ??
            0.0,
      );
}

class RecentRecitation {
  final String title;
  final String mode;
  final double accuracy;
  final int daysAgo;
  final String sessionId;
  final String dateTime;

  RecentRecitation({
    required this.title,
    required this.mode,
    required this.accuracy,
    required this.daysAgo,
    required this.sessionId,
    required this.dateTime,
  });

  factory RecentRecitation.fromJson(Map<String, dynamic> json) => RecentRecitation(
        title: (json['title'] ?? '').toString(),
        mode: (json['mode'] ?? 'recitation').toString(),
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
        daysAgo: (json['daysAgo'] as num?)?.toInt() ??
            (json['days_ago'] as num?)?.toInt() ??
            0,
        sessionId: (json['sessionId'] ?? json['session_id'] ?? '').toString(),
        dateTime: (json['dateTime'] ?? json['date_time'] ?? '').toString(),
      );

  String get timeAgoDisplay {
    if (daysAgo <= 0) return 'Today';
    if (daysAgo == 1) return '1 day ago';
    return '$daysAgo days ago';
  }
}

class WeeklyProgressSummary {
  final int thisWeekCount;
  final double avgAccuracy;
  final int perfectCount;
  final List<DailyActivity> days;
  final List<RecentRecitation> recentRecitations;

  WeeklyProgressSummary({
    required this.thisWeekCount,
    required this.avgAccuracy,
    required this.perfectCount,
    this.days = const [],
    this.recentRecitations = const [],
  });

  factory WeeklyProgressSummary.fromJson(Map<String, dynamic> json) => WeeklyProgressSummary(
        thisWeekCount: (json['thisWeekCount'] as num?)?.toInt() ?? 0,
        avgAccuracy: (json['avgAccuracy'] as num?)?.toDouble() ?? 0.0,
        perfectCount: (json['perfectCount'] as num?)?.toInt() ?? 0,
        days: (json['days'] as List?)
                ?.map((e) => DailyActivity.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        recentRecitations: (json['recentRecitations'] as List?)
                ?.map((e) => RecentRecitation.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

class MistakeWord {
  final String word;
  final int times;
  final double lastSimilarity;
  final String lastOccurredAt;

  MistakeWord({
    required this.word,
    required this.times,
    required this.lastSimilarity,
    required this.lastOccurredAt,
  });

  factory MistakeWord.fromJson(Map<String, dynamic> json) => MistakeWord(
        word: (json['word'] ?? '').toString(),
        times: (json['times'] as num?)?.toInt() ?? 0,
        lastSimilarity: (json['lastSimilarity'] as num?)?.toDouble() ??
            (json['last_similarity'] as num?)?.toDouble() ??
            0.0,
        lastOccurredAt: (json['lastOccurredAt'] ?? json['last_occurred_at'] ?? '').toString(),
      );
}

class AyahMistakeSummary {
  final int surahNumber;
  final String surahName;
  final int ayah;
  final int mistakeCount;
  final String lastPracticedAt;
  final List<MistakeWord> words;

  AyahMistakeSummary({
    required this.surahNumber,
    required this.surahName,
    required this.ayah,
    required this.mistakeCount,
    required this.lastPracticedAt,
    this.words = const [],
  });

  factory AyahMistakeSummary.fromJson(Map<String, dynamic> json) => AyahMistakeSummary(
        surahNumber: (json['surahNumber'] as num?)?.toInt() ??
            (json['surah_number'] as num?)?.toInt() ??
            0,
        surahName: (json['surahName'] ?? json['surah_name'] ?? '').toString(),
        ayah: (json['ayah'] as num?)?.toInt() ?? 0,
        mistakeCount: (json['mistakeCount'] as num?)?.toInt() ??
            (json['mistake_count'] as num?)?.toInt() ??
            0,
        lastPracticedAt: (json['lastPracticedAt'] ?? json['last_practiced_at'] ?? '').toString(),
        words: (json['words'] as List?)
                ?.map((e) => MistakeWord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

class MistakesSummary {
  final List<AyahMistakeSummary> byAyah;
  final int totalMistakes;
  final String? mostRecentMistakeAt;

  MistakesSummary({
    this.byAyah = const [],
    this.totalMistakes = 0,
    this.mostRecentMistakeAt,
  });

  factory MistakesSummary.fromJson(Map<String, dynamic> json) => MistakesSummary(
        byAyah: (json['byAyah'] as List?)
                ?.map((e) => AyahMistakeSummary.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        totalMistakes: (json['totalMistakes'] as num?)?.toInt() ?? 0,
        mostRecentMistakeAt: (json['mostRecentMistakeAt'])?.toString(),
      );
}

class HomeMetricsWithStreak {
  final int currentStreak;
  final int longestStreak;
  final String? lastSessionDate;
  final int todayMinutes;
  final int thisWeekMinutes;

  HomeMetricsWithStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastSessionDate,
    this.todayMinutes = 0,
    this.thisWeekMinutes = 0,
  });

  factory HomeMetricsWithStreak.fromJson(Map<String, dynamic> json) =>
      HomeMetricsWithStreak(
        currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
        longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
        lastSessionDate: json['lastSessionDate']?.toString(),
        todayMinutes: (json['todayMinutes'] as num?)?.toInt() ?? 0,
        thisWeekMinutes: (json['thisWeekMinutes'] as num?)?.toInt() ?? 0,
      );
}

class AccuracyHistoryEntry {
  final String sessionId;
  final double score;
  final String recordedAt;

  AccuracyHistoryEntry({
    required this.sessionId,
    required this.score,
    required this.recordedAt,
  });

  factory AccuracyHistoryEntry.fromJson(Map<String, dynamic> json) => AccuracyHistoryEntry(
        sessionId: (json['sessionId'] ?? '').toString(),
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        recordedAt: (json['recordedAt'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'score': score,
        'recordedAt': recordedAt,
      };
}

class MemorizationItem {
  final String userId;
  final int surahNumber;
  final int ayahNumber;
  final String status;
  final List<AccuracyHistoryEntry> accuracyHistory;
  final int timesRecited;
  final String? lastRecitedAt;
  final String? lastStatusChangeAt;

  MemorizationItem({
    required this.userId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.status,
    this.accuracyHistory = const [],
    this.timesRecited = 0,
    this.lastRecitedAt,
    this.lastStatusChangeAt,
  });

  factory MemorizationItem.fromJson(Map<String, dynamic> json) => MemorizationItem(
        userId: (json['userId'] ?? '').toString(),
        surahNumber: (json['surahNumber'] as num?)?.toInt() ?? 0,
        ayahNumber: (json['ayahNumber'] as num?)?.toInt() ?? 0,
        status: (json['status'] ?? 'not_started').toString(),
        accuracyHistory: (json['accuracyHistory'] as List?)
                ?.map((e) => AccuracyHistoryEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        timesRecited: (json['timesRecited'] as num?)?.toInt() ?? 0,
        lastRecitedAt: json['lastRecitedAt']?.toString(),
        lastStatusChangeAt: json['lastStatusChangeAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'status': status,
        'accuracyHistory': accuracyHistory.map((e) => e.toJson()).toList(),
        'timesRecited': timesRecited,
        'lastRecitedAt': lastRecitedAt,
        'lastStatusChangeAt': lastStatusChangeAt,
      };
}


class SurahMemorizationSummary {
  final int surahNumber;
  final String surahName;
  final int totalAyahs;
  final int memorizedAyahs;
  final double percentMemorized;
  final String? lastActivityAt;

  SurahMemorizationSummary({
    required this.surahNumber,
    required this.surahName,
    required this.totalAyahs,
    required this.memorizedAyahs,
    required this.percentMemorized,
    this.lastActivityAt,
  });

  factory SurahMemorizationSummary.fromJson(Map<String, dynamic> json) =>
      SurahMemorizationSummary(
        surahNumber: (json['surahNumber'] as num?)?.toInt() ?? 0,
        surahName: (json['surahName'] ?? '').toString(),
        totalAyahs: (json['totalAyahs'] as num?)?.toInt() ?? 0,
        memorizedAyahs: (json['memorizedAyahs'] as num?)?.toInt() ?? 0,
        percentMemorized: (json['percentMemorized'] as num?)?.toDouble() ?? 0.0,
        lastActivityAt: json['lastActivityAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'totalAyahs': totalAyahs,
        'memorizedAyahs': memorizedAyahs,
        'percentMemorized': percentMemorized,
        'lastActivityAt': lastActivityAt,
      };
}

class MemorizationSummary {
  final double overallPercent;
  final List<SurahMemorizationSummary> surahSummaries;

  MemorizationSummary({
    required this.overallPercent,
    this.surahSummaries = const [],
  });

  factory MemorizationSummary.fromJson(Map<String, dynamic> json) =>
      MemorizationSummary(
        overallPercent: (json['overallPercent'] as num?)?.toDouble() ?? 0.0,
        surahSummaries: (json['surahSummaries'] as List?)
                ?.map((e) => SurahMemorizationSummary.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'overallPercent': overallPercent,
        'surahSummaries': surahSummaries.map((e) => e.toJson()).toList(),
      };
}

class MemorizationTodayItem {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String status;
  final String? lastRecitedAt;
  final int timesRecited;

  MemorizationTodayItem({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.status,
    this.lastRecitedAt,
    this.timesRecited = 0,
  });

  factory MemorizationTodayItem.fromJson(Map<String, dynamic> json) =>
      MemorizationTodayItem(
        surahNumber: (json['surahNumber'] as num?)?.toInt() ?? 0,
        surahName: (json['surahName'] ?? '').toString(),
        ayahNumber: (json['ayahNumber'] as num?)?.toInt() ?? 0,
        status: (json['status'] ?? 'not_started').toString(),
        lastRecitedAt: json['lastRecitedAt']?.toString(),
        timesRecited: (json['timesRecited'] as num?)?.toInt() ?? 0,
      );
}


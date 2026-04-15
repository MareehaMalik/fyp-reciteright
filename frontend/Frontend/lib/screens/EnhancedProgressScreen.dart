import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tajweed_corrector/models/memorization_summary.dart';
import 'package:tajweed_corrector/models/session_models.dart';
import 'package:tajweed_corrector/services/session_service.dart';

class EnhancedProgressScreen extends StatefulWidget {
  const EnhancedProgressScreen({super.key});

  @override
  State<EnhancedProgressScreen> createState() => _EnhancedProgressScreenState();
}

class _EnhancedProgressScreenState extends State<EnhancedProgressScreen> {
  final SessionService _sessionService = SessionService();

  bool isLoading = true;
  String? errorText;

  int thisWeekCount = 0;
  double averageAccuracy = 0;
  int perfectCount = 0;
  double memorizationOverall = 0.0;
  List<SurahMemorizationSummary> topSurahs = const [];

  final Map<String, int> weeklyActivity = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  List<RecentRecitation> recentRecitations = [];

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorText = 'Please sign in to view progress.';
        });
        return;
      }

      WeeklyProgressSummary? progress;
      MemorizationSummary? memorization;
      final loadErrors = <String>[];

      try {
        progress = await _sessionService.getUserProgress(userId: user.uid);
      } catch (e) {
        loadErrors.add('weekly progress');
      }

      try {
        memorization = await _sessionService.getMemorizationSummary(userId: user.uid);
      } catch (e) {
        loadErrors.add('memorization');
      }

      final updatedWeekly = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      };

      for (final d in (progress?.days ?? const <DailyActivity>[])) {
        updatedWeekly[d.day] = d.sessionCount;
      }

      if (!mounted) return;
      setState(() {
        thisWeekCount = progress?.thisWeekCount ?? 0;
        averageAccuracy = progress?.avgAccuracy ?? 0;
        perfectCount = progress?.perfectCount ?? 0;
        weeklyActivity
          ..clear()
          ..addAll(updatedWeekly);
        recentRecitations = progress?.recentRecitations ?? const [];
        memorizationOverall = memorization?.overallPercent ?? 0.0;
        topSurahs = memorization?.surahSummaries ?? const [];
        isLoading = false;
        errorText = loadErrors.isEmpty
            ? null
            : 'Could not load ${loadErrors.join(' & ')}. Pull to refresh.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = 'Failed to load progress.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgressData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorText != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    _buildStatsCard(),
                    const SizedBox(height: 24),
                    _buildWeeklyStatsCard(),
                    const SizedBox(height: 24),

                    _buildMemorizationCard(),
                    const SizedBox(height: 24),

                    const Text(
                      'Recent Recitations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E4976),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (recentRecitations.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.mic_none,
                                size: 64,
                                color: Colors.grey[350],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recitations yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentRecitations.length,
                        itemBuilder: (context, index) {
                          return _buildRecitationCard(recentRecitations[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E4976), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('This Week', thisWeekCount.toString(), Icons.mic),
              _statItem('Avg. Accuracy', '${averageAccuracy.toStringAsFixed(1)}%', Icons.trending_up),
              _statItem('Perfect', perfectCount.toString(), Icons.local_fire_department),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 390;
              final days = [
                {'day': 'Mon', 'value': weeklyActivity['Mon'] ?? 0},
                {'day': 'Tue', 'value': weeklyActivity['Tue'] ?? 0},
                {'day': 'Wed', 'value': weeklyActivity['Wed'] ?? 0},
                {'day': 'Thu', 'value': weeklyActivity['Thu'] ?? 0},
                {'day': 'Fri', 'value': weeklyActivity['Fri'] ?? 0},
                {'day': 'Sat', 'value': weeklyActivity['Sat'] ?? 0},
                {'day': 'Sun', 'value': weeklyActivity['Sun'] ?? 0},
              ];

              return Row(
                children: days.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: compact ? 2 : 3),
                      child: _dayBar(
                        entry['day'] as String,
                        entry['value'] as int,
                        compact: compact,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemorizationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Memorization Progress',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (memorizationOverall / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${memorizationOverall.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (topSurahs.isEmpty)
            const Text(
              'No surah memorization data yet',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            ...topSurahs.take(3).map(_buildTopSurahRow),
        ],
      ),
    );
  }

  Widget _buildTopSurahRow(SurahMemorizationSummary surah) {
    final name = surah.surahName;
    final memorized = surah.memorizedAyahs;
    final totalAyahs = surah.totalAyahs;
    final percent = surah.percentMemorized;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E4976),
              ),
            ),
          ),
          Text(
            '$memorized/$totalAyahs',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(width: 8),
          Text(
            '${percent.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayBar(String day, int value, {bool compact = false}) {
    final hasValue = value > 0;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: compact ? 16 : 18,
          decoration: BoxDecoration(
            color: hasValue ? const Color(0xFF1E4976) : Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: hasValue
              ? Text(
                  '$value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 9 : 10,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        SizedBox(height: compact ? 3 : 4),
        Text(
          day,
          style: TextStyle(
            fontSize: compact ? 10 : 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecitationCard(RecentRecitation recitation) {
    final accuracy = recitation.accuracy;
    final accuracyColor = accuracy >= 95
        ? const Color(0xFF2E7D32)
        : accuracy >= 80
            ? const Color(0xFF4CAF50)
            : const Color(0xFFE65100);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recitation.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4976),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${recitation.mode} - ${recitation.timeAgoDisplay}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accuracyColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accuracyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (accuracy / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1E4976), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E4976),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}


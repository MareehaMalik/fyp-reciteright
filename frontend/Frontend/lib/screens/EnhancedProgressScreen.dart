import 'package:flutter/material.dart';
import 'package:tajweed_corrector/services/recitation_service.dart';

class EnhancedProgressScreen extends StatefulWidget {
  const EnhancedProgressScreen({super.key});

  @override
  State<EnhancedProgressScreen> createState() => _EnhancedProgressScreenState();
}

class _EnhancedProgressScreenState extends State<EnhancedProgressScreen> {
  final RecitationService _recitationService = RecitationService();

  List<RecitationRecord> recitations = [];
  bool isLoading = true;
  int totalCount = 0;
  double averageAccuracy = 0;
  int thisWeekCount = 0;
  int perfectCount = 0;
  Map<String, int> weeklyActivity = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() => isLoading = true);

    try {
      final history = await _recitationService.getRecitationHistory(limit: 50);
      final avgAccuracy = await _recitationService.getAverageAccuracy();
      final totalRecitations = await _recitationService.getTotalRecitationCount();

      // Use real data if available, otherwise use hardcoded sample data
      List<RecitationRecord> displayRecitations = history;
      double displayAvgAccuracy = avgAccuracy;
      int displayTotalCount = totalRecitations;

      if (history.isEmpty) {
        // Hardcoded sample data for demonstration
        displayRecitations = [
          RecitationRecord(
            id: '1',
            lessonId: 'Lesson 1',
            lessonTitle: 'Sukun Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 1)),
            duration: 120,
            accuracy: 92.5,
            notes: 'Good pronunciation',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '2',
            lessonId: 'Lesson 2',
            lessonTitle: 'Tashdeed Characteristics',
            recordedAt: DateTime.now().subtract(const Duration(days: 2)),
            duration: 145,
            accuracy: 88.0,
            notes: 'Needs more practice',
            isPerfect: false,
          ),
          RecitationRecord(
            id: '3',
            lessonId: 'Lesson 3',
            lessonTitle: 'Qalqalah Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 3)),
            duration: 98,
            accuracy: 95.5,
            notes: 'Excellent',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '4',
            lessonId: 'Lesson 4',
            lessonTitle: 'Madd Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 4)),
            duration: 167,
            accuracy: 85.0,
            notes: 'Average performance',
            isPerfect: false,
          ),
          RecitationRecord(
            id: '5',
            lessonId: 'Lesson 5',
            lessonTitle: 'Hamza Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 5)),
            duration: 132,
            accuracy: 91.0,
            notes: 'Very good',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '6',
            lessonId: 'Lesson 1',
            lessonTitle: 'Sukun Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 6)),
            duration: 115,
            accuracy: 87.5,
            notes: 'Good improvement',
            isPerfect: false,
          ),
          RecitationRecord(
            id: '7',
            lessonId: 'Lesson 6',
            lessonTitle: 'Imalah Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 7)),
            duration: 156,
            accuracy: 93.5,
            notes: 'Excellent progress',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '8',
            lessonId: 'Lesson 7',
            lessonTitle: 'Idgham Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 8)),
            duration: 178,
            accuracy: 82.0,
            notes: 'Needs more focus',
            isPerfect: false,
          ),
          RecitationRecord(
            id: '9',
            lessonId: 'Lesson 3',
            lessonTitle: 'Qalqalah Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 9)),
            duration: 102,
            accuracy: 94.0,
            notes: 'Very good',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '10',
            lessonId: 'Lesson 2',
            lessonTitle: 'Tashdeed Characteristics',
            recordedAt: DateTime.now().subtract(const Duration(days: 10)),
            duration: 139,
            accuracy: 89.5,
            notes: 'Good consistency',
            isPerfect: false,
          ),
          RecitationRecord(
            id: '11',
            lessonId: 'Lesson 8',
            lessonTitle: 'Ghunnah Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 11)),
            duration: 125,
            accuracy: 90.5,
            notes: 'Excellent nasal sound',
            isPerfect: true,
          ),
          RecitationRecord(
            id: '12',
            lessonId: 'Lesson 4',
            lessonTitle: 'Madd Rules',
            recordedAt: DateTime.now().subtract(const Duration(days: 12)),
            duration: 171,
            accuracy: 86.5,
            notes: 'Good elongation control',
            isPerfect: false,
          ),
        ];
        displayAvgAccuracy = 90.2;
        displayTotalCount = 87;
      }

      // ✨ Calculate weekly stats from real or sample data
      int weeklyCount = 0;
      int perfectTotal = 0;
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 6));

      // Reset weekly activity map
      weeklyActivity = {
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      };

      for (final rec in displayRecitations) {
        if (rec.recordedAt.isAfter(sevenDaysAgo)) {
          weeklyCount++;
          // Calculate day of week for activity tracking
          final dayOfWeek = rec.recordedAt.weekday; // 1=Monday, 7=Sunday
          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          final dayName = days[dayOfWeek - 1];
          weeklyActivity[dayName] = (weeklyActivity[dayName] ?? 0) + 1;
        }
        if (rec.isPerfect) perfectTotal++;
      }

      thisWeekCount = weeklyCount;
      perfectCount = perfectTotal;

      if (mounted) {
        setState(() {
          recitations = displayRecitations;
          averageAccuracy = displayAvgAccuracy;
          totalCount = displayTotalCount;
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading progress: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading progress: $e')),
        );
      }
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
        shadowColor: const Color(0xFF1E4976).withOpacity(0.3),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProgressData,
              color: const Color(0xFF1E4976),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Overview
                    _buildStatsCard(),
                    const SizedBox(height: 24),

                    // Weekly Stats
                    _buildWeeklyStatsCard(),
                    const SizedBox(height: 24),

                    // Recent Recitations
                    const Text(
                      'Recent Recitations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E4976),
                      ),
                    ),
                  const SizedBox(height: 12),

                  if (recitations.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.mic_none,
                              size: 64,
                              color: Colors.grey[300],
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
                      itemCount: recitations.length,
                      itemBuilder: (context, index) {
                        final recitation = recitations[index];
                        return _buildRecitationCard(recitation);
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
        border: Border.all(
          color: const Color(0xFF1E4976),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              _statItem(
                'This Week',
                thisWeekCount.toString(),
                Icons.mic,
              ),
              _statItem(
                'Avg. Accuracy',
                '${averageAccuracy.toStringAsFixed(1)}%',
                Icons.trending_up,
              ),
              _statItem(
                'Perfect',
                perfectCount.toString(),
                Icons.local_fire_department,
              ),
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
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dayBar('Mon', weeklyActivity['Mon'] ?? 0),
              _dayBar('Tue', weeklyActivity['Tue'] ?? 0),
              _dayBar('Wed', weeklyActivity['Wed'] ?? 0),
              _dayBar('Thu', weeklyActivity['Thu'] ?? 0),
              _dayBar('Fri', weeklyActivity['Fri'] ?? 0),
              _dayBar('Sat', weeklyActivity['Sat'] ?? 0),
              _dayBar('Sun', weeklyActivity['Sun'] ?? 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayBar(String day, int value) {
    final maxValue = 6;
    final heightPercent = (value / maxValue) * 100;

    return Column(
      children: [
        Container(
          width: 30,
          height: (heightPercent / 100) * 80,
          decoration: BoxDecoration(
            color: const Color(0xFF1E4976),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecitationCard(RecitationRecord recitation) {
    final accuracyColor = recitation.accuracy > 85
        ? Colors.green
        : recitation.accuracy > 70
        ? Colors.orange
        : Colors.red;

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
                        'Surah ${recitation.lessonId}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4976),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recitation - ${recitation.recordedAt.difference(DateTime.now()).inDays == 0 ? 'Today' : '${recitation.recordedAt.difference(DateTime.now()).inDays} days ago'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accuracyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${recitation.accuracy.toStringAsFixed(1)}%',
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
                value: recitation.accuracy / 100,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(accuracyColor),
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



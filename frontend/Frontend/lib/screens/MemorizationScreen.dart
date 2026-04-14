import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tajweed_corrector/models/memorization_summary.dart';
import 'package:tajweed_corrector/screens/AyahDisplayScreen.dart';
import 'package:tajweed_corrector/screens/SurahListScreen.dart';
import 'package:tajweed_corrector/services/session_service.dart';

class MemorizationScreen extends StatefulWidget {
  const MemorizationScreen({super.key});

  @override
  State<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends State<MemorizationScreen> {
  final SessionService _sessionService = SessionService();

  bool _loading = true;
  String? _error;
  MemorizationSummary _summary = MemorizationSummary(overallPercent: 0.0);
  List<MemorizationTodayItem> _todayItems = const [];

  @override
  void initState() {
    super.initState();
    _loadMemorization();
  }

  Future<void> _loadMemorization() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _loading = false;
          _error = 'Please sign in to view memorization progress.';
        });
        return;
      }

      final data = await _sessionService.getMemorizationSummary(userId: user.uid);
      final today = await _sessionService.getMemorizationToday(userId: user.uid, limit: 5);
      if (!mounted) return;

      setState(() {
        _summary = data;
        _todayItems = today;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load memorization data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Memorization Progress'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMemorization,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallCard(),
                    const SizedBox(height: 16),
                    ..._buildMainContent(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SurahListScreen(
                                recitationMode: 'memorization',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.menu_book),
                        label: const Text('Practice Surahs'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E4976),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverallCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E4976), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Memorized',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (_summary.overallPercent / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_summary.overallPercent.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMainContent() {
    if (_error != null) {
      return [
        Text(
          _error!,
          style: const TextStyle(color: Colors.red),
        ),
      ];
    }

    if (_todayItems.isNotEmpty) {
      return [
        const Text(
          'Memorize Today',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E4976),
          ),
        ),
        const SizedBox(height: 8),
        ..._todayItems.take(3).map(_buildTodayItem),
        const SizedBox(height: 16),
      ];
    }

    if (_summary.surahSummaries.isEmpty) {
      return [_buildEmpty()];
    }

    return [
      const Text(
        'Top Surahs',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E4976),
        ),
      ),
      const SizedBox(height: 8),
      ..._summary.surahSummaries.map(_buildSurahTile),
    ];
  }

  Widget _buildSurahTile(SurahMemorizationSummary surah) {
    final name = surah.surahName;
    final percent = surah.percentMemorized;
    final memo = surah.memorizedAyahs;
    final total = surah.totalAyahs;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                ),
                Text(
                  '$memo/$total',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF2E7D32)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayItem(MemorizationTodayItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.auto_stories, color: Color(0xFF1E4976)),
        title: Text('${item.surahName} - Ayah ${item.ayahNumber}'),
        subtitle: Text('Status: ${item.status} • Recited ${item.timesRecited}x'),
        trailing: const Icon(Icons.play_circle_fill, color: Color(0xFF1E4976)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AyahDisplayScreen(
                surah: {
                  'number': item.surahNumber,
                  'english': item.surahName,
                  'arabic': '',
                },
                recitationMode: 'memorization',
                initialAyahNumber: item.ayahNumber,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.auto_stories_outlined, size: 56, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'No memorization data yet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Complete recitations with high accuracy to build memorization progress.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}


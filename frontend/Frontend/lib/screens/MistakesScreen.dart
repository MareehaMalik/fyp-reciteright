import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tajweed_corrector/models/session_models.dart';
import 'package:tajweed_corrector/screens/EnhancedReciteScreen.dart';
import 'package:tajweed_corrector/services/session_service.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key});

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  final SessionService _sessionService = SessionService();

  bool _isLoading = true;
  String? _error;
  MistakesSummary _summary = MistakesSummary();

  @override
  void initState() {
    super.initState();
    _loadMistakes();
  }

  Future<void> _loadMistakes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _error = 'Please sign in to view mistakes.';
        });
        return;
      }

      final data = await _sessionService.getMistakes(userId: user.uid, limit: 100);
      if (!mounted) return;
      setState(() {
        _summary = data;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to load mistakes.';
      });
    }
  }

  void _openReview(AyahMistakeSummary item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EnhancedReciteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Review Your Mistakes'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMistakes,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 16),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (_summary.byAyah.isEmpty)
                      _buildEmpty()
                    else
                      ..._summary.byAyah.map(_buildAyahCard),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E4976), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.rule, color: Color(0xFF1E4976), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mistakes Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E4976),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_summary.totalMistakes} mistakes detected from your recent recitations',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 44),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 68, color: Colors.green[400]),
            const SizedBox(height: 12),
            const Text(
              'No mistakes found recently',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Great work. Keep reciting consistently.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahCard(AyahMistakeSummary item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.surahName} - Ayah ${item.ayah}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${item.mistakeCount} mistakes',
                    style: const TextStyle(
                      color: Color(0xFFE65100),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.words.take(4).map((w) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${w.word} x${w.times}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              'Last practiced: ${item.lastPracticedAt.isEmpty ? 'Unknown' : item.lastPracticedAt}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openReview(item),
                icon: const Icon(Icons.replay, size: 18),
                label: const Text('Review This Mistake'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E4976),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


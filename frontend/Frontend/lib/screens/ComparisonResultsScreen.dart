import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tajweed_corrector/data/quran_data.dart';

/// Displays real DTW comparison results between user and Qari recitation
/// Shows: overall score, grade, waveforms, and detailed metrics breakdown
class ComparisonResultsScreen extends StatefulWidget {
  final int surah;
  final int verse;
  final Map<String, dynamic> comparisonResult;
  final String? referenceAudioUrl;
  final String? userAudioPath;

  const ComparisonResultsScreen({
    super.key,
    required this.surah,
    required this.verse,
    required this.comparisonResult,
    this.referenceAudioUrl,
    this.userAudioPath,
  });

  @override
  State<ComparisonResultsScreen> createState() =>
      _ComparisonResultsScreenState();
}

class _ComparisonResultsScreenState extends State<ComparisonResultsScreen> {
  late AudioPlayer _userPlayer;
  late AudioPlayer _qariPlayer;
  bool isPlayingUser = false;
  bool isPlayingQari = false;

  @override
  void initState() {
    super.initState();
    _userPlayer = AudioPlayer();
    _qariPlayer = AudioPlayer();

    // Listen to player state changes
    _userPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() => isPlayingUser = playerState.playing);
      }
    });

    _qariPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() => isPlayingQari = playerState.playing);
      }
    });
  }

  @override
  void dispose() {
    _userPlayer.dispose();
    _qariPlayer.dispose();
    super.dispose();
  }

  /// Get color based on accuracy score
  Color _getScoreColor(double score) {
    if (score >= 90) return const Color(0xFF4CAF50); // Green
    if (score >= 75) return const Color(0xFF2196F3); // Blue
    if (score >= 60) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFF44336); // Red
  }

  /// Get grade based on score
  String _getGrade(double score) {
    if (score >= 95) return "Perfect 🌟";
    if (score >= 90) return "Excellent ✨";
    if (score >= 80) return "Very Good ✓";
    if (score >= 70) return "Good 👍";
    if (score >= 60) return "Satisfactory 📚";
    return "Needs Work 📚";
  }

  /// Play user's recording
  Future<void> _playUserRecording() async {
    try {
      if (_userPlayer.playing) {
        await _userPlayer.stop();
      } else if (widget.userAudioPath != null) {
        await _userPlayer.setFilePath(widget.userAudioPath!);
        await _userPlayer.play();
      }
    } catch (e) {
      _showSnackBar('❌ Could not play recording: $e', Colors.red);
    }
  }

  /// Play Qari's reference recording
  Future<void> _playQariRecording() async {
    try {
      if (_qariPlayer.playing) {
        await _qariPlayer.stop();
      } else if (widget.referenceAudioUrl != null) {
        await _qariPlayer.setUrl(widget.referenceAudioUrl!);
        await _qariPlayer.play();
      }
    } catch (e) {
      _showSnackBar('❌ Could not play Qari audio: $e', Colors.red);
    }
  }

   void _showSnackBar(String message, Color color) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(message),
         backgroundColor: color,
         duration: const Duration(seconds: 2),
       ),
     );
   }

   /// Get Tajweed rule color by name
   Color _getTajweedColor(String ruleName) {
     switch (ruleName) {
       case 'Madd':
         return const Color(0xFF1565C0); // Blue
       case 'Ghunnah':
         return const Color(0xFF2E7D32); // Green
       case 'Qalqalah':
         return const Color(0xFFE65100); // Orange
       case 'Ikhfa':
         return const Color(0xFF6A1B9A); // Purple
       case 'Idgham':
         return const Color(0xFFB71C1C); // Red
       case 'Iqlab':
         return const Color(0xFF880E4F); // Deep Purple
       case 'Izhar':
         return const Color(0xFF00695C); // Teal
       case 'Shadda':
         return const Color(0xFFF57F17); // Amber
       case 'Sukoon':
         return const Color(0xFF37474F); // Blue Grey
       default:
         return Colors.grey;
     }
   }

   /// Show dialog with Tajweed rule explanation
   void _showTajweedDialog(String ruleName, String ruleArabic, String description) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(
               ruleName,
               style: TextStyle(
                 color: _getTajweedColor(ruleName),
                 fontWeight: FontWeight.bold,
                 fontSize: 18,
               ),
             ),
             if (ruleArabic.isNotEmpty)
               Text(
                 ruleArabic,
                 style: GoogleFonts.scheherazadeNew(
                   color: _getTajweedColor(ruleName),
                   fontSize: 16,
                 ),
               ),
           ],
         ),
         content: Text(description),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('OK'),
           ),
         ],
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    final score = (widget.comparisonResult['overall_score'] as num?)?.toDouble() ?? 0.0;
    final grade = _getGrade(score);
    final feedback = widget.comparisonResult['feedback'] as String? ?? 'Good effort!';
    final inferenceTime = (widget.comparisonResult['inference_time_ms'] as num?)?.toDouble() ?? 0.0;

    // Extract metrics breakdown
    final metrics = widget.comparisonResult['metrics'] as Map<String, dynamic>? ?? {};
    final whisperScore = (metrics['whisper_score'] as num?)?.toDouble() ?? 0.0;
    final dtwScore = (metrics['dtw_score'] as num?)?.toDouble() ?? 0.0;
    final mfccScore = (metrics['mfcc_score'] as num?)?.toDouble() ?? 0.0;

    // Extract word results and tajweed summary if available
    final List<dynamic> wordResults = widget.comparisonResult['word_results'] as List? ?? [];
    final tajweedSummary = widget.comparisonResult['tajweed_summary'] as Map<String, dynamic>? ?? {};
    final rulesBreakdown = tajweedSummary['rules_breakdown'] as Map<String, dynamic>? ?? {};

    final surahName = getSurahName(widget.surah);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Comparison Results'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: const Color(0xFF1E4976).withValues(alpha: 0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // SECTION 1: Overall Score Card
            // ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getScoreColor(score),
                    _getScoreColor(score).withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getScoreColor(score).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${score.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    grade,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Surah ${widget.surah} - $surahName, Verse ${widget.verse}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // SECTION 2: Feedback
            // ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feedback,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // SECTION 3: Metrics Breakdown
            // ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Metrics Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Whisper Score (Word Accuracy - 70% weight)
                  _buildMetricRow(
                    'Word Accuracy (Whisper)',
                    whisperScore,
                    '70%',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  // MFCC Score (Audio Features - 30% weight)
                  _buildMetricRow(
                    'Audio Features (MFCC)',
                    mfccScore,
                    '30%',
                    Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  // DTW Score (Dynamic Time Warping)
                  _buildMetricRow(
                    'Dynamic Time Warping (DTW)',
                    dtwScore,
                    'Reference',
                    Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // SECTION 4: Word Results & Tajweed Rules
            // ─────────────────────────────────────────
            if (wordResults.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Word-by-Word Analysis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E4976),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display word results
                    ...wordResults.map((wr) {
                      final word = wr['word'] as String? ?? '';
                      final transcribed = wr['transcribed'] as String? ?? '';
                      final status = wr['status'] as String? ?? 'wrong';
                      final color = wr['color'] as String? ?? 'red';
                      final tajweedRules = wr['tajweed_rules'] as List? ?? [];
                      final phonemes = wr['phonemes'] as List? ?? [];
                      
                      Color statusColor;
                      if (color == 'green') {
                        statusColor = const Color(0xFF4CAF50);
                      } else if (color == 'orange') {
                        statusColor = const Color(0xFFFFC107);
                      } else {
                        statusColor = const Color(0xFFF44336);
                      }
                      
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                              borderRadius: BorderRadius.circular(8),
                              color: statusColor.withValues(alpha: 0.05),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Word with Arabic font
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        word,
                                        style: GoogleFonts.scheherazadeNew(
                                          fontSize: 24,
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (transcribed.isNotEmpty && transcribed != word) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'You said: $transcribed',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                // Phonemes
                                if (phonemes.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Phonemes: ${(phonemes as List).join(' ')}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                // Tajweed rules for this word
                                if (tajweedRules.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: tajweedRules.map((rule) {
                                      final ruleName = rule['rule'] as String? ?? '';
                                      final ruleArabic = rule['arabic'] as String? ?? '';
                                      final ruleColor = rule['color'] as String? ?? '#000000';
                                      final description = rule['description'] as String? ?? '';
                                      final counts = rule['counts'] as int? ?? 0;
                                      
                                      // Parse hex color
                                      Color ruleColorVal = Color(
                                        int.parse('FF${ruleColor.replaceAll('#', '')}', radix: 16),
                                      );
                                      
                                      String fullDesc = description;
                                      if (counts > 0) {
                                        fullDesc += ' (Extend for $counts counts)';
                                      }
                                      
                                      return GestureDetector(
                                        onTap: () {
                                          _showTajweedDialog(ruleName, ruleArabic, fullDesc);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ruleColorVal.withValues(alpha: 0.2),
                                            border: Border.all(
                                              color: ruleColorVal,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                ruleName,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: ruleColorVal,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (ruleArabic.isNotEmpty)
                                                Text(
                                                  ruleArabic,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: ruleColorVal,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),

            if (wordResults.isNotEmpty) const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // SECTION 5: Tajweed Summary
            // ─────────────────────────────────────────
            if (rulesBreakdown.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Tajweed Rules Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E4976),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: rulesBreakdown.entries.map((entry) {
                        final ruleName = entry.key;
                        final count = entry.value as int;
                        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getTajweedColor(ruleName),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$ruleName ($count)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            if (rulesBreakdown.isNotEmpty) const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // SECTION 6: Audio Playback
            // ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎧 Listen to Recordings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Recording
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _playUserRecording,
                      icon: Icon(
                        isPlayingUser ? Icons.pause_circle : Icons.play_circle,
                      ),
                      label: Text(
                        isPlayingUser ? '⏸ Stop Your Recording' : '▶ Play Your Recording',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Qari Recording
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _playQariRecording,
                      icon: Icon(
                        isPlayingQari ? Icons.pause_circle : Icons.play_circle,
                      ),
                      label: Text(
                        isPlayingQari ? '⏸ Stop Qari Recording' : '▶ Play Qari Recording',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

             const SizedBox(height: 24),

             // ─────────────────────────────────────────
             // SECTION 7: Timing Info
             // ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '⏱ Inference Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${inferenceTime.toStringAsFixed(0)}ms',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4976),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E4976),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('← Back to Practice'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Build metric progress row
  Widget _buildMetricRow(
    String label,
    double score,
    String weight,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}% (${weight})',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

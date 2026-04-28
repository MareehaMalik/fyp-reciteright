import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajweed_corrector/models/quiz_models.dart';
import 'package:tajweed_corrector/services/quiz_service.dart';
import 'package:tajweed_corrector/screens/QuizHomeScreen.dart';
import 'package:tajweed_corrector/screens/QuizHistoryScreen.dart';
import 'package:tajweed_corrector/screens/QuizPlayScreen.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizAttempt attempt;
  final String userName;

  const QuizResultScreen({
    Key? key,
    required this.attempt,
    required this.userName,
  }) : super(key: key);

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut),
    );
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final correctCount = widget.attempt.score;
    final wrongCount = widget.attempt.results.where((r) => !r.isCorrect).length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent back button
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score Circle
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildScoreSection(context, correctCount),
              ),

              // Breakdown Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildBreakdownBar(correctCount, wrongCount),
              ),
              const SizedBox(height: 24),

              // Category Performance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCategoryPerformance(),
              ),
              const SizedBox(height: 24),

              // Improvement Guide
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildImprovementGuide(),
              ),
              const SizedBox(height: 24),

              // Question Review
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildQuestionReview(),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildActionButtons(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, int correctCount) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${correctCount}/10',
                    style: GoogleFonts.poppins(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${(correctCount * 10).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.attempt.grade,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed in ${widget.attempt.formattedTime}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(int correctCount, int wrongCount) {
    final skippedCount = widget.attempt.results.where((r) => r.selectedIndex == -1).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Breakdown',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (correctCount > 0)
                Expanded(
                  flex: correctCount,
                  child: Container(color: Colors.green),
                ),
              if (wrongCount > 0)
                Expanded(
                  flex: wrongCount,
                  child: Container(color: Colors.red),
                ),
              if (skippedCount > 0)
                Expanded(
                  flex: skippedCount,
                  child: Container(color: Colors.grey),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBreakdownItem('Correct', correctCount, Colors.green),
            _buildBreakdownItem('Wrong', wrongCount, Colors.red),
            _buildBreakdownItem('Skipped', skippedCount, Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPerformance() {
    final categoryStats = <String, Map<String, int>>{
      'tajweed': {'correct': 0, 'total': 0},
      'islamic': {'correct': 0, 'total': 0},
      'quran': {'correct': 0, 'total': 0},
      'prophets': {'correct': 0, 'total': 0},
    };

    for (final result in widget.attempt.results) {
      final cat = result.category;
      if (categoryStats.containsKey(cat)) {
        categoryStats[cat]!['total'] = categoryStats[cat]!['total']! + 1;
        if (result.isCorrect) {
          categoryStats[cat]!['correct'] = categoryStats[cat]!['correct']! + 1;
        }
      }
    }

    final categoryEmojis = {
      'tajweed': '🎓',
      'islamic': '☪️',
      'quran': '📖',
      'prophets': '🕌',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Performance',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...categoryStats.entries
            .where((e) => e.value['total']! > 0)
            .map((entry) {
          final category = entry.key;
          final correct = entry.value['correct']!;
          final total = entry.value['total']!;
          final percentage = (correct / total * 100).toInt();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${categoryEmojis[category] ?? ''} ${category.replaceFirst(category[0], category[0].toUpperCase())}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$correct/$total',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: correct / total,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      percentage >= 70
                          ? Colors.green
                          : percentage >= 50
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildImprovementGuide() {
    final guide = QuizService.getImprovementGuide(widget.attempt.results);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 How to Improve',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            guide,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Review',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.attempt.results.length,
          itemBuilder: (context, index) {
            return _buildQuestionReviewCard(context, index);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionReviewCard(BuildContext context, int index) {
    final result = widget.attempt.results[index];
    final statusColor = result.isCorrect
        ? Colors.green
        : result.selectedIndex == -1
            ? Colors.grey
            : Colors.red;
    final statusIcon = result.isCorrect
        ? '✓'
        : result.selectedIndex == -1
            ? '⊘'
            : '✗';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _QuestionReviewTile(
        result: result,
        index: index,
        statusIcon: statusIcon,
        statusColor: statusColor,
      ),
    );
  }
}

class _QuestionReviewTile extends StatefulWidget {
  final QuizQuestionResult result;
  final int index;
  final String statusIcon;
  final Color statusColor;

  const _QuestionReviewTile({
    Key? key,
    required this.result,
    required this.index,
    required this.statusIcon,
    required this.statusColor,
  }) : super(key: key);

  @override
  State<_QuestionReviewTile> createState() => _QuestionReviewTileState();
}

class _QuestionReviewTileState extends State<_QuestionReviewTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.statusColor.withValues(alpha: 0.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.statusIcon,
                        style: TextStyle(
                          color: widget.statusColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${widget.index + 1}: ${widget.result.questionText}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppThemes.darkSurfaceLow
                    : AppThemes.lightSurfaceLow,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.result.selectedIndex >= 0) ...[
                    Text(
                      'Your answer:',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.result.selectedIndex < 4
                          ? String.fromCharCode(65 + widget.result.selectedIndex) +
                              '. ' +
                              (widget.result.questionText.isEmpty ? 'N/A' : 'Option')
                          : 'Unknown',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: widget.statusColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    Text(
                      'Your answer: Skipped',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    'Correct answer:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    String.fromCharCode(65 + widget.result.correctIndex) + '. (Option)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Explanation:',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.result.explanation,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Action Buttons
extension QuizResultScreenExt on _QuizResultScreenState {
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizPlayScreen()),
            );
          },
          icon: const Text('🔄'),
          label: const Text('Take Another Quiz'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizHistoryScreen()),
            );
          },
          icon: const Text('📋'),
          label: const Text('View History'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizHomeScreen()),
            );
          },
          icon: const Text('🏠'),
          label: const Text('Back to Home'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}




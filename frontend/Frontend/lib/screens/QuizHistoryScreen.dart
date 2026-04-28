import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajweed_corrector/models/quiz_models.dart';
import 'package:tajweed_corrector/services/quiz_service.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({Key? key}) : super(key: key);

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  late final QuizService _quizService;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _quizService = QuizService();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz History')),
        body: Center(
          child: Text(
            'Please log in to view your quiz history',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<List<QuizAttempt>>(
        stream: _quizService.getQuizHistory(_userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          final quizzes = snapshot.data ?? [];

          if (quizzes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '📖',
                    style: GoogleFonts.poppins(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No quizzes taken yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your first quiz today!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Text('🎯'),
                    label: const Text('Take Your First Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate statistics
          final scores = quizzes.map((q) => q.score.toDouble()).toList();
          final averageScore = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
          final bestScore = scores.isEmpty ? 0 : scores.reduce((a, b) => a > b ? a : b).toInt();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Statistics Header
                _buildStatisticsHeader(context, quizzes.length, averageScore.toInt(), bestScore),

                // Quiz History List
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Quizzes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizzes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _buildQuizHistoryCard(context, quizzes[index], index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsHeader(
    BuildContext context,
    int totalQuizzes,
    int averageScore,
    int bestScore,
  ) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppThemes.darkSurfaceLow
          : AppThemes.lightSurfaceLow,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Statistics',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox(
                context,
                icon: '📊',
                value: totalQuizzes.toString(),
                label: 'Total Quizzes',
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildStatBox(
                context,
                icon: '⭐',
                value: '$averageScore/10',
                label: 'Average Score',
                color: Colors.purple,
              ),
              const SizedBox(width: 12),
              _buildStatBox(
                context,
                icon: '🏆',
                value: '$bestScore/10',
                label: 'Best Score',
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(icon, style: GoogleFonts.poppins(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizHistoryCard(BuildContext context, QuizAttempt quiz, int index) {
    final scoreColor = quiz.score >= 8
        ? Colors.green
        : quiz.score >= 6
            ? Colors.orange
            : Colors.red;

    final correctCount = quiz.results.where((r) => r.isCorrect).length;
    final wrongCount = quiz.results.where((r) => !r.isCorrect && r.selectedIndex != -1).length;
    final skippedCount = quiz.results.where((r) => r.selectedIndex == -1).length;

    return _ExpandableQuizCard(
      quiz: quiz,
      index: index,
      scoreColor: scoreColor,
      correctCount: correctCount,
      wrongCount: wrongCount,
      skippedCount: skippedCount,
    );
  }
}

class _ExpandableQuizCard extends StatefulWidget {
  final QuizAttempt quiz;
  final int index;
  final Color scoreColor;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;

  const _ExpandableQuizCard({
    Key? key,
    required this.quiz,
    required this.index,
    required this.scoreColor,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
  }) : super(key: key);

  @override
  State<_ExpandableQuizCard> createState() => _ExpandableQuizCardState();
}

class _ExpandableQuizCardState extends State<_ExpandableQuizCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppThemes.darkBorderSubtle
              : AppThemes.lightBorderSubtle,
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(widget.quiz.takenAt),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatTime(widget.quiz.takenAt),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.scoreColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${widget.quiz.score}/10',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.scoreColor,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 4,
                            children: [
                              Text(
                                widget.quiz.grade.split('!')[0],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '•',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Text(
                                widget.quiz.formattedTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Mini dots row showing results
                        _buildMiniDotsRow(),
                      ],
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
              child: _buildExpandedContent(),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniDotsRow() {
    return Wrap(
      spacing: 2,
      children: widget.quiz.results.map((result) {
        Color dotColor = result.isCorrect
            ? Colors.green
            : result.selectedIndex == -1
                ? Colors.grey
                : Colors.red;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score breakdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBreakdownColumn('✓', 'Correct', widget.correctCount, Colors.green),
            _buildBreakdownColumn('✗', 'Wrong', widget.wrongCount, Colors.red),
            _buildBreakdownColumn('⊘', 'Skipped', widget.skippedCount, Colors.grey),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 12),
        // Category breakdown
        Text(
          'Category Breakdown',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ..._buildCategoryBreakdown(),
        const SizedBox(height: 12),
        // Question details
        Text(
          'Details',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              children: widget.quiz.results.asMap().entries.map((e) {
                final idx = e.key;
                final result = e.value;
                final icon = result.isCorrect
                    ? '✓'
                    : result.selectedIndex == -1
                        ? '⊘'
                        : '✗';
                final color = result.isCorrect
                    ? Colors.green
                    : result.selectedIndex == -1
                        ? Colors.grey
                        : Colors.red;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          icon,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Q${idx + 1}: ${result.questionText}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownColumn(
    String icon,
    String label,
    int count,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: 16, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryBreakdown() {
    final categoryStats = <String, Map<String, int>>{
      'tajweed': {'correct': 0, 'total': 0},
      'islamic': {'correct': 0, 'total': 0},
      'quran': {'correct': 0, 'total': 0},
      'prophets': {'correct': 0, 'total': 0},
    };

    for (final result in widget.quiz.results) {
      final cat = result.category;
      if (categoryStats.containsKey(cat)) {
        categoryStats[cat]!['total'] = categoryStats[cat]!['total']! + 1;
        if (result.isCorrect) {
          categoryStats[cat]!['correct'] = categoryStats[cat]!['correct']! + 1;
        }
      }
    }

    return categoryStats.entries
        .where((e) => e.value['total']! > 0)
        .map((entry) {
      final category = entry.key;
      final correct = entry.value['correct']!;
      final total = entry.value['total']!;

      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.capitalizeFirst(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '$correct/$total',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


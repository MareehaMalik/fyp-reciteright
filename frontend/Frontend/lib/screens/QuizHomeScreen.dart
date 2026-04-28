import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajweed_corrector/models/quiz_models.dart';
import 'package:tajweed_corrector/services/quiz_service.dart';
import 'package:tajweed_corrector/data/quiz_questions.dart';
import 'package:tajweed_corrector/services/theme_service.dart';
import 'QuizPlayScreen.dart';
import 'QuizHistoryScreen.dart';
import '../widgets/quiz_streak_banner.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({Key? key}) : super(key: key);

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
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
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Text(
            'Please log in to track your quiz progress',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Challenge', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Streak Warning Banner
            QuizStreakBanner(
              userId: _userId,
              userName: FirebaseAuth.instance.currentUser?.displayName ?? 'there',
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Streak Section
                  _buildStreakSection(context),
                  const SizedBox(height: 24),

                  // Stats Row
                  _buildStatsRow(context),
                  const SizedBox(height: 24),

                  // Start Quiz Button
                  _buildStartQuizButton(context),
                  const SizedBox(height: 24),

                  // Category Badges
                  _buildCategoryBadges(context),
                  const SizedBox(height: 24),

                  // Recent Quizzes
                  _buildRecentQuizzes(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(BuildContext context) {
    return FutureBuilder<QuizStreakData?>(
      future: _quizService.getStreakData(_userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildStreakCard(
            context,
            streak: 0,
            isActive: false,
            expiresIn: '',
          );
        }

        final streak = snapshot.data;
        return _buildStreakCard(
          context,
          streak: streak?.currentStreak ?? 0,
          isActive: streak?.isStreakActive ?? false,
          expiresIn: streak?.expiryCountdown ?? '',
        );
      },
    );
  }

  Widget _buildStreakCard(
    BuildContext context, {
    required int streak,
    required bool isActive,
    required String expiresIn,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🔥',
            style: GoogleFonts.poppins(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            streak.toString(),
            style: GoogleFonts.poppins(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Day Streak',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (expiresIn.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Expires in $expiresIn',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Start your streak today!',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _quizService.getUserQuizStats(_userId),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {};
        final totalQuizzes = stats['totalQuizzes'] ?? 0;
        
        return FutureBuilder<QuizStreakData?>(
          future: _quizService.getStreakData(_userId),
          builder: (context, streakSnapshot) {
            final longestStreak = streakSnapshot.data?.longestStreak ?? 0;
            final averageScore = (stats['averageScore'] ?? 0.0).toStringAsFixed(1);
            
            return Row(
              children: [
                _buildStatCard(
                  context,
                  icon: '📊',
                  value: totalQuizzes.toString(),
                  label: 'Quizzes Taken',
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  icon: '🔥',
                  value: longestStreak.toString(),
                  label: 'Longest Streak',
                  color: Colors.amber,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  icon: '⭐',
                  value: '$averageScore/10',
                  label: 'Avg Score',
                  color: Colors.purple,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
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
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartQuizButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizPlayScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  '🎯 Start Quiz',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '10 questions • Mixed topics • ~3 minutes',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadges(BuildContext context) {
    final categories = [
      {'icon': '☪️', 'label': 'Islamic', 'category': 'islamic', 'color': Colors.green},
      {'icon': '📖', 'label': 'Quran', 'category': 'quran', 'color': Colors.purple},
      {'icon': '🕌', 'label': 'Prophets', 'category': 'prophets', 'color': Colors.orange},
      {'icon': '🎓', 'label': 'Tajweed', 'category': 'tajweed', 'color': Colors.teal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz by Category',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: categories.map((cat) {
            return _buildCategoryBadge(
              context,
              icon: cat['icon'] as String,
              label: cat['label'] as String,
              category: cat['category'] as String,
              color: cat['color'] as Color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(
    BuildContext context, {
    required String icon,
    required String label,
    required String category,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final questions = QuizQuestionBank.getRandomQuizFiltered(category, count: 10);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPlayScreen(questions: questions),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: GoogleFonts.poppins(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentQuizzes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Quizzes',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizHistoryScreen(),
                  ),
                );
              },
              child: Text(
                'View All →',
                style: GoogleFonts.poppins(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<QuizAttempt>>(
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
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppThemes.darkSurfaceLow
                      : AppThemes.lightSurfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No quizzes yet. Start your first quiz! 🎯',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: quizzes.take(3).map((quiz) {
                final scoreColor = quiz.score >= 8
                    ? Colors.green
                    : quiz.score >= 6
                        ? Colors.orange
                        : Colors.red;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppThemes.darkSurfaceLow
                        : AppThemes.lightSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppThemes.darkBorderSubtle
                          : AppThemes.lightBorderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Date
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(quiz.takenAt),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatTime(quiz.takenAt),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Score badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: scoreColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${quiz.score}/10',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Grade
                      Text(
                        quiz.grade.split('!')[0],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Time
                      Text(
                        quiz.formattedTime,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
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


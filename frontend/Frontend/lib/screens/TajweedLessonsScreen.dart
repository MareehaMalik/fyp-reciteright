import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quran_data.dart' show lessons;
import '../models/tajweed_lesson.dart';
import './LessonDetailScreen.dart';

class TajweedLessonsScreen extends StatefulWidget {
  const TajweedLessonsScreen({super.key});

  @override
  State<TajweedLessonsScreen> createState() => _TajweedLessonsScreenState();
}

class _TajweedLessonsScreenState extends State<TajweedLessonsScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences? _prefs;
  bool _isPrefsReady = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _isPrefsReady = true;
    });
  }

  bool _isLessonCompleted(String lessonId) {
    return _prefs?.getBool('lesson_${lessonId}_completed') ?? false;
  }

  int _getLessonScore(String lessonId) {
    return _prefs?.getInt('lesson_${lessonId}_score') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tajweedLessons = lessons.where((l) => l.category == 'tajweed').toList();
    final islamicLessons = lessons.where((l) => l.category == 'islamic').toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101418) : const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Lessons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const <Tab>[
            Tab(text: '📖 Tajweed'),
            Tab(text: '🕌 Islamic'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildCategoryTab(
            context,
            title: 'Your Tajweed Journey',
            subtitle: 'Master pronunciation and recitation rules.',
            displayLessons: tajweedLessons,
            accent: const Color(0xFF1976D2),
            emoji: '📖',
          ),
          _buildCategoryTab(
            context,
            title: 'Your Islamic Knowledge',
            subtitle: 'Build strong foundations in belief and worship.',
            displayLessons: islamicLessons,
            accent: Colors.teal,
            emoji: '🕌',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<TajweedLesson> displayLessons,
    required Color accent,
    required String emoji,
  }) {
    final theme = Theme.of(context);
    final completedForCategory = displayLessons
        .where((l) => _isLessonCompleted(l.id))
        .length;

    return RefreshIndicator(
      onRefresh: _loadProgress,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[theme.primaryColor, accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$completedForCategory of ${displayLessons.length} lessons completed',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: displayLessons.isEmpty
                        ? 0
                        : completedForCategory / displayLessons.length,
                    minHeight: 8,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!_isPrefsReady)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          ...displayLessons.map((lesson) {
            final isCompleted = _isLessonCompleted(lesson.id);
            final score = _getLessonScore(lesson.id);
            return _LessonCard(
              lesson: lesson,
              isCompleted: isCompleted,
              score: score,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonDetailScreen(lesson: lesson),
                  ),
                );
                await _loadProgress();
              },
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final TajweedLesson lesson;
  final bool isCompleted;
  final int score;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.isCompleted,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: <Color>[
              lesson.color.withValues(alpha: isDark ? 0.35 : 0.15),
              lesson.color.withValues(alpha: isDark ? 0.18 : 0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: lesson.color.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: lesson.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(lesson.icon, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lesson.arabicTitle,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: lesson.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: lesson.color.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.schedule_rounded,
                              size: 12,
                              color: lesson.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lesson.duration,
                              style: TextStyle(
                                color: lesson.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                    ],
                  ),
                  if (isCompleted) ...<Widget>[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: score / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.withValues(alpha: 0.25),
                        valueColor: AlwaysStoppedAnimation<Color>(lesson.color),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: lesson.color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

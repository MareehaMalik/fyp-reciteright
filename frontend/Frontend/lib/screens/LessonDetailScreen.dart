import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../models/tajweed_lesson.dart';
import '../services/quran_lesson_service.dart';
import '../widgets/word_by_word_widget.dart';
import './LessonQuizScreen.dart';

class LessonDetailScreen extends StatefulWidget {
  final TajweedLesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AudioPlayer _audioPlayer;

  final QuranLessonService _service = QuranLessonService();
  final Map<int, bool> _loadingAudioBySection = <int, bool>{};
  final Map<int, bool> _loadingWordsBySection = <int, bool>{};
  final Map<int, List<QuranWord>> _wordsBySection = <int, List<QuranWord>>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSectionWords(int index) async {
    final section = widget.lesson.sections[index];
    if (!section.showWordByWord || _wordsBySection.containsKey(index)) {
      return;
    }

    setState(() => _loadingWordsBySection[index] = true);
    try {
      final words = await _service.fetchWordByWord(
        section.exampleSurah,
        section.exampleAyah,
      );
      if (!mounted) return;
      setState(() {
        _wordsBySection[index] = words;
        _loadingWordsBySection[index] = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingWordsBySection[index] = false);
    }
  }

  Future<void> _playAyahForSection(int index) async {
    final section = widget.lesson.sections[index];
    final audioUrl = _service.getAyahAudioUrl(
      section.exampleSurah,
      section.exampleAyah,
    );

    try {
      setState(() => _loadingAudioBySection[index] = true);
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      if (!mounted) return;
      setState(() => _loadingAudioBySection[index] = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingAudioBySection[index] = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to play audio: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101418) : const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  widget.lesson.color,
                  widget.lesson.color.withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.lesson.icon, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.lesson.arabicTitle,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.lesson.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: theme.cardColor,
            child: TabBar(
              controller: _tabController,
              labelColor: widget.lesson.color,
              unselectedLabelColor: theme.textTheme.bodySmall?.color,
              indicatorColor: widget.lesson.color,
              tabs: const <Tab>[
                Tab(text: '📖 Learn'),
                Tab(text: '✏️ Practice'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildLearnTab(context),
                LessonQuizScreen(lesson: widget.lesson),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: widget.lesson.sections.length,
      itemBuilder: (BuildContext context, int index) {
        final section = widget.lesson.sections[index];
        return _buildSectionTile(context, section, index);
      },
    );
  }

  Widget _buildSectionTile(BuildContext context, LessonSection section, int index) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: widget.lesson.color, width: 6),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: TextStyle(
            color: widget.lesson.color,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Example: ${section.exampleSurah}:${section.exampleAyah}',
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        onExpansionChanged: (bool expanded) {
          if (expanded) {
            _loadSectionWords(index);
          }
        },
        childrenPadding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              section.explanation,
              style: TextStyle(
                fontSize: 14,
                height: 1.65,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.lesson.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.lesson.color.withValues(alpha: 0.45)),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  section.arabicExample,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: widget.lesson.color,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildHowToLearnCard(section.howToLearn),
          const SizedBox(height: 10),
          _buildCommonMistakeCard(section.commonMistake),
          const SizedBox(height: 10),
          _buildTipCard(section.tip),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _loadingAudioBySection[index] == true
                  ? null
                  : () => _playAyahForSection(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.lesson.color,
                foregroundColor: Colors.white,
              ),
              icon: _loadingAudioBySection[index] == true
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.play_arrow_rounded),
              label: Text(
                _loadingAudioBySection[index] == true ? 'Loading...' : 'Listen Example',
              ),
            ),
          ),
          if (section.showWordByWord) ...<Widget>[
            const SizedBox(height: 12),
            if (_loadingWordsBySection[index] == true)
              const Center(child: CircularProgressIndicator())
            else if ((_wordsBySection[index] ?? <QuranWord>[]).isNotEmpty)
              WordByWordWidget(words: _wordsBySection[index]!)
            else
              Text(
                'Word-by-word data unavailable for this example.',
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildHowToLearnCard(String howToLearn) {
    final theme = Theme.of(context);
    final lines = howToLearn
        .split('\n')
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'How to Learn',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...List<Widget>.generate(lines.length, (int i) {
            final normalized = lines[i].replaceFirst(RegExp(r'^\d+[\.)]?\s*'), '');
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text('${i + 1}. $normalized', style: const TextStyle(height: 1.55)),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommonMistakeCard(String commonMistake) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Common Mistake',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(commonMistake, style: const TextStyle(height: 1.55)),
        ],
      ),
    );
  }

  Widget _buildTipCard(String tip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Tip',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(tip, style: const TextStyle(height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


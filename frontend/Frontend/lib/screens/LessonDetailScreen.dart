import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../models/tajweed_lesson.dart';
import '../services/quran_lesson_service.dart';
import '../widgets/word_by_word_widget.dart';
import './LessonQuizScreen.dart';

class LessonDetailScreen extends StatefulWidget {
  final TajweedLesson lesson;

  const LessonDetailScreen({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentSectionIndex = 0;
  late AudioPlayer _audioPlayer;
  bool _isLoadingAudio = false;
  List<QuranWord> _currentWords = [];
  bool _isLoadingWords = false;

  final QuranLessonService _service = QuranLessonService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _audioPlayer = AudioPlayer();
    _loadCurrentSectionWords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentSectionWords() async {
    if (_currentSectionIndex < widget.lesson.sections.length) {
      final section = widget.lesson.sections[_currentSectionIndex];
      if (section.showWordByWord) {
        setState(() => _isLoadingWords = true);
        try {
          final words = await _service.fetchWordByWord(
            section.exampleSurah,
            section.exampleAyah,
          );
          setState(() {
            _currentWords = words;
            _isLoadingWords = false;
          });
        } catch (e) {
          setState(() => _isLoadingWords = false);
        }
      }
    }
  }

  Future<void> _playAyah() async {
    final section = widget.lesson.sections[_currentSectionIndex];
    final audioUrl = _service.getAyahAudioUrl(
      section.exampleSurah,
      section.exampleAyah,
    );

    try {
      setState(() => _isLoadingAudio = true);
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      if (mounted) {
        setState(() => _isLoadingAudio = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAudio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  void _nextSection() {
    if (_currentSectionIndex < widget.lesson.sections.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToQuiz() {
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: widget.lesson.color,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Hero header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.lesson.color, widget.lesson.color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      widget.lesson.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.lesson.arabicTitle,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 28,
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
          // TabBar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: widget.lesson.color,
              unselectedLabelColor: Colors.grey,
              indicatorColor: widget.lesson.color,
              tabs: const [
                Tab(text: '📖 Learn'),
                Tab(text: '✏️ Practice'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Learn tab
                _buildLearnTab(),
                // Practice tab
                LessonQuizScreen(lesson: widget.lesson),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnTab() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentSectionIndex = index;
        });
        _loadCurrentSectionWords();
      },
      children: List.generate(widget.lesson.sections.length, (index) {
        final section = widget.lesson.sections[index];
        return _buildSectionPage(section);
      }),
    );
  }

  Widget _buildSectionPage(LessonSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            section.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.lesson.color,
            ),
          ),
          const SizedBox(height: 16),
          // Explanation
          Text(
            section.explanation,
            style: const TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // Arabic example box
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.lesson.color.withValues(alpha: 0.1),
              border: Border.all(
                color: widget.lesson.color,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  section.arabicExample,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: widget.lesson.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  section.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Audio player button
          Center(
            child: ElevatedButton.icon(
              onPressed: _isLoadingAudio ? null : _playAyah,
              icon: _isLoadingAudio
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isLoadingAudio ? 'Loading...' : 'Play Ayah Audio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.lesson.color,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Word by word widget
          if (section.showWordByWord)
            _isLoadingWords
                ? const Center(child: CircularProgressIndicator())
                : _currentWords.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Word by Word',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.lesson.color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          WordByWordWidget(words: _currentWords),
                        ],
                      )
                    : const SizedBox.shrink(),
          const SizedBox(height: 20),
          // Tip card
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              border: Border.all(
                color: Colors.yellow[700]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tip',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        section.tip,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _currentSectionIndex > 0
                      ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _currentSectionIndex < widget.lesson.sections.length - 1
                    ? ElevatedButton.icon(
                        onPressed: _nextSection,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.lesson.color,
                          foregroundColor: Colors.white,
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _goToQuiz,
                        icon: const Icon(Icons.quiz),
                        label: const Text('Go to Quiz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Page indicator dots
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.lesson.sections.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentSectionIndex
                        ? widget.lesson.color
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


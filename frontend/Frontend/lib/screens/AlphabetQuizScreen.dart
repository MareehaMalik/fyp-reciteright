import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tajweed_corrector/data/arabic_letters.dart';
import 'package:tajweed_corrector/models/arabic_letter.dart';
import 'package:tajweed_corrector/services/alphabet_service.dart';
import 'package:tajweed_corrector/services/tajweed_tts_service.dart';
import 'package:tajweed_corrector/arabic_alphabet_player.dart';

enum AlphabetQuizType { soundToLetter, nameToLetter }

class AlphabetQuizScreen extends StatefulWidget {
  final ArabicLetter? focusLetter;

  const AlphabetQuizScreen({super.key, this.focusLetter});

  @override
  State<AlphabetQuizScreen> createState() => _AlphabetQuizScreenState();
}

class _AlphabetQuizScreenState extends State<AlphabetQuizScreen> {
  final AlphabetService _alphabetService = AlphabetService();
  final ArabicLetterAudioPlayer _audioPlayer = ArabicLetterAudioPlayer();
  final Random _random = Random();

  late List<_AlphabetQuizQuestion> _questions;
  int _currentIndex = 0;
  String? _selectedId;
  bool? _isCorrect;
  int _correctAnswers = 0;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
    _playPromptAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  List<_AlphabetQuizQuestion> _buildQuestions() {
    final letters = List<ArabicLetter>.from(arabicLetters);
    final focusLetter = widget.focusLetter;

    int questionCount = focusLetter == null ? 8 : 5;
    final questions = <_AlphabetQuizQuestion>[];

    for (int i = 0; i < questionCount; i++) {
      final correct = focusLetter ?? letters[_random.nextInt(letters.length)];
      final options = _buildOptions(correct, letters);
      final type = _random.nextBool()
          ? AlphabetQuizType.soundToLetter
          : AlphabetQuizType.nameToLetter;

      questions.add(_AlphabetQuizQuestion(
        type: type,
        correct: correct,
        options: options,
      ));
    }

    return questions;
  }

  List<ArabicLetter> _buildOptions(ArabicLetter correct, List<ArabicLetter> all) {
    final options = <ArabicLetter>{correct};
    while (options.length < 4) {
      options.add(all[_random.nextInt(all.length)]);
    }
    return options.toList()..shuffle();
  }

  Future<void> _playPromptAudio() async {
    final question = _questions[_currentIndex];
    if (question.type != AlphabetQuizType.soundToLetter) return;
    if (_isPlayingAudio) return;

    setState(() => _isPlayingAudio = true);
    final audioMeta = _audioPlayer.getLetterByGlyph(question.correct.glyph);
    if (audioMeta != null) {
      await _audioPlayer.playLetterPrimary(audioMeta);
    } else {
      await TajweedTTSService.speak(question.correct.glyph);
    }
    if (!mounted) return;
    setState(() => _isPlayingAudio = false);
  }

  Future<void> _handleAnswer(ArabicLetter letter) async {
    if (_isCorrect != null) return;

    final question = _questions[_currentIndex];
    final isCorrect = letter.id == question.correct.id;

    setState(() {
      _selectedId = letter.id;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _correctAnswers += 1;
      }
    });

    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.vibrate();
    }
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex == _questions.length - 1) {
      if (widget.focusLetter != null) {
        await _alphabetService.recordQuizResult(
          widget.focusLetter!.id,
          _scorePercent(),
          totalQuestions: _questions.length,
          correctAnswers: _correctAnswers,
        );
      }
      _showResults();
      return;
    }

    setState(() {
      _currentIndex += 1;
      _selectedId = null;
      _isCorrect = null;
    });

    _playPromptAudio();
  }

  int _scorePercent() {
    if (_questions.isEmpty) return 0;
    return ((_correctAnswers / _questions.length) * 100).round();
  }

  void _showResults() {
    final score = _scorePercent();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete'),
        content: Text('Score: $score%'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final promptText = question.type == AlphabetQuizType.soundToLetter
        ? 'Which letter is this sound?'
        : 'Tap the letter "${question.correct.name}"';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Alphabet Quiz'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E4976)),
            ),
            const SizedBox(height: 16),
            Text(
              promptText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (question.type == AlphabetQuizType.soundToLetter)
              TextButton.icon(
                onPressed: _playPromptAudio,
                icon: Icon(_isPlayingAudio ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlayingAudio ? 'Playing...' : 'Play sound'),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  question.correct.glyph,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 42, color: Color(0xFF1E4976)),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: question.options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _selectedId == option.id;
                  final isCorrect = _isCorrect == true && option.id == question.correct.id;
                  final isWrong = _isCorrect == false && isSelected;

                  Color borderColor = Colors.grey[300]!;
                  Color? fillColor;
                  if (isCorrect) {
                    borderColor = const Color(0xFF4CAF50);
                    fillColor = const Color(0xFFE8F5E9);
                  } else if (isWrong) {
                    borderColor = const Color(0xFFE53935);
                    fillColor = const Color(0xFFFFEBEE);
                  }

                  return GestureDetector(
                    onTap: () => _handleAnswer(option),
                    child: Container(
                      decoration: BoxDecoration(
                        color: fillColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          option.glyph,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E4976),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isCorrect == null ? null : _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E4976),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentIndex == _questions.length - 1 ? 'Finish' : 'Next',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AlphabetQuizQuestion {
  final AlphabetQuizType type;
  final ArabicLetter correct;
  final List<ArabicLetter> options;

  _AlphabetQuizQuestion({
    required this.type,
    required this.correct,
    required this.options,
  });
}

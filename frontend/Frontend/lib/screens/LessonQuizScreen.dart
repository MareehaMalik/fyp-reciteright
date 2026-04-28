import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tajweed_lesson.dart';

class LessonQuizScreen extends StatefulWidget {
  final TajweedLesson lesson;

  const LessonQuizScreen({super.key, required this.lesson});

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOption;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _selectOption(int index) {
    if (_answered) return;

    setState(() {
      _selectedOption = index;
      _answered = true;
    });

    final question = widget.lesson.questions[_currentQuestionIndex];
    if (index == question.correctIndex) {
      setState(() => _score++);
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.lesson.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedOption = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final percentage = ((_score / widget.lesson.questions.length) * 100).toInt();
    final passed = percentage >= 60;

    if (passed) {
      _saveProgress(percentage);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildResultsDialog(percentage, passed),
    );
  }

  Future<void> _saveProgress(int score) async {
    await _prefs.setBool('lesson_${widget.lesson.id}_completed', true);
    await _prefs.setInt('lesson_${widget.lesson.id}_score', score);
    final total = _prefs.getInt('total_lessons_completed') ?? 0;
    await _prefs.setInt('total_lessons_completed', total + 1);
  }

  void _retakeQuiz() {
    Navigator.pop(context);
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _answered = false;
      _selectedOption = null;
    });
  }

  Widget _buildResultsDialog(int percentage, bool passed) {
    String message;
    int starCount;

    if (percentage >= 80) {
      message = '🌟 Excellent!';
      starCount = 3;
    } else if (percentage >= 60) {
      message = '👍 Good!';
      starCount = 2;
    } else {
      message = '📖 Review!';
      starCount = 1;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: passed ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_score of ${widget.lesson.questions.length} correct',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Opacity(
                  opacity: index < starCount ? 1.0 : 0.2,
                  child: const Text(
                    '⭐',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (passed)
            Text(
              'Lesson Complete! Score saved.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          else
            Text(
              'Score 60% or higher to pass.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _retakeQuiz,
          child: const Text('Retake Quiz'),
        ),
        if (passed)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Next Lesson →'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.questions.isEmpty) {
      return Center(
        child: Text(
          'No questions available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final question = widget.lesson.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex / widget.lesson.questions.length);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_score / ${widget.lesson.questions.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.lesson.color,
                ),
              ),
              Text(
                '${_currentQuestionIndex + 1} / ${widget.lesson.questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(widget.lesson.color),
            ),
          ),
          const SizedBox(height: 24),
          // Question card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question number chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.lesson.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.lesson.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Question text
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Arabic text if present
                  if (question.arabicText != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        question.arabicText!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: widget.lesson.color,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Options
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isSelected = _selectedOption == index;
                    final isCorrect = index == question.correctIndex;
                    final isWrong = isSelected && index != question.correctIndex;

                    Color backgroundColor = Colors.white;
                    Color borderColor = Colors.grey[300]!;
                    Color textColor = Colors.black87;
                    IconData? icon;

                    if (_answered) {
                      if (isCorrect) {
                        backgroundColor = Colors.green;
                        borderColor = Colors.green;
                        textColor = Colors.white;
                        icon = Icons.check;
                      } else if (isWrong) {
                        backgroundColor = Colors.red;
                        borderColor = Colors.red;
                        textColor = Colors.white;
                        icon = Icons.close;
                      }
                    } else if (isSelected) {
                      backgroundColor = widget.lesson.color.withValues(alpha: 0.1);
                      borderColor = widget.lesson.color;
                    }

                    return GestureDetector(
                      onTap: () => _selectOption(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Option letter
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCorrect && _answered
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : widget.lesson.color.withValues(alpha: 0.2),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor == Colors.white
                                        ? Colors.white
                                        : widget.lesson.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                            if (icon != null)
                              Icon(icon, color: textColor, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Explanation (shown after answering)
                  if (_answered)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(
                          color: Colors.blue[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explanation',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.explanation,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[900],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Next button
                  if (_answered)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _nextQuestion,
                        icon: Icon(_currentQuestionIndex <
                                widget.lesson.questions.length - 1
                            ? Icons.arrow_forward
                            : Icons.check),
                        label: Text(
                          _currentQuestionIndex <
                                  widget.lesson.questions.length - 1
                              ? 'Next Question →'
                              : 'Finish Quiz ✓',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.lesson.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


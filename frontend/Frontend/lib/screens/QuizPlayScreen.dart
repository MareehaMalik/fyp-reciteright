import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:tajweed_corrector/models/quiz_models.dart';
import 'package:tajweed_corrector/data/quiz_questions.dart';
import 'package:tajweed_corrector/services/quiz_service.dart';
import 'package:tajweed_corrector/screens/QuizResultScreen.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

class QuizPlayScreen extends StatefulWidget {
  final List<QuizQuestion>? questions;
  final String? filterCategory;

  const QuizPlayScreen({
    Key? key,
    this.questions,
    this.filterCategory,
  }) : super(key: key);

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> questions;
  late List<QuizQuestionResult> results;
  late DateTime startTime;
  late Timer questionTimer;
  late AnimationController scaleController;
  late AnimationController shakeController;

  int currentIndex = 0;
  int? selectedOptionIndex;
  int timeRemaining = 30;
  bool showExplanation = false;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _initializeQuiz() {
    if (widget.questions != null) {
      questions = widget.questions!;
    } else if (widget.filterCategory != null) {
      questions = QuizQuestionBank.getRandomQuizFiltered(
        widget.filterCategory!,
        count: 10,
      );
    } else {
      questions = QuizQuestionBank.getRandomQuiz();
    }

    results = [];
    startTime = DateTime.now();
    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    timeRemaining = 30;
    questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        timeRemaining--;
      });

      if (timeRemaining <= 0) {
        timer.cancel();
        if (!isAnswered) {
          _skipQuestion();
        }
      }
    });
  }

  void _selectOption(int index) {
    if (isAnswered) return;

    setState(() {
      selectedOptionIndex = index;
    });

    final question = questions[currentIndex];
    final isCorrect = index == question.correctIndex;

    if (isCorrect) {
      scaleController.forward().then((_) {
        scaleController.reverse();
      });
    } else {
      shakeController.forward().then((_) {
        shakeController.reverse();
      });
    }

    setState(() {
      isAnswered = true;
      showExplanation = true;
    });

    results.add(
      QuizQuestionResult(
        questionId: question.id,
        questionText: question.question,
        selectedIndex: index,
        correctIndex: question.correctIndex,
        isCorrect: isCorrect,
        explanation: question.explanation,
        category: question.category,
      ),
    );

    questionTimer.cancel();
  }

  void _skipQuestion() {
    final question = questions[currentIndex];
    setState(() {
      selectedOptionIndex = -1;
      isAnswered = true;
      showExplanation = true;
    });

    results.add(
      QuizQuestionResult(
        questionId: question.id,
        questionText: question.question,
        selectedIndex: -1,
        correctIndex: question.correctIndex,
        isCorrect: false,
        explanation: question.explanation,
        category: question.category,
      ),
    );

    questionTimer.cancel();
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOptionIndex = null;
        isAnswered = false;
        showExplanation = false;
      });
      _startQuestionTimer();
    }
  }

  Future<void> _finishQuiz() async {
    questionTimer.cancel();

    // Calculate scores
    final correctCount = results.where((r) => r.isCorrect).length;
    final grade = QuizService.getGrade(correctCount);
    final timeTaken = DateTime.now().difference(startTime).inSeconds;

    // Create attempt
    final attempt = QuizAttempt(
      id: const Uuid().v4(),
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      takenAt: DateTime.now(),
      score: correctCount,
      totalQuestions: questions.length,
      timeTakenSeconds: timeTaken,
      results: results,
      grade: grade,
    );

    // Save to Firestore
    try {
      await QuizService().saveQuizAttempt(
        FirebaseAuth.instance.currentUser?.uid ?? '',
        attempt,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              attempt: attempt,
              userName: FirebaseAuth.instance.currentUser?.displayName ?? 'User',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    questionTimer.cancel();
    scaleController.dispose();
    shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];
    final progressValue = (currentIndex + 1) / questions.length;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          questionTimer.cancel();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
            ),

            // Header Row
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppThemes.darkSurfaceLow
                  : AppThemes.lightSurfaceLow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentIndex + 1}/${questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildCategoryChip(question.category),
                  _buildTimerBadge(),
                ],
              ),
            ),

            // Question and Options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Arabic Text if exists
                    if (question.arabicText != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Text(
                          question.arabicText!,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.scheherazadeNew(
                            fontSize: 26,
                            color: Theme.of(context).primaryColor,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Question Text
                    Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Text(
                        question.question,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        return _buildOptionCard(
                          index,
                          question.options[index],
                          question.correctIndex,
                          index == selectedOptionIndex,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Explanation (shown after answer)
                    if (showExplanation)
                      _buildExplanationCard(question.explanation),

                    const SizedBox(height: 16),

                    // Skip button
                    if (!isAnswered)
                      TextButton(
                        onPressed: _skipQuestion,
                        child: Text(
                          'Skip Question',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    // Next/Finish button
                    if (isAnswered) ...[
                      ElevatedButton(
                        onPressed: currentIndex == questions.length - 1
                            ? _finishQuiz
                            : _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentIndex == questions.length - 1
                              ? 'Finish Quiz 🏁'
                              : 'Next Question →',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final colors = {
      'tajweed': Colors.teal,
      'islamic': Colors.green,
      'quran': Colors.purple,
      'prophets': Colors.orange,
    };

    final emojis = {
      'tajweed': '🎓',
      'islamic': '☪️',
      'quran': '📖',
      'prophets': '🕌',
    };

    final color = colors[category] ?? Colors.blue;
    final emoji = emojis[category] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$emoji ${category.capitalizeFirst()}',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimerBadge() {
    final timerColor = timeRemaining <= 5 ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timerColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        '⏱️ ${timeRemaining}s',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: timerColor,
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    int index,
    String text,
    int correctIndex,
    bool isSelected,
  ) {
    final isCorrect = index == correctIndex;
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppThemes.darkBorderSubtle
        : AppThemes.lightBorderSubtle;
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? AppThemes.darkSurfaceLow
        : AppThemes.lightSurfaceLow;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
      } else if (isSelected) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withValues(alpha: 0.1);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => _selectOption(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              children: [
                // Letter badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Option text
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Checkmark or X
                if (isAnswered)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: isCorrect
                        ? const Text('✓', style: TextStyle(color: Colors.green, fontSize: 20))
                        : isSelected
                            ? const Text('✗', style: TextStyle(color: Colors.red, fontSize: 20))
                            : const SizedBox(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String explanation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Explanation',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}



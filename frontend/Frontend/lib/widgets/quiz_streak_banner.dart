import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:tajweed_corrector/services/quiz_service.dart';
import 'package:tajweed_corrector/screens/QuizHomeScreen.dart';

class QuizStreakBanner extends StatefulWidget {
  final String userId;
  final String userName;

  const QuizStreakBanner({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<QuizStreakBanner> createState() => _QuizStreakBannerState();
}

class _QuizStreakBannerState extends State<QuizStreakBanner>
    with TickerProviderStateMixin {
  late final QuizService _quizService;
  late Timer refreshTimer;
  late AnimationController pulseController;
  bool showWarning = false;
  String expiresIn = '';

  @override
  void initState() {
    super.initState();
    _quizService = QuizService();

    pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _checkWarning();

    // Refresh every 60 seconds
    refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) {
        _checkWarning();
      }
    });
  }

  void _checkWarning() async {
    final shouldShow = await _quizService.shouldShowStreakWarning(widget.userId);
    final streakData = await _quizService.getStreakData(widget.userId);

    if (mounted) {
      setState(() {
        showWarning = shouldShow;
        expiresIn = streakData?.expiryCountdown ?? '';
      });
    }
  }

  @override
  void dispose() {
    refreshTimer.cancel();
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!showWarning) {
      return SizedBox.shrink();
    }

    final countdownParts = expiresIn.split('h');
    final hours = int.tryParse(countdownParts.first.trim()) ?? 0;
    final minutes = countdownParts.length > 1
        ? (int.tryParse(countdownParts[1].split('m').first.trim()) ?? 0)
        : 0;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.9, end: 1.0).animate(pulseController),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.red.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizHomeScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '🔥',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚠️ Hey ${widget.userName}! Your quiz streak is about to end!',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Only ${hours}h ${minutes}m left — take a quiz now! 🏃',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


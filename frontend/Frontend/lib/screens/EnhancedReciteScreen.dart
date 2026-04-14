import 'package:flutter/material.dart';
import 'SurahListScreen.dart';

const Color PRIMARY_COLOR = Color(0xFF1E4976);

class EnhancedReciteScreen extends StatefulWidget {
  final String recitationMode;
  final int? initialAyahNumber;

  const EnhancedReciteScreen({
    super.key,
    this.recitationMode = 'practice',
    this.initialAyahNumber,
  });

  @override
  State<EnhancedReciteScreen> createState() => _EnhancedReciteScreenState();
}

class _EnhancedReciteScreenState extends State<EnhancedReciteScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to SurahListScreen immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SurahListScreen(
            recitationMode: widget.recitationMode,
            initialAyahNumber: widget.initialAyahNumber,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(PRIMARY_COLOR),
            ),
            const SizedBox(height: 16),
            const Text('Loading Quran...'),
          ],
        ),
      ),
    );
  }
}



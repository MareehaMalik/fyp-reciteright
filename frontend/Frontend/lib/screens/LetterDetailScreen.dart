import 'package:flutter/material.dart';
import 'package:tajweed_corrector/models/arabic_letter.dart';
import 'package:tajweed_corrector/screens/AlphabetQuizScreen.dart';
import 'package:tajweed_corrector/services/alphabet_service.dart';
import 'package:tajweed_corrector/services/tajweed_tts_service.dart';
import 'package:tajweed_corrector/arabic_alphabet_player.dart';

class LetterDetailScreen extends StatefulWidget {
  final ArabicLetter letter;

  const LetterDetailScreen({super.key, required this.letter});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  final AlphabetService _alphabetService = AlphabetService();
  final ArabicLetterAudioPlayer _audioPlayer = ArabicLetterAudioPlayer();
  ArabicLetterProgress _progress = ArabicLetterProgress.empty();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final progress = await _alphabetService.getLetterProgress(widget.letter.id);
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  Future<void> _playLetterAudio() async {
    await _alphabetService.markLetterPracticed(widget.letter.id);
    final audioMeta = _audioPlayer.getLetterByGlyph(widget.letter.glyph);
    if (audioMeta != null) {
      await _audioPlayer.playLetterPrimary(audioMeta);
    } else {
      // Keep a graceful fallback while mappings evolve.
      await TajweedTTSService.speak(widget.letter.glyph);
    }
    _loadProgress();
  }

  Future<void> _playExampleAudio() async {
    if (widget.letter.exampleSyllables.isEmpty) return;
    await TajweedTTSService.speak(widget.letter.exampleSyllables.join(' '));
  }

  Future<void> _startListenRepeat() async {
    setState(() => _isListening = true);
    final result = await _alphabetService.comparePronunciation(widget.letter.id);
    if (!mounted) return;

    setState(() => _isListening = false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Score: ${result.score}%'),
        content: Text(result.feedback),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    final isMastered = _progress.isMastered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(letter.name),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLetterCard(letter, isMastered),
          const SizedBox(height: 16),
          if (letter.articulation != null)
            _buildInfoCard('Articulation', letter.articulation!),
          if (letter.exampleSyllables.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildExampleCard(letter),
          ],
          const SizedBox(height: 24),
          _buildActions(letter),
        ],
      ),
    );
  }

  Widget _buildLetterCard(ArabicLetter letter, bool isMastered) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            letter.glyph,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${letter.glyph} - ${letter.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _playLetterAudio,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E4976),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text(
              'Play Sound',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          if (isMastered)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                SizedBox(width: 6),
                Text('Mastered', style: TextStyle(color: Color(0xFF4CAF50))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildExampleCard(ArabicLetter letter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example Syllables',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4976),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: letter.exampleSyllables
                .map((syllable) => Chip(
                      label: Text(
                        syllable,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: const Color(0xFFE3F2FD),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _playExampleAudio,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play examples'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActions(ArabicLetter letter) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isListening ? null : _startListenRepeat,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5F8F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isListening ? 'Listening...' : 'Listen & Repeat',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlphabetQuizScreen(focusLetter: letter),
                ),
              );
              _loadProgress();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1E4976), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Quiz for this Letter',
              style: TextStyle(
                color: Color(0xFF1E4976),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


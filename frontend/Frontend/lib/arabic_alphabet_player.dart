/// Example Flutter widget demonstrating how to use the Arabic Alphabet audio assets.
///
/// Dependencies required in pubspec.yaml:
///   audioplayers: ^6.1.0
///
/// This provides a ready-to-use audio playback helper for the Arabic Alphabet feature.

import 'package:audioplayers/audioplayers.dart';
import 'arabic_alphabet_config.dart';

/// Service class to handle Arabic letter audio playback
class ArabicLetterAudioPlayer {
  final AudioPlayer _player = AudioPlayer();
  String _currentSource = AudioSource.arabicReadingCourse;

  /// Currently selected audio source
  String get currentSource => _currentSource;

  /// Switch between audio sources (arabicreadingcourse, mualim_alquran, equranschool)
  void setSource(String sourceId) {
    if (AudioSource.all.contains(sourceId)) {
      _currentSource = sourceId;
    }
  }

  String _normalizeAssetPath(String path) {
    // audioplayers AssetSource expects a path relative to assets/.
    return path.startsWith('assets/') ? path.substring('assets/'.length) : path;
  }

  String _normalizeGlyph(String glyph) {
    if (glyph.isEmpty) return glyph;
    // Normalize common alif/hamzah forms so they map to the base audio key.
    return glyph
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا');
  }

  /// Find audio metadata by Arabic glyph (supports normalized alif variants).
  ArabicLetter? getLetterByGlyph(String glyph) {
    return ArabicAlphabetAudio.getByUnicode(_normalizeGlyph(glyph));
  }

  /// Play by Arabic glyph using primary flat audio.
  Future<void> playByGlyph(String glyph) async {
    final letter = getLetterByGlyph(glyph);
    if (letter == null) {
      return;
    }
    await playLetterPrimary(letter);
  }

  /// Play by Arabic glyph using selected source audio.
  Future<void> playByGlyphFromSource(String glyph, {String? sourceId}) async {
    final letter = getLetterByGlyph(glyph);
    if (letter == null) {
      return;
    }
    await playLetterFromSource(letter, sourceId: sourceId);
  }

  /// Play the pronunciation of a letter using the primary (flat) audio file
  Future<void> playLetterPrimary(ArabicLetter letter) async {
    await _player.stop();
    await _player.play(AssetSource(_normalizeAssetPath(letter.primaryAudioPath)));
  }

  /// Play the pronunciation from a specific source
  Future<void> playLetterFromSource(ArabicLetter letter, {String? sourceId}) async {
    final source = sourceId ?? _currentSource;
    final path = letter.sourceAudioPaths[source];
    if (path != null) {
      await _player.stop();
      await _player.play(AssetSource(_normalizeAssetPath(path)));
    }
  }

  /// Play letters sequentially (useful for alphabet recitation)
  Future<void> playAllLetters({
    Duration delayBetween = const Duration(milliseconds: 1500),
    void Function(int index)? onLetterPlaying,
  }) async {
    for (int i = 0; i < ArabicAlphabetAudio.letters.length; i++) {
      onLetterPlaying?.call(i);
      await playLetterPrimary(ArabicAlphabetAudio.letters[i]);
      await Future.delayed(delayBetween);
    }
  }

  /// Clean up resources
  void dispose() {
    _player.dispose();
  }
}

/// Example usage in a widget:
///
/// ```dart
/// class ArabicAlphabetScreen extends StatefulWidget {
///   @override
///   State<ArabicAlphabetScreen> createState() => _ArabicAlphabetScreenState();
/// }
///
/// class _ArabicAlphabetScreenState extends State<ArabicAlphabetScreen> {
///   final _audioPlayer = ArabicLetterAudioPlayer();
///   int? _activeLetter;
///
///   @override
///   void dispose() {
///     _audioPlayer.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: const Text('Arabic Alphabet')),
///       body: GridView.builder(
///         padding: const EdgeInsets.all(16),
///         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
///           crossAxisCount: 4,
///           childAspectRatio: 1,
///           crossAxisSpacing: 12,
///           mainAxisSpacing: 12,
///         ),
///         itemCount: ArabicAlphabetAudio.letters.length,
///         itemBuilder: (context, index) {
///           final letter = ArabicAlphabetAudio.letters[index];
///           final isActive = _activeLetter == index;
///           return GestureDetector(
///             onTap: () {
///               setState(() => _activeLetter = index);
///               _audioPlayer.playLetterPrimary(letter);
///             },
///             child: Container(
///               decoration: BoxDecoration(
///                 color: isActive ? Colors.teal : Colors.teal.shade50,
///                 borderRadius: BorderRadius.circular(12),
///               ),
///               child: Column(
///                 mainAxisAlignment: MainAxisAlignment.center,
///                 children: [
///                   Text(
///                     letter.unicode,
///                     style: TextStyle(
///                       fontSize: 32,
///                       color: isActive ? Colors.white : Colors.black87,
///                       fontFamily: 'Amiri', // Use an Arabic font
///                     ),
///                   ),
///                   const SizedBox(height: 4),
///                   Text(
///                     letter.nameEn,
///                     style: TextStyle(
///                       fontSize: 11,
///                       color: isActive ? Colors.white70 : Colors.black54,
///                     ),
///                   ),
///                 ],
///               ),
///             ),
///           );
///         },
///       ),
///     );
///   }
/// }
/// ```

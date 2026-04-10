import 'package:http/http.dart' as http;
import 'dart:convert';

class QuranAudioService {
  static const String _baseUrl = 'https://api.quran.com/api/v4';
  static const String _reciterId = '7'; // Mishary Al-Afasy (clear Tajweed)

  /// Get audio URL for a specific Ayah (verse)
  static Future<String?> getAyahAudio({
    required int surah,
    required int ayah,
  }) async {
    try {
      final url = '$_baseUrl/quran/verses/by_key/$surah:$ayah?recitation=$_reciterId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrl = data['verse']['audio']['url'];
        return audioUrl;
      }
    } catch (e) {
      print('❌ Error fetching Ayah audio: $e');
    }
    return null;
  }

  /// Get audio for multiple verses (for demonstration of Tajweed rules)
  static Future<List<Map<String, dynamic>>> getTajweedExamples({
    required String ruleName,
  }) async {
    try {
      // Map Tajweed rules to relevant verses
      final examplesMap = {
        'Ghunna': [
          {'surah': 2, 'ayah': 3, 'description': 'Example of Ghunna (Nun)'},
          {'surah': 2, 'ayah': 4, 'description': 'Example of Ghunna (Meem)'},
        ],
        'Ikhfa': [
          {'surah': 1, 'ayah': 1, 'description': 'Example of Ikhfa'},
          {'surah': 2, 'ayah': 2, 'description': 'Another Ikhfa example'},
        ],
        'Idhar': [
          {'surah': 1, 'ayah': 2, 'description': 'Example of Idhar'},
          {'surah': 2, 'ayah': 5, 'description': 'Another Idhar example'},
        ],
        'Madd': [
          {'surah': 1, 'ayah': 3, 'description': 'Example of Madd'},
          {'surah': 2, 'ayah': 6, 'description': 'Another Madd example'},
        ],
        'Qalqalah': [
          {'surah': 1, 'ayah': 4, 'description': 'Example of Qalqalah'},
          {'surah': 2, 'ayah': 7, 'description': 'Another Qalqalah example'},
        ],
      };

      final examples = examplesMap[ruleName] ?? [];
      final results = <Map<String, dynamic>>[];

      for (var example in examples) {
        final audioUrl = await getAyahAudio(
          surah: example['surah'] as int,
          ayah: example['ayah'] as int,
        );

        if (audioUrl != null) {
          results.add({
            'surah': example['surah'],
            'ayah': example['ayah'],
            'description': example['description'],
            'audioUrl': audioUrl,
          });
        }
      }

      return results;
    } catch (e) {
      print('❌ Error fetching Tajweed examples: $e');
      return [];
    }
  }

  /// Get metadata about a verse
  static Future<Map<String, dynamic>?> getVerseInfo({
    required int surah,
    required int ayah,
  }) async {
    try {
      final url = '$_baseUrl/quran/verses/by_key/$surah:$ayah';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'text': data['verse']['text_uthmani'],
          'translation': data['verse']['translations']?[0]?['text'] ?? '',
          'surah': surah,
          'ayah': ayah,
        };
      }
    } catch (e) {
      print('❌ Error fetching verse info: $e');
    }
    return null;
  }
}

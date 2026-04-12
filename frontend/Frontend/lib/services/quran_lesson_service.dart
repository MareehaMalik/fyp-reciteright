import 'package:http/http.dart' as http;
import 'dart:convert';

class QuranLessonService {
  // Fetch word by word for any ayah
  // Returns list of words with arabic, translation, transliteration, audio
  Future<List<QuranWord>> fetchWordByWord(int surah, int ayah) async {
    try {
      final url = 'https://api.quran.com/api/v4/verses/by_key/$surah:$ayah?words=true&word_fields=text_uthmani,transliteration,translation';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode != 200) {
        return [];
      }
      
      final data = jsonDecode(response.body);
      final words = data['verse']['words'] as List? ?? [];
      
      return words
          .where((w) => w['char_type_name'] == 'word')
          .map((w) => QuranWord(
            arabic: w['text_uthmani'] ?? '',
            translation: w['translation']?['text'] ?? '',
            transliteration: w['transliteration']?['text'] ?? '',
            audioUrl: w['audio_url'] != null 
              ? 'https://audio.qurancdn.com/${w['audio_url']}'
              : null,
          ))
          .toList();
    } catch (e) {
      // Error fetching word by word - gracefully handling
      return [];
    }
  }

  // Fetch tajweed colored text for any ayah
  Future<String> fetchTajweedText(int surah, int ayah) async {
    try {
      final url = 'https://api.alquran.cloud/v1/ayah/$surah:$ayah/quran-tajweed';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode != 200) {
        return '';
      }
      
      final data = jsonDecode(response.body);
      return data['data']['text'] ?? '';
    } catch (e) {
      // Error fetching tajweed text - gracefully handling
      return '';
    }
  }

  // Fetch full ayah text with tashkeel
  Future<String> fetchAyahText(int surah, int ayah) async {
    try {
      final url = 'https://api.quran.com/api/v4/verses/by_key/$surah:$ayah?fields=text_uthmani';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode != 200) {
        return '';
      }
      
      final data = jsonDecode(response.body);
      return data['verse']['text_uthmani'] ?? '';
    } catch (e) {
      // Error fetching ayah text - gracefully handling
      return '';
    }
  }

  // Fetch translation for any ayah
  Future<String> fetchTranslation(int surah, int ayah) async {
    try {
      final url = 'https://api.quran.com/api/v4/verses/by_key/$surah:$ayah?translations=131';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode != 200) {
        return '';
      }
      
      final data = jsonDecode(response.body);
      final translations = data['verse']['translations'] as List? ?? [];
      return translations.isNotEmpty ? (translations.first['text'] ?? '') : '';
    } catch (e) {
      // Error fetching translation - gracefully handling
      return '';
    }
  }

  // Fetch ayah audio
  String getAyahAudioUrl(int surah, int ayah) {
    final surahPadded = surah.toString().padLeft(3, '0');
    final ayahPadded = ayah.toString().padLeft(3, '0');
    return 'https://verses.quran.com/Alafasy/mp3/$surahPadded$ayahPadded.mp3';
  }
}

class QuranWord {
  final String arabic;
  final String translation;
  final String transliteration;
  final String? audioUrl;
  
  QuranWord({
    required this.arabic,
    required this.translation,
    required this.transliteration,
    this.audioUrl,
  });
}


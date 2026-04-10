// import 'package:flutter_tts/flutter_tts.dart';

// Mock TTS service for Windows development
// (flutter_tts requires nuget.exe which is not available in this environment)
class FlutterTts {
  Future<void> setLanguage(String language) async {}
  Future<void> setPitch(double pitch) async {}
  Future<void> setSpeechRate(double rate) async {}
  Future<void> speak(String text) async {}
  Future<void> stop() async {}
}

class TajweedTTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  /// Initialize TTS engine
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage('ar-SA'); // Arabic (Saudi Arabia)
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5); // Slower for Tajweed clarity
      _isInitialized = true;
      print('✅ TTS initialized');
    } catch (e) {
      print('❌ Error initializing TTS: $e');
    }
  }

  /// Speak text
  static Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('❌ Error speaking text: $e');
    }
  }

  /// Speak rule explanation
  static Future<void> speakRuleExplanation(String ruleName, String explanation) async {
    try {
      final fullText = '$ruleName: $explanation';
      await speak(fullText);
    } catch (e) {
      print('❌ Error speaking rule: $e');
    }
  }

  /// Stop TTS
  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('❌ Error stopping TTS: $e');
    }
  }

  /// Get predefined rule explanations (in Arabic for better pronunciation)
  static Map<String, String> getRuleExplanations() {
    return {
      'Ghunna': 'الغنة هي صوت انفي يخرج من الخيشوم، تقارن الحرف الذي قبلها في الجهر والرخاوة',
      'Ikhfa': 'الإخفاء هو النطق بالحرف بصفة بين الإدغام والإظهار، بدون تشديد',
      'Idhar': 'الإظهار هو إخراج الحرف من مخرجه من غير غنة، بوضوح الحرف',
      'Madd': 'المد هو إطالة الصوت عند النطق بحروف المد (الألف والواو والياء)',
      'Qalqalah': 'القلقلة هي حركة واهتزاز في الحرف عند النطق به ساكنا',
      'Tafkheem': 'التفخيم هو تسمين الحرف بإطالته والنطق به بقوة من الحلق',
      'Tarqeeq': 'الترقيق هو إنحفاء الحرف وتنحيفه بالنطق به بخفة',
    };
  }

  /// Dispose TTS resources
  static Future<void> dispose() async {
    try {
      await _flutterTts.stop();
      print('✅ TTS disposed');
    } catch (e) {
      print('❌ Error disposing TTS: $e');
    }
  }
}

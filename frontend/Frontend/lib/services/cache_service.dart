import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajweed_corrector/services/tajweed_service.dart';

class CacheService {
  static const String _lessonsKey = 'cached_tajweed_lessons';
  static const String _categoriesKey = 'cached_categories';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const int _cacheExpiryMinutes = 60 * 24; // 24 hours

  /// Cache lessons locally for offline access
  Future<void> cacheLessons(List<TajweedLesson> lessons) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final lessonsJson = jsonEncode(
        lessons.map((lesson) => lesson.toMap()).toList(),
      );

      await prefs.setString(_lessonsKey, lessonsJson);
      await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);

      print('✅ Cached ${lessons.length} lessons');
    } catch (e) {
      print('❌ Error caching lessons: $e');
    }
  }

  /// Get cached lessons
  Future<List<TajweedLesson>> getCachedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lessonsJson = prefs.getString(_lessonsKey);

      if (lessonsJson == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(lessonsJson);
      return decoded
          .map((lesson) => TajweedLesson.fromMap(
                Map<String, dynamic>.from(lesson),
                lesson['id'] ?? '',
              ))
          .toList();
    } catch (e) {
      print('❌ Error retrieving cached lessons: $e');
      return [];
    }
  }

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (timestamp == null) {
        return false;
      }

      final cacheAge = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
          .inMinutes;

      return cacheAge < _cacheExpiryMinutes;
    } catch (e) {
      print('❌ Error checking cache validity: $e');
      return false;
    }
  }

  /// Cache categories
  Future<void> cacheCategories(List<String> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_categoriesKey, categories);
      print('✅ Cached ${categories.length} categories');
    } catch (e) {
      print('❌ Error caching categories: $e');
    }
  }

  /// Get cached categories
  Future<List<String>> getCachedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_categoriesKey) ?? [];
    } catch (e) {
      print('❌ Error retrieving cached categories: $e');
      return [];
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lessonsKey);
      await prefs.remove(_categoriesKey);
      await prefs.remove(_cacheTimestampKey);
      print('✅ Cache cleared');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  /// Get cache size info
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedLessons = await getCachedLessons();
      final timestamp = prefs.getInt(_cacheTimestampKey);
      final isValid = await isCacheValid();

      return {
        'lessonsCount': cachedLessons.length,
        'lastUpdated': timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : null,
        'isValid': isValid,
        'estimatedSizeKB': (cachedLessons.length * 2), // rough estimate
      };
    } catch (e) {
      print('❌ Error getting cache info: $e');
      return {};
    }
  }
}

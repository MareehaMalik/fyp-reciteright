import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tajweed_corrector/services/tajweed_service.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Search lessons by title or description
  Future<List<TajweedLesson>> searchLessons(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final queryLower = query.toLowerCase();

    try {
      final snapshot = await _firestore.collection('tajweed_lessons').get();

      final results = snapshot.docs
          .map((doc) => TajweedLesson.fromMap(doc.data(), doc.id))
          .where((lesson) {
        return lesson.title.toLowerCase().contains(queryLower) ||
            lesson.description.toLowerCase().contains(queryLower) ||
            lesson.category.toLowerCase().contains(queryLower);
      }).toList();

      // Sort by relevance (title matches first, then description)
      results.sort((a, b) {
        bool aInTitle = a.title.toLowerCase().contains(queryLower);
        bool bInTitle = b.title.toLowerCase().contains(queryLower);

        if (aInTitle && !bInTitle) return -1;
        if (!aInTitle && bInTitle) return 1;
        return 0;
      });

      return results;
    } catch (e) {
      print('❌ Search error: $e');
      return [];
    }
  }

  /// Get unique categories from all lessons
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('tajweed_lessons').get();

      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('❌ Error fetching categories: $e');
      return [];
    }
  }

  /// Filter lessons by criteria
  Future<List<TajweedLesson>> filterLessons({
    String? category,
    String? difficulty,
  }) async {
    try {
      Query query = _firestore.collection('tajweed_lessons');

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      if (difficulty != null && difficulty.isNotEmpty) {
        query = query.where('difficulty', isEqualTo: difficulty);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => TajweedLesson.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('❌ Filter error: $e');
      return [];
    }
  }

  /// Get lessons by difficulty level
  Future<List<TajweedLesson>> getLessonsByDifficulty(String difficulty) async {
    return filterLessons(difficulty: difficulty);
  }

  /// Search and filter combined
  Future<List<TajweedLesson>> searchWithFilters({
    String? searchQuery,
    String? category,
    String? difficulty,
  }) async {
    try {
      List<TajweedLesson> results = [];

      if (searchQuery != null && searchQuery.isNotEmpty) {
        results = await searchLessons(searchQuery);
      } else {
        final snapshot = await _firestore.collection('tajweed_lessons').get();
        results = snapshot.docs
            .map((doc) => TajweedLesson.fromMap(doc.data(), doc.id))
            .toList();
      }

      // Apply filters
      if (category != null && category.isNotEmpty) {
        results = results.where((l) => l.category == category).toList();
      }

      if (difficulty != null && difficulty.isNotEmpty) {
        results = results.where((l) => l.difficulty == difficulty).toList();
      }

      return results;
    } catch (e) {
      print('❌ Search with filters error: $e');
      return [];
    }
  }
}

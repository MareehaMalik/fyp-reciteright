import 'package:cloud_firestore/cloud_firestore.dart';

class TajweedLesson {
  final String id;
  final String title;
  final String description;
  final String category;
  final String content;
  final List<String> examples;
  final String difficulty; // beginner, intermediate, advanced
  final int duration; // in minutes
  final DateTime createdAt;

  TajweedLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.content,
    required this.examples,
    required this.difficulty,
    required this.duration,
    required this.createdAt,
  });

  factory TajweedLesson.fromMap(Map<String, dynamic> map, String docId) {
    final rawExamples = map['examples'];
    final examples = rawExamples is List
        ? rawExamples.map((e) => e.toString()).toList()
        : <String>[];

    return TajweedLesson(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      content: map['content'] ?? '',
      examples: examples,
      difficulty: (map['difficulty'] ?? 'beginner').toString().toLowerCase(),
      duration: map['duration'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'content': content,
      'examples': examples,
      'difficulty': difficulty,
      'duration': duration,
      'createdAt': createdAt,
    };
  }
}

class TajweedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all lessons
  Future<List<TajweedLesson>> getAllLessons() async {
    try {
      final snapshot = await _firestore.collection('tajweed_lessons').get();

      final lessons = snapshot.docs
          .map((doc) {
            try {
              return TajweedLesson.fromMap(doc.data(), doc.id);
            } catch (e) {
              print('⚠️ Skipping malformed lesson ${doc.id}: $e');
              return null;
            }
          })
          .whereType<TajweedLesson>()
          .toList();

      lessons.sort((a, b) => a.title.compareTo(b.title));
      return lessons;
    } catch (e) {
      print('❌ Error getting lessons: $e');
      return [];
    }
  }

  // Get lessons by category
  Future<List<TajweedLesson>> getLessonsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('tajweed_lessons')
          .where('category', isEqualTo: category)
          .orderBy('difficulty')
          .get();

      return snapshot.docs
          .map((doc) => TajweedLesson.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting lessons by category: $e');
      return [];
    }
  }

  // Get lessons by difficulty
  Future<List<TajweedLesson>> getLessonsByDifficulty(String difficulty) async {
    try {
      final snapshot = await _firestore
          .collection('tajweed_lessons')
          .where('difficulty', isEqualTo: difficulty)
          .get();

      return snapshot.docs
          .map((doc) => TajweedLesson.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error getting lessons by difficulty: $e');
      return [];
    }
  }

  // Get a single lesson
  Future<TajweedLesson?> getLesson(String lessonId) async {
    try {
      final doc = await _firestore
          .collection('tajweed_lessons')
          .doc(lessonId)
          .get();

      if (doc.exists) {
        return TajweedLesson.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('❌ Error getting lesson: $e');
      return null;
    }
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final snapshot =
          await _firestore.collection('tajweed_lessons').get();
      
      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'];
        if (category != null) {
          categories.add(category);
        }
      }
      
      return categories.toList()..sort();
    } catch (e) {
      print('❌ Error getting categories: $e');
      return [];
    }
  }

  // Stream lessons by difficulty (real-time)
  Stream<List<TajweedLesson>> streamLessonsByDifficulty(String difficulty) {
    return _firestore
        .collection('tajweed_lessons')
        .where('difficulty', isEqualTo: difficulty)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TajweedLesson.fromMap(doc.data(), doc.id))
            .toList());
  }
}

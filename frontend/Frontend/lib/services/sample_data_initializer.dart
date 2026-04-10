import 'package:cloud_firestore/cloud_firestore.dart';

/// Sample data initialization for Tajweed lessons
/// Run this once in your Firestore database to populate with sample data
class SampleDataInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize sample Tajweed lessons in Firestore
  static Future<void> initializeSampleLessons() async {
    try {
      // Check if lessons already exist
      final snapshot = await _firestore.collection('tajweed_lessons').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('✅ Lessons already initialized');
        return;
      }

      // Sample lessons data
      final lessons = [
        {
          'title': 'Ghunnah',
          'description': 'A soft, nasal sound that is prolonged for two counts',
          'category': 'Nasalization',
          'content':
              'Ghunnah is a nasal sound produced entirely from the nasal cavity. It is prolonged for two counts and appears with specific letters (Noon and Meem) in certain conditions.',
          'examples': ['Nun with Sukun', 'Tanween', 'Meem with Sukun'],
          'difficulty': 'beginner',
          'duration': 5,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Ikhfaa',
          'description': 'Hidden or concealed recitation of Noon Sakinah or Tanween',
          'category': 'Noon Sakinah & Tanween',
          'content':
              'Ikhfaa occurs when Noon Sakinah or Tanween comes before 15 specific letters. The Noon is hidden with a nasal sound.',
          'examples': ['Noon before Seen', 'Noon before Thaa', 'Tanween before Taa'],
          'difficulty': 'beginner',
          'duration': 8,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Idhar',
          'description': 'Clear and distinct recitation of Noon Sakinah or Tanween',
          'category': 'Noon Sakinah & Tanween',
          'content':
              'Idhar means clarity and distinctness. It occurs when Noon Sakinah or Tanween is followed by the throat letters (Hamza, Ha, Ain, Ghayn).',
          'examples': [
            'Noon before Hamza',
            'Tanween before Ain',
            'Noon before Ghayn'
          ],
          'difficulty': 'beginner',
          'duration': 6,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Tafkheem',
          'description': 'Thickening or heaviness in the pronunciation of letters',
          'category': 'Letter Characteristics',
          'content':
              'Tafkheem means to make a letter thick or heavy. Certain letters are always pronounced with tafkheem (Qaf, Daal, Taa, Lam).',
          'examples': ['Qaf pronunciation', 'Emphasis on Daal', 'Thick Laam'],
          'difficulty': 'intermediate',
          'duration': 10,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Tarqeeq',
          'description': 'Thinning or lightness in the pronunciation of letters',
          'category': 'Letter Characteristics',
          'content':
              'Tarqeeq means to make a letter thin or light. Most letters are pronounced with tarqeeq except those with tafkheem.',
          'examples': ['Light Fa', 'Thin Ba', 'Soft Ha'],
          'difficulty': 'intermediate',
          'duration': 7,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Mad (Prolongation)',
          'description': 'Extending or prolonging the sound of specific letters',
          'category': 'Vowel Length',
          'content':
              'Mad refers to prolonging the sound of Alef, Waw, and Ya. Different types of Mad have different rules and durations.',
          'examples': ['Mad Tabee (Natural)', 'Mad Lazim', 'Mad Araidah'],
          'difficulty': 'intermediate',
          'duration': 12,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Assimilation (Idghaam)',
          'description': 'Merging or blending one letter with another',
          'category': 'Letter Combinations',
          'content':
              'Idghaam means to blend or merge one letter with another. This occurs with specific letter combinations with or without nasal sounds.',
          'examples': [
            'Complete Idghaam',
            'Idghaam with Ghunnah',
            'Partial Idghaam'
          ],
          'difficulty': 'advanced',
          'duration': 15,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Qalqalah',
          'description': 'A bouncing or jerking sound when certain letters are stopped',
          'category': 'Letter Characteristics',
          'content':
              'Qalqalah is a slight bounce or jerk in pronunciation when any of the five letters (Qaf, Taa, Ba, Jeem, Daal) have a Sukun.',
          'examples': [
            'Qalqalah Sughra (small)',
            'Qalqalah Kubra (great)',
            'Qalqalah at the end of Quran'
          ],
          'difficulty': 'intermediate',
          'duration': 9,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Hamazyah (Hamza Rules)',
          'description': 'Proper pronunciation and handling of the glottal stop',
          'category': 'Special Letters',
          'content':
              'Hamza is a glottal stop and has specific rules for pronunciation, elision, and stopping in different positions.',
          'examples': [
            'Initial Hamza',
            'Medial Hamza',
            'Final Hamza',
            'Hamza Wasl'
          ],
          'difficulty': 'advanced',
          'duration': 14,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'The Noon and Meem Rules',
          'description': 'Complete guide to Noon Sakinah and Meem Sakinah',
          'category': 'Nasal Letters',
          'content':
              'Complete comprehensive guide covering all rules for Noon Sakinah, Tanween, and Meem Sakinah with practical examples.',
          'examples': [
            'Idhar',
            'Ikhfaa',
            'Idghaam',
            'Laam Al-Ashul',
            'Meem Rules'
          ],
          'difficulty': 'advanced',
          'duration': 20,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      // Add lessons to Firestore
      WriteBatch batch = _firestore.batch();
      for (var lesson in lessons) {
        final docRef =
            _firestore.collection('tajweed_lessons').doc();
        batch.set(docRef, lesson);
      }

      await batch.commit();
      print('✅ Sample lessons initialized successfully');
    } catch (e) {
      print('❌ Error initializing sample lessons: $e');
    }
  }

  /// Create a new user profile document
  static Future<bool> createUserProfile({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'profileImageUrl': '',
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Initialize stats document
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('stats')
          .doc('overall')
          .set({
        'totalRecitations': 0,
        'thisWeek': 0,
        'currentStreak': 0,
        'bestStreak': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ User profile created successfully');
      return true;
    } catch (e) {
      print('❌ Error creating user profile: $e');
      return false;
    }
  }

  /// Add sample recitation record for testing
  static Future<bool> addSampleRecitation({
    required String uid,
    required String lessonId,
    required String lessonTitle,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('recitations')
          .add({
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'recordedAt': FieldValue.serverTimestamp(),
        'duration': 120, // 2 minutes
        'accuracy': 87.5,
        'notes': 'Great practice session!',
        'isPerfect': false,
      });

      print('✅ Sample recitation added successfully');
      return true;
    } catch (e) {
      print('❌ Error adding sample recitation: $e');
      return false;
    }
  }
}

import 'package:flutter/material.dart';

import '../models/tajweed_lesson.dart';

/// Quranic data including verses, translations, and reference audio URLs
/// Covers Surah Al-Fatiha (Surah 1) with complete metadata

const Map<int, Map<String, dynamic>> surahMetadata = {
  1: {
    'name': 'Al-Fatiha',
    'englishName': 'The Opening',
    'numberOfVerses': 7,
    'meaning': 'The opening chapter of the Quran, recited in every prayer',
    'revelationType': 'Meccan',
  },
};

const Map<int, Map<int, Map<String, dynamic>>> quranData = {
  1: {
    // SURAH AL-FATIHA
    1: {
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'transliteration': 'Bismillah ir-Rahman ir-Raheem',
      'translation': 'In the name of Allah, the Most Gracious, the Most Merciful',
      'words': [
        'بِسْمِ',
        'اللَّهِ',
        'الرَّحْمَٰنِ',
        'الرَّحِيمِ'
      ],
      'wordTranslations': [
        'In the name',
        'of Allah',
        'the Most Gracious',
        'the Most Merciful'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001001.mp3',
      'duration': 8,
    },
    2: {
      'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'transliteration': 'Alhamdu lillahi rabb il-aalameen',
      'translation': 'All praise is due to Allah, Lord of all the worlds',
      'words': [
        'الْحَمْدُ',
        'لِلَّهِ',
        'رَبِّ',
        'الْعَالَمِينَ'
      ],
      'wordTranslations': [
        'All praise is due',
        'to Allah',
        'Lord',
        'of all the worlds'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001002.mp3',
      'duration': 6,
    },
    3: {
      'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
      'transliteration': 'Ar-Rahman ir-Raheem',
      'translation': 'The Most Gracious, the Most Merciful',
      'words': [
        'الرَّحْمَٰنِ',
        'الرَّحِيمِ'
      ],
      'wordTranslations': [
        'the Most Gracious',
        'the Most Merciful'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001003.mp3',
      'duration': 4,
    },
    4: {
      'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
      'transliteration': 'Maliki yawm id-deen',
      'translation': 'Master of the Day of Judgment',
      'words': [
        'مَالِكِ',
        'يَوْمِ',
        'الدِّينِ'
      ],
      'wordTranslations': [
        'Master',
        'of the Day',
        'of Judgment'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001004.mp3',
      'duration': 4,
    },
    5: {
      'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'transliteration': "Iyyaka na'budu wa iyyaka nasta'een",
      'translation': 'You alone we worship, and You alone we ask for help',
      'words': [
        'إِيَّاكَ',
        'نَعْبُدُ',
        'وَإِيَّاكَ',
        'نَسْتَعِينُ'
      ],
      'wordTranslations': [
        'You alone',
        'we worship',
        'and You alone',
        'we ask for help'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001005.mp3',
      'duration': 5,
    },
    6: {
      'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      'transliteration': 'Ihdinas siraatal mustaqeem',
      'translation': 'Guide us on the Straight Path',
      'words': [
        'اهْدِنَا',
        'الصِّرَاطَ',
        'الْمُسْتَقِيمَ'
      ],
      'wordTranslations': [
        'Guide us',
        'the Straight Path',
        '[on it]'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001006.mp3',
      'duration': 4,
    },
    7: {
      'arabic':
          'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
      'transliteration':
          "Siraatal lazeena an'amta alayhim ghayril maghdoobi alayhim wa lad daalleen",
      'translation':
          'The path of those whom You have blessed, not of those who earned anger, nor of those who went astray',
      'words': [
        'صِرَاطَ',
        'الَّذِينَ',
        'أَنْعَمْتَ',
        'عَلَيْهِمْ',
        'غَيْرِ',
        'الْمَغْضُوبِ',
        'عَلَيْهِمْ',
        'وَلَا',
        'الضَّالِّينَ'
      ],
      'wordTranslations': [
        'The Path',
        'of those',
        'whom You have blessed',
        '[on them]',
        'not',
        'of those who earned anger',
        '[on them]',
        'nor',
        'of those who went astray'
      ],
      'audioUrl':
          'https://everyayah.com/data/Mishary_Rashid_Alafasy_128kbps/001007.mp3',
      'duration': 11,
    },
  },
};

/// Get complete metadata for a specific verse
Map<String, dynamic>? getAyatData(int surah, int verse) {
  return quranData[surah]?[verse];
}

/// Get just the Arabic text
String getArabicText(int surah, int verse) {
  return quranData[surah]?[verse]?['arabic'] ?? '';
}

/// Get transliteration
String getTransliteration(int surah, int verse) {
  return quranData[surah]?[verse]?['transliteration'] ?? '';
}

/// Get English translation
String getTranslation(int surah, int verse) {
  return quranData[surah]?[verse]?['translation'] ?? '';
}

/// Get the reference audio URL (Mishary Rashid from EveryAyah)
String getAudioUrl(int surah, int verse) {
  return quranData[surah]?[verse]?['audioUrl'] ?? '';
}

/// Get list of words (for word-level comparison later)
List<String> getWords(int surah, int verse) {
  final words = quranData[surah]?[verse]?['words'];
  return words != null ? List<String>.from(words) : [];
}

/// Get list of word translations
List<String> getWordTranslations(int surah, int verse) {
  final translations = quranData[surah]?[verse]?['wordTranslations'];
  return translations != null ? List<String>.from(translations) : [];
}

/// Get estimated duration of recitation
int getAudioDuration(int surah, int verse) {
  return quranData[surah]?[verse]?['duration'] ?? 0;
}

/// Get list of all available surahs
List<int> getAvailableSurahs() {
  return quranData.keys.toList();
}

/// Get number of verses in a surah
int getVerseCount(int surah) {
  return quranData[surah]?.length ?? 0;
}

/// Get list of all available verses in a surah
List<int> getAvailableVerses(int surah) {
  final surahData = quranData[surah];
  if (surahData == null) return [];
  return surahData.keys.toList()..sort();
}

/// Get surah English name
String getSurahName(int surah) {
  return surahMetadata[surah]?['englishName'] ?? 'Unknown Surah';
}

/// Get surah Arabic name
String getSurahArabicName(int surah) {
  return surahMetadata[surah]?['name'] ?? 'Unknown';
}

// =============================
// Lessons module data source
// =============================

const String fathaMark = '\u064E';
const String dammaMark = '\u064F';
const String kasraMark = '\u0650';
const String sukoonMark = '\u0652';
const String shaddaMark = '\u0651';
const String tanwinFathMark = '\u064B';
const String tanwinDammMark = '\u064C';
const String tanwinKasrMark = '\u064D';
const String noonSakinText = '\u0646\u0652';
const String meemSakinText = '\u0645\u0652';

final List<TajweedLesson> lessons = <TajweedLesson>[
  TajweedLesson(
    id: 'lesson_1',
    category: 'tajweed',
    title: 'Arabic Letters & Sounds',
    arabicTitle: '\u0627\u0644\u062d\u0631\u0648\u0641 \u0627\u0644\u0639\u0631\u0628\u064a\u0629',
    description: 'Learn the Arabic alphabet, sun/moon letters, and articulation basics.',
    icon: '\u0623',
    color: const Color(0xFF1565C0),
    duration: '12 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'The Arabic Alphabet',
        explanation: 'Arabic has 28 core letters and is read from right to left. Each letter has a stable sound identity, but its shape can change based on position in a word. Vowels are not separate letters in most cases; they are represented by marks. Learning the alphabet with stable articulation is the foundation for Tajweed.',
        arabicExample: '\u0623 \u0628 \u062a \u062b \u062c \u062d \u062e \u062f \u0630 \u0631 \u0632 \u0633 \u0634 \u0635 \u0636 \u0637 \u0638 \u0639 \u063a \u0641 \u0642 \u0643 \u0644 \u0645 \u0646 \u0647 \u0648 \u064a',
        transliteration: 'a, b, t, th, j, h, kh, d, dh, r, z, s, sh, s, d, t, z, a, gh, f, q, k, l, m, n, h, w, y',
        howToLearn: '1. Recite 5 letters at a time slowly.\n2. Use a mirror to check tongue and lip movement.\n3. Repeat each row three times before moving on.\n4. Listen and imitate a Qari for sound accuracy.',
        commonMistake: 'Students rush through letter names without mastering letter sounds. Tajweed depends on sound production, not just recognition.',
        tip: 'Pair each letter with one sample word from the Quran and repeat daily.',
        exampleSurah: 1,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Sun Letters',
        explanation: 'Sun letters are letters that absorb the Lam in the definite article Al (\u0627\u0644). Instead of pronouncing Lam clearly, the next letter is doubled with Shadda. This creates smoother flow in pronunciation. Mastering this avoids one of the most common beginner mistakes.',
        arabicExample: '\u0627\u0644\u0634\u0651\u064e\u0645\u0652\u0633\u064f \u2014 \u0627\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0646\u0650 \u2014 \u0627\u0644\u0646\u0651\u064f\u0648\u0631\u064f',
        transliteration: 'ash-shamsu, ar-rahmani, an-nooru',
        howToLearn: '1. Memorize the 14 sun letters.\n2. When you see Al before them, skip the Lam sound.\n3. Emphasize the next letter with shadda.\n4. Practice from Surah Al-Fatiha and short surahs.',
        commonMistake: 'Pronouncing Lam clearly before a sun letter, e.g., al-shams instead of ash-shams.',
        tip: 'Think: Sun letters melt Lam like sunlight melts ice.',
        exampleSurah: 1,
        exampleAyah: 3,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Moon Letters',
        explanation: 'Moon letters preserve the Lam in Al and require clear pronunciation. This is called Izhar Qamari. Unlike sun letters, there is no merging or doubling of the next letter. Correct distinction between sun and moon letters greatly improves fluency.',
        arabicExample: '\u0627\u0644\u0652\u0642\u064e\u0645\u064e\u0631\u064f \u2014 \u0627\u0644\u0652\u062d\u064e\u0645\u0652\u062f\u064f \u2014 \u0627\u0644\u0652\u0643\u0650\u062a\u064e\u0627\u0628\u064f',
        transliteration: 'al-qamaru, al-hamdu, al-kitaabu',
        howToLearn: '1. Memorize the 14 moon letters.\n2. Pronounce Lam clearly in Al before these letters.\n3. Read examples aloud with slow rhythm.\n4. Compare your recitation against a reference recitation.',
        commonMistake: 'Treating moon letters like sun letters and dropping Lam.',
        tip: 'Moon letters keep Lam visible in sound, like the moon stays visible at night.',
        exampleSurah: 1,
        exampleAyah: 2,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Arabic is read in which direction?',
        options: <String>['Left to right', 'Right to left', 'Top to bottom', 'Any direction'],
        correctIndex: 1,
        explanation: 'Arabic script is read from right to left.',
      ),
      QuizQuestion(
        question: 'In \u0627\u0644\u0634\u064e\u0651\u0645\u0633\u064f, the letter \u0634 is a?',
        arabicText: '\u0627\u0644\u0634\u064e\u0651\u0645\u0633\u064f',
        options: <String>['Moon letter', 'Sun letter', 'Neither', 'Madd letter'],
        correctIndex: 1,
        explanation: 'Shin is a sun letter so Lam is absorbed.',
      ),
      QuizQuestion(
        question: 'In \u0627\u0644\u0652\u0642\u064e\u0645\u064e\u0631\u064f, Lam is pronounced?',
        arabicText: '\u0627\u0644\u0652\u0642\u064e\u0645\u064e\u0631\u064f',
        options: <String>['Silent', 'Merged', 'Clearly', 'Nasalized'],
        correctIndex: 2,
        explanation: 'Qaf is a moon letter so Lam is clear.',
      ),
      QuizQuestion(
        question: 'How many letters are in the Arabic alphabet?',
        options: <String>['24', '26', '28', '30'],
        correctIndex: 2,
        explanation: 'Standard Arabic alphabet has 28 letters.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_2',
    category: 'tajweed',
    title: 'Harakat - Vowel Marks',
    arabicTitle: '\u0627\u0644\u062d\u0631\u0643\u0627\u062a',
    description: 'Master fatha, damma, kasra, sukoon, shadda and tanwin.',
    icon: '\u25cc\u064e',
    color: const Color(0xFF2E7D32),
    duration: '18 min',
    sections: <LessonSection>[
      LessonSection(
        title: "Fatha ($fathaMark)",
        explanation: 'Fatha is a small diagonal stroke written above a letter. It produces a short a sound as in cat. It appears frequently in Quranic words and must stay short. Without fatha, the letter does not carry that vowel quality.',
        arabicExample: '\u0628\u064e \u2014 \u0643\u064e\u062a\u064e\u0628\u064e \u2014 \u0641\u064e\u062a\u064e\u062d\u064e',
        transliteration: 'ba - kataba - fataha',
        howToLearn: '1. Open the mouth slightly for ah.\n2. Keep the tongue relaxed at the floor of the mouth.\n3. Say a short clipped a.\n4. Practice ba, ta, tha with one beat only.',
        commonMistake: 'Stretching fatha into a long aa sound. Fatha is short and should not be prolonged.',
        tip: 'The stroke sits above the letter; think of opening upward for a quick a.',
        exampleSurah: 1,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: "Damma ($dammaMark)",
        explanation: 'Damma is a small waw-like mark above the letter. It gives a short u sound, similar to put. It appears in nouns and verbs and should be kept brief. Lip rounding must be present but minimal.',
        arabicExample: '\u0628\u064f \u2014 \u0643\u064f\u062a\u064f\u0628\u064c \u2014 \u0631\u064f\u0633\u064f\u0644\u064c',
        transliteration: 'bu - kutubun - rusulun',
        howToLearn: '1. Round lips slightly.\n2. Produce a quick u, not oo.\n3. Keep sound half a count.\n4. Drill bu, tu, ju in sequence.',
        commonMistake: 'Turning short damma into a long oo.',
        tip: 'Damma shape resembles tiny waw; waw reminds you of the rounded sound.',
        exampleSurah: 1,
        exampleAyah: 2,
        showWordByWord: true,
      ),
      LessonSection(
        title: "Kasra ($kasraMark)",
        explanation: 'Kasra is the short i mark placed below the letter. It sounds like i in sit and appears often in prepositional structures. Proper kasra keeps recitation clear and balanced. It must not be extended into long ee unless followed by a madd ya.',
        arabicExample: '\u0628\u0650 \u2014 \u0628\u0650\u0633\u0652\u0645\u0650 \u2014 \u0631\u064e\u0628\u0651\u0650',
        transliteration: 'bi - bismi - rabbi',
        howToLearn: '1. Slightly widen the lips.\n2. Raise middle of tongue gently.\n3. Say quick i.\n4. Repeat bi, ti, si with one beat.',
        commonMistake: 'Confusing kasra with long ee sound.',
        tip: 'Kasra sits below; imagine lowering the jaw slightly for a short i.',
        exampleSurah: 1,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: "Sukoon ($sukoonMark)",
        explanation: 'Sukoon is the small circle showing no vowel follows the letter. The consonant is pronounced then stopped cleanly. This affects many Tajweed interactions, especially noon and meem rules. Correct sukoon handling prevents accidental vowel insertion.',
        arabicExample: '\u0628\u0652 \u2014 \u0645\u0650\u0646\u0652 \u2014 \u0639\u064e\u0646\u0652 \u2014 \u0644\u064e\u0645\u0652',
        transliteration: 'b (stop) - min - an - lam',
        howToLearn: '1. Pronounce the consonant clearly.\n2. Stop immediately without adding a vowel.\n3. Practice min, an, lam with crisp endings.\n4. Listen for accidental trailing vowels and remove them.',
        commonMistake: 'Adding hidden vowels after sukoon letters, like saying mina instead of min.',
        tip: 'Sukoon resembles zero; zero vowel follows.',
        exampleSurah: 1,
        exampleAyah: 4,
        showWordByWord: true,
      ),
      LessonSection(
        title: "Shadda ($shaddaMark)",
        explanation: 'Shadda marks a doubled consonant. The first part carries a stop-like hold and the second part carries the vowel. This changes meaning, rhythm, and Tajweed timing. Reading shadda as a single letter creates major pronunciation errors.',
        arabicExample: '\u0631\u064e\u0628\u0651\u0650 \u2014 \u0634\u064e\u062f\u0651\u064e \u2014 \u0645\u064e\u062f\u0651\u064e',
        transliteration: 'rabbi - shadda - madda',
        howToLearn: '1. Imagine the letter written twice.\n2. Hold first letter briefly.\n3. Release into second with vowel.\n4. Count two beats for clarity.',
        commonMistake: 'Adding emphasis but not doubling the consonant.',
        tip: 'When you see shadda, think: hold then release.',
        exampleSurah: 1,
        exampleAyah: 2,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: "Fatha ($fathaMark) makes which sound?",
        options: <String>['i', 'u', 'a', 'No sound'],
        correctIndex: 2,
        explanation: 'Fatha produces a short a sound.',
      ),
      QuizQuestion(
        question: "What does sukoon ($sukoonMark) indicate?",
        options: <String>['Long vowel', 'No vowel', 'Nasal hold', 'Merge letter'],
        correctIndex: 1,
        explanation: 'Sukoon means the letter has no following vowel.',
      ),
      QuizQuestion(
        question: "What is the key effect of shadda ($shaddaMark)?",
        options: <String>['Silence', 'Doubling', 'Lengthening vowel', 'Changing makhraj'],
        correctIndex: 1,
        explanation: 'Shadda doubles the consonant.',
      ),
      QuizQuestion(
        question: "Tanwin ($tanwinFathMark$tanwinDammMark$tanwinKasrMark) appears mostly at?",
        options: <String>['Word start', 'Word middle', 'Word end', 'Any position'],
        correctIndex: 2,
        explanation: 'Tanwin is generally written at word endings.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_3',
    category: 'tajweed',
    title: 'Noon Sakin & Tanwin',
    arabicTitle: '\u0627\u0644\u0646\u0648\u0646 \u0627\u0644\u0633\u0627\u0643\u0646\u0629 \u0648\u0627\u0644\u062a\u0646\u0648\u064a\u0646',
    description: 'Master Izhar, Idgham, Iqlab, and Ikhfa with practical examples.',
    icon: '\u0646',
    color: const Color(0xFF6A1B9A),
    duration: '20 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'What is Noon Sakin and Tanwin',
        explanation: 'Noon Sakin is Noon with sukoon and tanwin is a doubled ending vowel that carries an n sound. Both are governed by four central Tajweed rules. The next letter decides how the sound is produced. Applying the wrong rule changes fluency and accuracy.',
        arabicExample: '\u0645\u0650\u0646\u0652 \u2014 \u0639\u064e\u0646\u0652 \u2014 \u0643\u0650\u062a\u064e\u0627\u0628\u064c \u2014 \u0631\u064e\u062c\u064f\u0644\u064d',
        transliteration: 'min - an - kitaabun - rajulin',
        howToLearn: '1. Locate noon sakin or tanwin.\n2. Read the next letter.\n3. Match to one of 4 rules.\n4. Recite slowly before increasing speed.',
        commonMistake: 'Applying one style to all cases without checking the next letter.',
        tip: 'Noon sakin behaves like a chameleon: it changes with context.',
        exampleSurah: 2,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Izhar (Clear)',
        explanation: 'Izhar means clear pronunciation of noon or tanwin with no merge and no concealment. It applies before the six throat letters. Because these letters are far in articulation, merging does not occur naturally. The noon must be crisp and audible.',
        arabicExample: '\u0645\u064e\u0646\u0652 \u0622\u0645\u064e\u0646\u064e \u2014 \u0639\u064e\u0646\u0652\u0647\u064f\u0645\u0652 \u2014 \u0623\u064e\u0646\u0652\u0639\u064e\u0645\u0652\u062a\u064e',
        transliteration: 'man aamana - anhum - anamta',
        howToLearn: '1. Memorize throat letters: hamza, ha, ayn, haa, ghayn, kha.\n2. Keep noon clear.\n3. Avoid extra nasalization.\n4. Practice with short ayahs.',
        commonMistake: 'Adding ghunnah to Izhar where clarity is required.',
        tip: 'Izhar means reveal; reveal the noon clearly.',
        exampleSurah: 1,
        exampleAyah: 7,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Idgham, Iqlab, Ikhfa',
        explanation: 'Idgham merges noon into selected letters, Iqlab flips noon to meem before Ba, and Ikhfa conceals noon with nasalization across 15 letters. These three rules are the practical core of recitation rhythm. Accurate transitions make your recitation sound natural and trained. Each case requires conscious control of tongue, lips, and nose resonance.',
        arabicExample: '\u0645\u0650\u0646\u0652 \u0646\u0651\u064e\u0639\u0650\u064a\u0645\u064d \u2014 \u0645\u0650\u0646\u0652 \u0628\u064e\u0639\u0652\u062f\u0650 \u2014 \u0645\u0650\u0646\u0652 \u0642\u064e\u0628\u0652\u0644\u0650',
        transliteration: 'min naeem - mim badi - min qabli',
        howToLearn: '1. For Idgham, merge and drop noon identity.\n2. For Iqlab before Ba, convert to meem with ghunnah.\n3. For Ikhfa, keep hidden nasal for 2 counts.\n4. Train by reading minimal pairs repeatedly.',
        commonMistake: 'Fully pronouncing noon in Idgham or over-merging in Ikhfa.',
        tip: 'Sequence memory: clear, merge, flip, hide.',
        exampleSurah: 3,
        exampleAyah: 1,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Before throat letters, noon sakin uses?',
        options: <String>['Ikhfa', 'Izhar', 'Idgham', 'Iqlab'],
        correctIndex: 1,
        explanation: 'Throat letters trigger Izhar (clear noon).',
      ),
      QuizQuestion(
        question: 'Noon sakin before \u0628 follows?',
        arabicText: '\u0628',
        options: <String>['Izhar', 'Iqlab', 'Idgham', 'Ikhfa'],
        correctIndex: 1,
        explanation: 'Ba causes Iqlab (noon -> meem).',
      ),
      QuizQuestion(
        question: 'Ikhfa is best described as?',
        options: <String>['Fully clear', 'Fully merged', 'Concealed with ghunnah', 'Dropped completely'],
        correctIndex: 2,
        explanation: 'Ikhfa is a concealed nasal transition.',
      ),
      QuizQuestion(
        question: 'How many core rules govern noon sakin/tanwin?',
        options: <String>['2', '3', '4', '5'],
        correctIndex: 2,
        explanation: 'There are 4 rules: Izhar, Idgham, Iqlab, Ikhfa.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_4',
    category: 'tajweed',
    title: 'Madd - Elongation Rules',
    arabicTitle: '\u0627\u0644\u0645\u062f\u0648\u062f',
    description: 'Learn natural and secondary elongation with precise counts.',
    icon: '\u0640\u0627',
    color: const Color(0xFF1B5E20),
    duration: '18 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'What is Madd',
        explanation: 'Madd means elongation of vowel sound through specific madd letters. It improves rhythm and preserves Quranic pronunciation rules. Madd is measured in counts called harakat. Inconsistent counting leads to unstable recitation.',
        arabicExample: '\u0642\u064e\u0627\u0644\u064e \u2014 \u064a\u064e\u0642\u064f\u0648\u0644\u064f \u2014 \u0642\u0650\u064a\u0644\u064e',
        transliteration: 'qaala - yaqoolu - qeela',
        howToLearn: '1. Identify madd letters alif, waw, ya.\n2. Tap counts with fingers.\n3. Keep counts steady across verses.\n4. Listen and compare with expert reciters.',
        commonMistake: 'Lengthening randomly based on melody instead of rule.',
        tip: 'If count is unclear, slow down and count out loud first.',
        exampleSurah: 1,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Madd Asli (2 counts)',
        explanation: 'Madd Asli is the basic natural elongation of exactly 2 counts. It occurs when no hamza or sukoon-based cause follows the madd letter. This is the baseline rhythm for many words. Precision here supports every advanced madd type.',
        arabicExample: '\u0641\u0650\u064a \u2014 \u0642\u064e\u0627\u0644\u064e \u2014 \u0646\u064f\u0648\u062d\u064c',
        transliteration: 'fee - qaala - nooh',
        howToLearn: '1. Hold exactly two beats.\n2. Keep start and end clean.\n3. Repeat in short surahs.\n4. Record and self-check timing consistency.',
        commonMistake: 'Reading as 1 or 3 counts due to speed variation.',
        tip: 'Natural madd should feel balanced and effortless.',
        exampleSurah: 112,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Madd Muttasil (4-5 counts)',
        explanation: 'Madd Muttasil happens when madd letter and hamza occur in the same word. It is stronger than natural madd and read 4 to 5 counts according to recitation style. This rule is considered obligatory in application. Stable elongation is important for Tajweed correctness.',
        arabicExample: '\u062c\u064e\u0627\u0621\u064e \u2014 \u0633\u064e\u0627\u0621\u064e',
        transliteration: 'jaa-a - saa-a',
        howToLearn: '1. Detect hamza after madd within same word.\n2. Stretch to 4-5 counts.\n3. Keep airflow steady.\n4. Avoid breaking sound into two chunks.',
        commonMistake: 'Reducing muttasil to 2 counts like madd asli.',
        tip: 'Same word + hamza after madd = longer hold.',
        exampleSurah: 110,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Madd Munfasil (4-5 counts)',
        explanation: 'Madd Munfasil occurs when madd letter is at the end of one word and hamza begins the next. It is read with extended counts in many recitation methods. Unlike muttasil, the cause is separated across words. Smooth connection between words is key.',
        arabicExample: '\u0628\u0650\u0645\u064e\u0627 \u0623\u064f\u0646\u0652\u0632\u0650\u0644\u064e',
        transliteration: 'bimaa unzila',
        howToLearn: '1. Identify word boundary between madd and hamza.\n2. Hold 4-5 counts.\n3. Join words without a hard break.\n4. Rehearse with metronome-like counting.',
        commonMistake: 'Breaking phrase and losing flow between words.',
        tip: 'Munfasil means separated: the trigger spans two words.',
        exampleSurah: 2,
        exampleAyah: 4,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Madd Asli is read for how many counts?',
        options: <String>['1', '2', '4', '6'],
        correctIndex: 1,
        explanation: 'Madd Asli is always 2 counts.',
      ),
      QuizQuestion(
        question: 'Madd Muttasil occurs when hamza is?',
        options: <String>['Before madd in prior word', 'In same word after madd', 'At ayah end only', 'With sukoon only'],
        correctIndex: 1,
        explanation: 'Muttasil means connected in the same word.',
      ),
      QuizQuestion(
        question: 'Madd Munfasil differs because trigger is?',
        options: <String>['Inside one letter', 'Across two words', 'At pause only', 'Without hamza'],
        correctIndex: 1,
        explanation: 'Munfasil is separated across word boundary.',
      ),
      QuizQuestion(
        question: 'Which is a madd letter?',
        options: <String>['\u0628', '\u0627', '\u062c', '\u062f'],
        correctIndex: 1,
        explanation: 'Alif is one of the madd letters.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_5',
    category: 'tajweed',
    title: 'Qalqalah - Echoing Sound',
    arabicTitle: '\u0627\u0644\u0642\u0644\u0642\u0644\u0629',
    description: 'Learn the bounce of Qaf, Ta, Ba, Jeem, and Dal.',
    icon: '\u0642',
    color: const Color(0xFFB71C1C),
    duration: '14 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'What is Qalqalah',
        explanation: 'Qalqalah is a controlled echo effect for specific letters when they are in a sukoon state. It prevents the letter from sounding dead or swallowed. The bounce is brief and should not become a vowel. Correct qalqalah makes recitation crisp and clear.',
        arabicExample: '\u0642 \u0637 \u0628 \u062c \u062f',
        transliteration: 'q, t, b, j, d',
        howToLearn: '1. Stop air briefly on target letter.\n2. Release with light rebound.\n3. Keep it consonantal, not vowelized.\n4. Drill each letter separately then in words.',
        commonMistake: 'Turning qalqalah into an added short vowel.',
        tip: 'Think bounce, not extra syllable.',
        exampleSurah: 112,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'The 5 Qalqalah Letters',
        explanation: 'The letters are Qaaf, Taa, Baa, Jeem, and Daal. A common mnemonic phrase is Qutbu Jadd. These letters produce strongest clarity when released from a stop state. Recognition speed improves with repeated visual and oral drills.',
        arabicExample: '\u0642\u064f\u0637\u0652\u0628\u064f \u062c\u064e\u062f\u064d\u0651',
        transliteration: 'qutbu jadd',
        howToLearn: '1. Memorize mnemonic daily.\n2. Circle these letters in short surahs.\n3. Practice paused pronunciation.\n4. Compare minor and major intensity.',
        commonMistake: 'Applying qalqalah to letters outside this set.',
        tip: 'If letter is not in Qutbu Jadd, no qalqalah bounce.',
        exampleSurah: 113,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Kubra vs Sughra',
        explanation: 'Qalqalah Sughra is minor bounce inside a word where letter has sukoon. Qalqalah Kubra is stronger bounce at stopping points, usually verse endings. Intensity difference is audible but controlled. Both types must remain clean and non-musical.',
        arabicExample: '\u064a\u064e\u0642\u0652\u0637\u064e\u0639\u064f\u0648\u0646\u064e \u2014 \u0627\u0644\u0652\u0641\u064e\u0644\u064e\u0642\u0652',
        transliteration: 'yaqtauna - al-falaq (stop)',
        howToLearn: '1. Use soft bounce for middle-word sukoon.\n2. Use stronger bounce at final stop.\n3. Do not exceed natural timing.\n4. Rehearse paired examples back to back.',
        commonMistake: 'Making all qalqalah equally strong regardless of context.',
        tip: 'Middle = mild, stop = stronger.',
        exampleSurah: 113,
        exampleAyah: 1,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Which mnemonic includes all qalqalah letters?',
        options: <String>['\u0628\u0633\u0645 \u0627\u0644\u0644\u0647', '\u0642\u064f\u0637\u0652\u0628\u064f \u062c\u064e\u062f\u064d\u0651', '\u0627\u0644\u062d\u0645\u062f \u0644\u0644\u0647', '\u0644\u0627 \u0625\u0644\u0647 \u0625\u0644\u0627 \u0627\u0644\u0644\u0647'],
        correctIndex: 1,
        explanation: 'Qutbu Jadd is the classic mnemonic.',
      ),
      QuizQuestion(
        question: 'Qalqalah Kubra is usually heard when?',
        options: <String>['At word start', 'At verse stop', 'Only during sujood', 'With madd letters'],
        correctIndex: 1,
        explanation: 'Kubra is stronger at stopping points.',
      ),
      QuizQuestion(
        question: 'Qalqalah should sound like?',
        options: <String>['A new vowel', 'A slight rebound', 'A long ghunnah', 'A whisper'],
        correctIndex: 1,
        explanation: 'It is a slight consonantal rebound.',
      ),
      QuizQuestion(
        question: 'Is \u0635 a qalqalah letter?',
        options: <String>['Yes', 'No', 'Only at waqf', 'Only in madd'],
        correctIndex: 1,
        explanation: 'Saad is not part of Qutbu Jadd.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_6',
    category: 'tajweed',
    title: 'Ghunnah & Meem Sakinah',
    arabicTitle: '\u0627\u0644\u063a\u0646\u0629 \u0648\u0645\u064a\u0645 \u0633\u0627\u0643\u0646\u0629',
    description: 'Nasalization basics and the three meem sakinah rules.',
    icon: '\u063a',
    color: const Color(0xFF4A148C),
    duration: '15 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Ghunnah Core',
        explanation: 'Ghunnah is a nasal resonance emerging from the nasal cavity. It is required in noon and meem with shadda and in several assimilation rules. Standard duration is about 2 counts in most applied cases. Balanced ghunnah avoids both clipping and exaggeration.',
        arabicExample: '\u0625\u0650\u0646\u0651\u064e \u2014 \u062b\u064f\u0645\u0651\u064e',
        transliteration: 'inna - thumma',
        howToLearn: '1. Produce noon/meem with relaxed nose resonance.\n2. Count 2 beats.\n3. Use nose pinch test.\n4. Keep mouth articulation clean while resonating.',
        commonMistake: 'Forcing ghunnah too hard and distorting nearby letters.',
        tip: 'Resonance should feel steady, not loud.',
        exampleSurah: 112,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Meem Sakinah Rules',
        explanation: 'Meem Sakinah has three rules: Idgham Shafawi before meem, Ikhfa Shafawi before ba, and Izhar Shafawi before all other letters. These rules primarily involve lip behavior and nasal timing. Mastery improves clarity in connected recitation. Correct lip control is essential.',
        arabicExample: '\u0644\u064e\u0647\u064f\u0645\u0652 \u0645\u064e\u0627 \u2014 \u062a\u064e\u0631\u0652\u0645\u0650\u064a\u0647\u0650\u0645\u0652 \u0628\u0650\u062d\u0650\u062c\u064e\u0627\u0631\u064e\u0629\u064d \u2014 \u0644\u064e\u0647\u064f\u0645\u0652 \u0641\u0650\u064a\u0647\u064e\u0627',
        transliteration: 'lahum maa - tarmeehim bihijarah - lahum feeha',
        howToLearn: '1. Before meem: merge with ghunnah.\n2. Before ba: conceal with slight lip closure and ghunnah.\n3. Before others: pronounce meem clearly.\n4. Practice each pattern in isolation.',
        commonMistake: 'Applying ghunnah where Izhar Shafawi is required.',
        tip: 'Rule trigger is the letter after meem sukoon.',
        exampleSurah: 105,
        exampleAyah: 4,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Standard ghunnah duration is?',
        options: <String>['1 count', '2 counts', '4 counts', 'No count'],
        correctIndex: 1,
        explanation: 'Most ghunnah applications are read at 2 counts.',
      ),
      QuizQuestion(
        question: 'Meem sukoon before meem is?',
        options: <String>['Izhar Shafawi', 'Ikhfa Shafawi', 'Idgham Shafawi', 'Iqlab'],
        correctIndex: 2,
        explanation: 'Before meem, it merges (Idgham Shafawi).',
      ),
      QuizQuestion(
        question: 'Meem sukoon before ba is?',
        options: <String>['Idgham', 'Ikhfa Shafawi', 'Izhar', 'Qalqalah'],
        correctIndex: 1,
        explanation: 'Before Ba, Meem is concealed with ghunnah.',
      ),
      QuizQuestion(
        question: 'How can you test ghunnah resonance?',
        options: <String>['Open mouth wide', 'Pinch nose briefly', 'Whisper', 'Close lips hard'],
        correctIndex: 1,
        explanation: 'A gentle nose pinch should affect resonance if ghunnah is present.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_7',
    category: 'tajweed',
    title: 'Waqf & Ibtida',
    arabicTitle: '\u0627\u0644\u0648\u0642\u0641 \u0648\u0627\u0644\u0627\u0628\u062a\u062f\u0627\u0621',
    description: 'Stopping and restarting rules for meaningful recitation.',
    icon: '\u0648\u0642',
    color: const Color(0xFF004D40),
    duration: '12 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Meaning of Waqf and Ibtida',
        explanation: 'Waqf means stopping and Ibtida means restarting recitation. Correct stop points preserve meaning and grammar. Wrong stops can reverse or distort message. This rule is as important as pronunciation itself.',
        arabicExample: '\u0625\u0650\u064a\u064e\u0651\u0627\u0643\u064e \u0646\u064e\u0639\u0652\u0628\u064f\u062f\u064f \u0648\u064e\u0625\u0650\u064a\u064e\u0651\u0627\u0643\u064e \u0646\u064e\u0633\u0652\u062a\u064e\u0639\u0650\u064a\u0646\u064f',
        transliteration: 'iyyaka nabudu wa iyyaka nastaeen',
        howToLearn: '1. Read phrase by meaning units.\n2. Pause where sentence remains coherent.\n3. Resume from syntactic start point.\n4. Practice with teacher-marked stop signs.',
        commonMistake: 'Stopping at breath points that cut meaning.',
        tip: 'Meaning first, breath second.',
        exampleSurah: 1,
        exampleAyah: 5,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Common Waqf Symbols',
        explanation: 'Mushaf symbols guide reciters about stop priority. Some marks indicate required stop, some optional, and some disallow stop. Recognizing these signs avoids interpretation errors. Learn symbol behavior through repeated Quran reading.',
        arabicExample: '\u0645\u0640 \u2014 \u0644\u0627 \u2014 \u062c \u2014 \u0637 \u2014 \u0635',
        transliteration: 'meem - la - jeem - ta - sad',
        howToLearn: '1. Memorize each sign with one-line meaning.\n2. Highlight symbols in your mushaf.\n3. Pause only where allowed.\n4. Check with audio recitation.',
        commonMistake: 'Ignoring symbols and stopping randomly.',
        tip: 'Train your eye to scan for stop signs ahead.',
        exampleSurah: 1,
        exampleAyah: 7,
        showWordByWord: false,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Waqf means?',
        options: <String>['Start reciting', 'Stop reciting', 'Slow reciting', 'Silent reciting'],
        correctIndex: 1,
        explanation: 'Waqf means stopping.',
      ),
      QuizQuestion(
        question: 'The symbol \u0644\u0627 generally means?',
        arabicText: '\u0644\u0627',
        options: <String>['Must stop', 'Do not stop', 'Optional stop', 'Repeat line'],
        correctIndex: 1,
        explanation: 'La usually marks no-stop.',
      ),
      QuizQuestion(
        question: 'Best stopping principle is?',
        options: <String>['Stop every 3 words', 'Stop at punctuation only', 'Preserve meaning', 'Stop on long words'],
        correctIndex: 2,
        explanation: 'Waqf should preserve intended meaning.',
      ),
      QuizQuestion(
        question: 'Ibtida refers to?',
        options: <String>['Ending', 'Restarting', 'Speeding up', 'Nasalizing'],
        correctIndex: 1,
        explanation: 'Ibtida means beginning again after a stop.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'lesson_8',
    category: 'tajweed',
    title: 'Makharij - Letter Origins',
    arabicTitle: '\u0645\u062e\u0627\u0631\u062c \u0627\u0644\u062d\u0631\u0648\u0641',
    description: 'Train articulation points of throat, tongue, lips, and nasal cavity.',
    icon: '\u0645',
    color: const Color(0xFFE65100),
    duration: '16 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Articulation Zones',
        explanation: 'Makharij are physical exit points for letter sounds. Quranic Arabic demands precise production to avoid letter substitution. Main zones are throat, tongue, lips, and nasal passage. Each zone contributes unique acoustic character.',
        arabicExample: '\u0627\u0644\u062d\u0644\u0642 \u2014 \u0627\u0644\u0644\u0633\u0627\u0646 \u2014 \u0627\u0644\u0634\u0641\u062a\u0627\u0646 \u2014 \u0627\u0644\u062e\u064a\u0634\u0648\u0645',
        transliteration: 'al-halq - al-lisan - ash-shafatan - al-khayshoom',
        howToLearn: '1. Identify zone for each target letter.\n2. Produce in isolation then words.\n3. Use mirror and slow tempo.\n4. Get corrective feedback weekly.',
        commonMistake: 'Using home-language habits that shift Arabic points.',
        tip: 'Feel location physically; Tajweed is motor learning.',
        exampleSurah: 1,
        exampleAyah: 1,
        showWordByWord: true,
      ),
      LessonSection(
        title: 'Heavy and Light Letters',
        explanation: 'Some letters are naturally heavy and require tongue-back elevation. Others stay light with forward relaxed articulation. Contrast between these groups affects Quranic tone and meaning. Controlled mouth shape is the key to consistency.',
        arabicExample: '\u0635 \u0636 \u0637 \u0638 \u0642 \u063a \u062e \u2014 \u0633 \u062a \u0628 \u0646',
        transliteration: 'heavy letters vs light letters',
        howToLearn: '1. Read heavy set with fuller mouth cavity.\n2. Read light set with flatter tongue.\n3. Alternate pairs (s/saad, t/taa).\n4. Record and compare resonance.',
        commonMistake: 'Reading all letters with same mouth shape.',
        tip: 'Heaviness is resonance placement, not loudness.',
        exampleSurah: 1,
        exampleAyah: 6,
        showWordByWord: true,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Makharij refers to?',
        options: <String>['Stop signs', 'Articulation points', 'Madd counts', 'Qalqalah letters'],
        correctIndex: 1,
        explanation: 'Makharij are articulation points.',
      ),
      QuizQuestion(
        question: 'Which is a throat letter set?',
        options: <String>['\u0621 \u0647 \u0639 \u062d \u063a \u062e', '\u0628 \u0645 \u0648 \u0641', '\u0642 \u0637 \u0628 \u062c \u062f', '\u064a \u0646 \u0645 \u0648'],
        correctIndex: 0,
        explanation: 'These six letters are from throat zones.',
      ),
      QuizQuestion(
        question: 'Heavy letters mainly require?',
        options: <String>['Lip rounding only', 'Tongue-back elevation', 'Nasal pinch', 'No airflow'],
        correctIndex: 1,
        explanation: 'Heaviness comes from posterior tongue resonance.',
      ),
      QuizQuestion(
        question: 'Best way to train makharij?',
        options: <String>['Fast reading only', 'Mirror + slow drills', 'Silent reading', 'Memorize rules only'],
        correctIndex: 1,
        explanation: 'Motor precision needs slow visible practice.',
      ),
    ],
  ),

  // Islamic knowledge category
  TajweedLesson(
    id: 'islamic_1',
    category: 'islamic',
    title: 'Arkan-e-Islam (Pillars of Islam)',
    arabicTitle: '\u0623\u0631\u0643\u0627\u0646 \u0627\u0644\u0625\u0633\u0644\u0627\u0645',
    description: 'The five foundations every Muslim must know and practice.',
    icon: '\ud83d\udcff',
    color: Colors.teal,
    duration: '20 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Overview of the 5 Pillars',
        explanation: 'The five pillars are the core acts of worship in Islam. They build the practical structure of a Muslim life. These acts are obligatory for accountable adult Muslims. The term arkan means foundations that hold the religion upright.',
        arabicExample: '\u0623\u064e\u0631\u0652\u0643\u064e\u0627\u0646\u064f \u0627\u0644\u0652\u0625\u0650\u0633\u0652\u0644\u064e\u0627\u0645\u0650 \u062e\u064e\u0645\u0652\u0633\u064e\u0629\u064c',
        transliteration: 'arkaanul islaami khamsatun',
        howToLearn: '1. Memorize sequence: Shahadah, Salah, Zakat, Sawm, Hajj.\n2. Understand one line meaning for each.\n3. Link each pillar to daily action.\n4. Revise weekly.',
        commonMistake: 'Treating pillars as optional spiritual extras.',
        tip: 'S-S-Z-S-H helps memory.',
        exampleSurah: 2,
        exampleAyah: 177,
      ),
      LessonSection(
        title: 'Shahadah',
        explanation: 'Shahadah is the declaration of faith and entry to Islam. It combines rejection of false gods and affirmation of Allah and His Messenger. It must be believed sincerely and reflected in actions. It is not a phrase to repeat without commitment.',
        arabicExample: '\u0644\u064e\u0627 \u0625\u0650\u0644\u064e\u0670\u0647\u064e \u0625\u0650\u0644\u0651\u064e\u0627 \u0627\u0644\u0644\u0651\u064e\u0647\u064f \u0645\u064f\u062d\u064e\u0645\u0651\u064e\u062f\u064c \u0631\u064e\u0633\u064f\u0648\u0644\u064f \u0627\u0644\u0644\u0651\u064e\u0647\u0650',
        transliteration: 'laa ilaaha illallah muhammadur rasoolullah',
        howToLearn: '1. Memorize Arabic text correctly.\n2. Learn each phrase meaning.\n3. Reflect on tawheed daily.\n4. Align choices with shahadah.',
        commonMistake: 'Reciting without understanding or living by it.',
        tip: 'First half rejects false worship; second confirms prophethood.',
        exampleSurah: 3,
        exampleAyah: 18,
      ),
      LessonSection(
        title: 'Salah, Zakat, Sawm, Hajj',
        explanation: 'Salah organizes the day around remembrance. Zakat purifies wealth and protects society from neglect. Sawm builds discipline, sincerity, and gratitude. Hajj represents complete submission and unity of the ummah for those able.',
        arabicExample: '\u0648\u064e\u0623\u064e\u0642\u0650\u064a\u0645\u064f\u0648\u0627 \u0627\u0644\u0635\u0651\u064e\u0644\u064e\u0627\u0629\u064e \u0648\u064e\u0622\u062a\u064f\u0648\u0627 \u0627\u0644\u0632\u0651\u064e\u0643\u064e\u0627\u0629\u064e',
        transliteration: 'wa aqeemus salaata wa aatuz zakaah',
        howToLearn: '1. Track the five prayer times.\n2. Learn zakat calculator basics.\n3. Prepare Ramadan plan before month starts.\n4. Study Hajj rites from trusted fiqh guides.',
        commonMistake: 'Delaying obligations until convenient.',
        tip: 'Pillars are a lifelong schedule, not one-time theory.',
        exampleSurah: 2,
        exampleAyah: 43,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'How many pillars of Islam are there?',
        options: <String>['3', '4', '5', '6'],
        correctIndex: 2,
        explanation: 'There are five pillars of Islam.',
      ),
      QuizQuestion(
        question: 'Which pillar is the declaration of faith?',
        options: <String>['Sawm', 'Hajj', 'Shahadah', 'Zakat'],
        correctIndex: 2,
        explanation: 'Shahadah is the declaration of faith.',
      ),
      QuizQuestion(
        question: 'Zakat is best described as?',
        options: <String>['Optional donation', 'Obligatory charity', 'Pilgrimage tax', 'Prayer reward'],
        correctIndex: 1,
        explanation: 'Zakat is obligatory charity for eligible Muslims.',
      ),
      QuizQuestion(
        question: 'Sawm is performed in which month?',
        options: <String>['Muharram', 'Ramadan', 'Rajab', 'Shaban'],
        correctIndex: 1,
        explanation: 'Obligatory fasting is in Ramadan.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_2',
    category: 'islamic',
    title: 'How to Pray (Namaz / Salah)',
    arabicTitle: '\u0643\u064e\u064a\u0652\u0641\u064e \u062a\u064f\u0635\u064e\u0644\u0651\u0650\u064a',
    description: 'Step-by-step guide to performing prayer correctly.',
    icon: '\ud83e\udd32',
    color: Colors.green,
    duration: '24 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Preparation for Prayer',
        explanation: 'Before Salah, purity, direction, and intention are required. Wudu removes minor impurity and prepares body and mind. You face Qibla and stand with focused presence. Intention is in the heart and aligns action with worship.',
        arabicExample: '\u0627\u0644\u0648\u064f\u0636\u064f\u0648\u0621 \u2014 \u0627\u0644\u0642\u0650\u0628\u0652\u0644\u064e\u0629 \u2014 \u0627\u0644\u0646\u0651\u0650\u064a\u0651\u064e\u0629',
        transliteration: 'al-wudoo - al-qiblah - an-niyyah',
        howToLearn: '1. Complete wudu calmly.\n2. Confirm prayer time and qibla.\n3. Stand with intention for specific prayer.\n4. Begin with takbeer.',
        commonMistake: 'Rushing into salah distracted and unprepared.',
        tip: 'Preparation quality affects prayer quality.',
        exampleSurah: 5,
        exampleAyah: 6,
      ),
      LessonSection(
        title: 'Rakat Structure and Positions',
        explanation: 'Each prayer has fixed rakah units. Inside each rakah, core pillars include standing, bowing, and prostration. Transitions must be calm and complete. Learning this structure prevents invalid shortcuts.',
        arabicExample: '\u0642\u0650\u064a\u064e\u0627\u0645 \u2014 \u0631\u064f\u0643\u064f\u0648\u0639 \u2014 \u0633\u064f\u062c\u064f\u0648\u062f',
        transliteration: 'qiyam - ruku - sujood',
        howToLearn: '1. Memorize fard counts: 2,4,4,3,4.\n2. Practice one rakah slowly.\n3. Keep back straight in ruku.\n4. Complete two sujood per rakah.',
        commonMistake: 'Skipping stillness between movements.',
        tip: 'Pray as if teaching a beginner beside you.',
        exampleSurah: 2,
        exampleAyah: 43,
      ),
      LessonSection(
        title: 'Recitation, Tashahhud, and Salaam',
        explanation: 'In qiyam you recite Surah Al-Fatiha and additional verses where required. In ruku and sujood, prescribed dhikr is recited with humility. In final sitting, tashahhud and salawat are completed before salaam. This sequence closes prayer correctly.',
        arabicExample: '\u0627\u0644\u062a\u062d\u0650\u064a\u064e\u0651\u0627\u062a\u064f \u0644\u0650\u0644\u0651\u064e\u0647\u0650 \u2014 \u0627\u0644\u0633\u0651\u064e\u0644\u064e\u0627\u0645\u064f \u0639\u064e\u0644\u064e\u064a\u0652\u0643\u064f\u0645\u0652',
        transliteration: 'at-tahiyyaatu lillah - assalaamu alaykum',
        howToLearn: '1. Memorize Fatiha with tajweed.\n2. Learn ruku and sujood adhkar.\n3. Practice tashahhud text daily.\n4. End with right then left salaam.',
        commonMistake: 'Reading tashahhud incompletely then ending quickly.',
        tip: 'Quality in final sitting seals your prayer.',
        exampleSurah: 1,
        exampleAyah: 1,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'What is required before salah?',
        options: <String>['Only intention', 'Wudu, qibla, intention', 'Only clean clothes', 'Only adhan'],
        correctIndex: 1,
        explanation: 'Preparation includes wudu, qibla direction, and intention.',
      ),
      QuizQuestion(
        question: 'How many fard rakah in Maghrib?',
        options: <String>['2', '3', '4', '5'],
        correctIndex: 1,
        explanation: 'Maghrib has 3 fard rakah.',
      ),
      QuizQuestion(
        question: 'Which surah is recited in every rakah?',
        options: <String>['Al-Kawthar', 'Al-Falaq', 'Al-Fatiha', 'An-Nas'],
        correctIndex: 2,
        explanation: 'Surah Al-Fatiha is recited in every rakah.',
      ),
      QuizQuestion(
        question: 'Prayer ends with?',
        options: <String>['Ruku', 'Tashahhud only', 'Salaam', 'Dua only'],
        correctIndex: 2,
        explanation: 'Salah ends with salaam to both sides.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_3',
    category: 'islamic',
    title: 'Arkan-e-Iman (Pillars of Faith)',
    arabicTitle: '\u0623\u0631\u0643\u0627\u0646 \u0627\u0644\u0625\u064a\u0645\u0627\u0646',
    description: 'The six articles of faith that define Islamic belief.',
    icon: '\u262a\ufe0f',
    color: Colors.indigo,
    duration: '22 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Belief in Allah and Angels',
        explanation: 'Belief in Allah affirms absolute oneness, lordship, and perfect attributes. Belief in angels confirms unseen creation that obeys Allah and carries duties like revelation and records. These beliefs shape humility and accountability. A believer worships Allah alone and avoids superstition.',
        arabicExample: '\u0627\u0644\u062a\u0651\u064e\u0648\u0652\u062d\u0650\u064a\u062f \u2014 \u0627\u0644\u0645\u064e\u0644\u064e\u0627\u0626\u0650\u0643\u064e\u0629',
        transliteration: 'at-tawheed - al-malaaikah',
        howToLearn: '1. Study names and attributes of Allah from Quran/Sunnah.\n2. Learn key angel roles (Jibreel, Mikaeel, Israfeel, Malik).\n3. Reflect on daily accountability.\n4. Avoid practices that oppose tawheed.',
        commonMistake: 'Reducing tawheed to theory without worship impact.',
        tip: 'Strong tawheed simplifies every moral decision.',
        exampleSurah: 112,
        exampleAyah: 1,
      ),
      LessonSection(
        title: 'Books and Prophets',
        explanation: 'Allah sent divine books for guidance, culminating in the preserved Quran. Prophets delivered revelation and modeled obedience. Muslims honor all prophets without discrimination while believing Muhammad is the final messenger. This belief builds respect, continuity, and clarity in religion.',
        arabicExample: '\u0627\u0644\u0643\u064f\u062a\u064f\u0628 \u2014 \u0627\u0644\u0623\u0646\u0628\u0650\u064a\u0627\u0621',
        transliteration: 'al-kutub - al-anbiyaa',
        howToLearn: '1. Memorize major books and prophets.\n2. Learn stories with moral lessons.\n3. Read Quran with tafsir weekly.\n4. Follow prophetic manners in daily life.',
        commonMistake: 'Treating prophets as mythical without practical example.',
        tip: 'Prophetic stories are for guidance, not entertainment only.',
        exampleSurah: 2,
        exampleAyah: 136,
      ),
      LessonSection(
        title: 'Day of Judgment and Qadar',
        explanation: 'Belief in the Last Day establishes accountability for all deeds. Belief in Qadar means Allah knows and decrees all while humans are responsible for choices. Together they build patience, gratitude, and disciplined action. This protects from despair and arrogance.',
        arabicExample: '\u0627\u0644\u0642\u0650\u064a\u064e\u0627\u0645\u064e\u0629 \u2014 \u0627\u0644\u0642\u064e\u062f\u064e\u0631',
        transliteration: 'al-qiyaamah - al-qadar',
        howToLearn: '1. Remember death and accountability daily.\n2. Work hard while trusting Allah.\n3. Say Alhamdulillah in ease and hardship.\n4. Avoid blaming qadar for sins.',
        commonMistake: 'Using qadar as excuse for wrongdoing.',
        tip: 'Trust decree, own your actions.',
        exampleSurah: 57,
        exampleAyah: 22,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'How many pillars of Iman are there?',
        options: <String>['4', '5', '6', '7'],
        correctIndex: 2,
        explanation: 'There are 6 pillars of faith.',
      ),
      QuizQuestion(
        question: 'Final revealed book for Muslims is?',
        options: <String>['Torah', 'Zabur', 'Injeel', 'Quran'],
        correctIndex: 3,
        explanation: 'The Quran is the final preserved revelation.',
      ),
      QuizQuestion(
        question: 'Seal of Prophets is?',
        options: <String>['Isa (AS)', 'Musa (AS)', 'Muhammad (SAW)', 'Ibrahim (AS)'],
        correctIndex: 2,
        explanation: 'Prophet Muhammad is the final messenger.',
      ),
      QuizQuestion(
        question: 'Correct view of Qadar is?',
        options: <String>['No human choice', 'Humans create destiny fully', 'Allah decrees and humans are accountable', 'Only luck decides'],
        correctIndex: 2,
        explanation: 'Islam teaches both divine decree and human accountability.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_4',
    category: 'islamic',
    title: 'Wudu (Ritual Purification)',
    arabicTitle: '\u0627\u0644\u0648\u064f\u0636\u064f\u0648\u0621',
    description: 'How to perform wudu step-by-step before prayer.',
    icon: '\ud83d\udca7',
    color: Colors.lightBlue,
    duration: '16 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Steps of Wudu',
        explanation: 'Wudu starts with intention and Bismillah, then follows a prophetic order of washing. Hands, mouth, nose, face, arms, head, ears, and feet are covered with care. Most parts are washed three times except head wipe. Correct order and coverage are essential.',
        arabicExample: '\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u2014 \u0627\u0644\u0648\u064f\u062c\u064f\u0648\u0647 \u2014 \u0627\u0644\u0623\u064e\u064a\u0652\u062f\u0650\u064a',
        transliteration: 'bismillah - al-wujooh - al-aydi',
        howToLearn: '1. Wash hands 3x.\n2. Rinse mouth and nose 3x each.\n3. Wash face 3x and arms to elbows 3x.\n4. Wipe head and ears once, wash feet 3x.',
        commonMistake: 'Missing parts like heels or between fingers.',
        tip: 'Slow wudu once daily to improve complete coverage.',
        exampleSurah: 5,
        exampleAyah: 6,
      ),
      LessonSection(
        title: 'Dua and What Breaks Wudu',
        explanation: 'After wudu, Sunnah dua strengthens spiritual awareness. Wudu breaks through nullifiers such as using restroom, deep sleep, and passing wind. Maintaining wudu supports readiness for prayer and Quran interaction. Knowing nullifiers prevents invalid salah.',
        arabicExample: '\u0623\u064e\u0634\u0652\u0647\u064e\u062f\u064f \u0623\u064e\u0646\u0652 \u0644\u064e\u0627 \u0625\u0650\u0644\u064e\u0647\u064e \u0625\u0650\u0644\u0651\u064e\u0627 \u0627\u0644\u0644\u0651\u064e\u0647\u064f',
        transliteration: 'ashhadu an laa ilaaha illallah',
        howToLearn: '1. Memorize post-wudu dua.\n2. Learn common nullifiers.\n3. Renew wudu before salah if uncertain.\n4. Avoid obsessive doubt by following clear fiqh rules.',
        commonMistake: 'Constantly repeating wudu due to doubts without evidence.',
        tip: 'Certainty is not removed by doubt.',
        exampleSurah: 5,
        exampleAyah: 6,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Face is washed how many times in standard wudu?',
        options: <String>['1', '2', '3', '4'],
        correctIndex: 2,
        explanation: 'Common Sunnah practice is three washes.',
      ),
      QuizQuestion(
        question: 'Wiping the head in wudu is usually?',
        options: <String>['Once', 'Twice', 'Three times required', 'Optional'],
        correctIndex: 0,
        explanation: 'Head wipe is typically done once.',
      ),
      QuizQuestion(
        question: 'Which breaks wudu?',
        options: <String>['Reading Quran', 'Deep sleep', 'Saying dhikr', 'Smiling'],
        correctIndex: 1,
        explanation: 'Deep sleep is a known nullifier.',
      ),
      QuizQuestion(
        question: 'After wudu, what is recommended?',
        options: <String>['Eat immediately', 'Post-wudu dua', 'Sleep', 'Repeat all steps'],
        correctIndex: 1,
        explanation: 'Reciting the dua after wudu is recommended.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_5',
    category: 'islamic',
    title: 'Prophets of Islam',
    arabicTitle: '\u0623\u0646\u0628\u064a\u0627\u0621 \u0627\u0644\u0625\u0633\u0644\u0627\u0645',
    description: 'The 25 prophets mentioned in the Holy Quran.',
    icon: '\ud83d\udd4c',
    color: Colors.amber,
    duration: '18 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Overview',
        explanation: 'Prophets were human beings chosen to deliver divine guidance. Islam honors all prophets and rejects insulting any of them. Twenty-five are named in the Quran, from Adam to Muhammad. Their stories teach trust, patience, and obedience.',
        arabicExample: '\u0627\u0644\u0623\u0646\u0628\u0650\u064a\u0627\u0621 \u062e\u064e\u0645\u0633\u064e\u0629 \u0648\u0639\u0634\u0631\u0648\u0646',
        transliteration: 'al-anbiyaa khamsah wa ishroon',
        howToLearn: '1. Memorize names in order.\n2. Learn one key lesson from each.\n3. Review Quran references weekly.\n4. Discuss moral takeaways with family.',
        commonMistake: 'Thinking prophets were mythical or symbolic only.',
        tip: 'Prophetic stories are practical roadmaps for life.',
        exampleSurah: 6,
        exampleAyah: 84,
      ),
      LessonSection(
        title: 'Major Messengers and Final Prophet',
        explanation: 'Among prophets, five are Ulul Azm known for major missions and resilience: Nuh, Ibrahim, Musa, Isa, and Muhammad. Prophet Muhammad is final messenger for all humanity. Following him completes adherence to earlier revelations in corrected form. This belief preserves unity in creed.',
        arabicExample: '\u062e\u064e\u0627\u062a\u064e\u0645\u064f \u0627\u0644\u0646\u0651\u064e\u0628\u0650\u064a\u0651\u0650\u064a\u0646',
        transliteration: 'khaatamun nabiyyeen',
        howToLearn: '1. Learn ulul azm list.\n2. Study seerah of Prophet Muhammad deeply.\n3. Follow Sunnah in daily behavior.\n4. Send salawat often.',
        commonMistake: 'Assuming prophethood continues after Muhammad.',
        tip: 'Final prophet means final guidance framework.',
        exampleSurah: 33,
        exampleAyah: 40,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'How many prophets are named in Quran?',
        options: <String>['12', '20', '25', '40'],
        correctIndex: 2,
        explanation: 'Twenty-five prophets are named explicitly.',
      ),
      QuizQuestion(
        question: 'Who is the final prophet?',
        options: <String>['Isa (AS)', 'Musa (AS)', 'Muhammad (SAW)', 'Ibrahim (AS)'],
        correctIndex: 2,
        explanation: 'Muhammad is the Seal of Prophets.',
      ),
      QuizQuestion(
        question: 'Prophets in Islam are?',
        options: <String>['Angels', 'Human messengers', 'Kings only', 'Saints only'],
        correctIndex: 1,
        explanation: 'Prophets are human beings chosen by Allah.',
      ),
      QuizQuestion(
        question: 'Ulul Azm refers to?',
        options: <String>['5 major messengers', 'Companions', 'Quran chapters', 'Prayer types'],
        correctIndex: 0,
        explanation: 'Ulul Azm are the five resolute messengers.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_6',
    category: 'islamic',
    title: 'The Quran - Facts & History',
    arabicTitle: '\u0627\u0644\u0642\u0631\u0622\u0646 \u0627\u0644\u0643\u0631\u064a\u0645',
    description: 'Essential facts about revelation, structure, and preservation.',
    icon: '\ud83d\udcd6',
    color: Colors.deepPurple,
    duration: '20 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Revelation and Structure',
        explanation: 'The Quran was revealed over 23 years to guide life gradually. First revelation came in Ramadan in Cave Hira. Quran has 114 surahs, 30 juz, and 6236 ayahs in common counting. Its arrangement is divinely preserved and orally transmitted.',
        arabicExample: '\u0627\u0642\u0652\u0631\u064e\u0623\u0652 \u0628\u0650\u0627\u0633\u0652\u0645\u0650 \u0631\u064e\u0628\u0651\u0650\u0643\u064e',
        transliteration: 'iqra bismi rabbik',
        howToLearn: '1. Memorize key Quran facts.\n2. Study timeline of revelation.\n3. Read one juz overview monthly.\n4. Track Meccan vs Madinan themes.',
        commonMistake: 'Treating Quran as only ritual text without guidance role.',
        tip: 'Quran is recited, understood, and implemented.',
        exampleSurah: 96,
        exampleAyah: 1,
      ),
      LessonSection(
        title: 'Compilation and Memorization',
        explanation: 'The Quran was written and memorized during Prophet lifetime. It was compiled in codex form during early caliphate with strict verification. Huffaz chains continue this preservation across generations. This combined written and oral method is unique strength.',
        arabicExample: '\u0625\u0650\u0646\u0651\u064e\u0627 \u0646\u064e\u062d\u0652\u0646\u064f \u0646\u064e\u0632\u0651\u064e\u0644\u0652\u0646\u064e\u0627 \u0627\u0644\u0630\u0651\u0650\u0643\u0652\u0631\u064e',
        transliteration: 'inna nahnu nazzalna adh-dhikr',
        howToLearn: '1. Learn compilation history (Abu Bakr, Uthman).\n2. Attend hifz circles or listening sessions.\n3. Recite daily with tajweed.\n4. Review with teacher for correction.',
        commonMistake: 'Assuming Quran preservation is only textual, not oral.',
        tip: 'Preservation lives in hearts and manuscripts together.',
        exampleSurah: 15,
        exampleAyah: 9,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Quran was revealed over how many years?',
        options: <String>['10', '15', '23', '40'],
        correctIndex: 2,
        explanation: 'Revelation occurred over 23 years.',
      ),
      QuizQuestion(
        question: 'How many surahs are in Quran?',
        options: <String>['100', '110', '114', '120'],
        correctIndex: 2,
        explanation: 'There are 114 surahs.',
      ),
      QuizQuestion(
        question: 'First revealed command was?',
        options: <String>['Pray', 'Read', 'Fast', 'Give zakat'],
        correctIndex: 1,
        explanation: 'Iqra (Read) was first command.',
      ),
      QuizQuestion(
        question: 'Quran preservation includes?',
        options: <String>['Only translation', 'Only manuscripts', 'Oral + written chains', 'Only audio apps'],
        correctIndex: 2,
        explanation: 'Both oral and written preservation are central.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_7',
    category: 'islamic',
    title: 'Islamic History Highlights',
    arabicTitle: '\u0627\u0644\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0625\u0633\u0644\u0627\u0645\u064a',
    description: 'Key events every Muslim should know.',
    icon: '\ud83d\udcdc',
    color: Colors.brown,
    duration: '18 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Birth, Revelation, and Hijrah',
        explanation: 'The Prophet was born in 570 CE, known as Year of the Elephant. First revelation came in 610 CE in Cave Hira. Hijrah to Madinah in 622 CE marked a turning point and began Islamic calendar. These events frame the early mission timeline.',
        arabicExample: '\u063a\u0627\u0631 \u062d\u0631\u0627\u0621 \u2014 \u0627\u0644\u0647\u062c\u0631\u0629',
        transliteration: 'ghaar hira - al-hijrah',
        howToLearn: '1. Memorize key dates (570, 610, 622).\n2. Connect each date to event and lesson.\n3. Read brief seerah summaries.\n4. Build personal timeline chart.',
        commonMistake: 'Remembering dates but not significance.',
        tip: 'History serves iman when linked to lessons.',
        exampleSurah: 9,
        exampleAyah: 40,
      ),
      LessonSection(
        title: 'Badr and Conquest of Makkah',
        explanation: 'Battle of Badr in 624 CE showed that faith and discipline can defeat larger forces. Conquest of Makkah in 630 CE demonstrated mercy, restraint, and justice in victory. Both events teach strategy with spiritual reliance. Islamic leadership combined principle with compassion.',
        arabicExample: '\u0628\u064e\u062f\u0652\u0631 \u2014 \u0641\u064e\u062a\u0652\u062d \u0645\u064e\u0643\u0651\u064e\u0629',
        transliteration: 'badr - fath makkah',
        howToLearn: '1. Note dates 624 and 630.\n2. Study causes and outcomes briefly.\n3. Extract ethical lessons.\n4. Compare leadership styles in both events.',
        commonMistake: 'Viewing seerah as war narrative only.',
        tip: 'Victory in Islam is tied to character and obedience.',
        exampleSurah: 8,
        exampleAyah: 9,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Hijrah occurred in which year CE?',
        options: <String>['610', '622', '624', '630'],
        correctIndex: 1,
        explanation: 'Hijrah took place in 622 CE.',
      ),
      QuizQuestion(
        question: 'Battle of Badr was in?',
        options: <String>['610 CE', '622 CE', '624 CE', '630 CE'],
        correctIndex: 2,
        explanation: 'Badr occurred in 624 CE.',
      ),
      QuizQuestion(
        question: 'Conquest of Makkah happened in?',
        options: <String>['622 CE', '624 CE', '630 CE', '632 CE'],
        correctIndex: 2,
        explanation: 'Makkah was conquered in 630 CE.',
      ),
      QuizQuestion(
        question: 'Islamic calendar starts from?',
        options: <String>['Birth of Prophet', 'First Revelation', 'Hijrah', 'Badr'],
        correctIndex: 2,
        explanation: 'The Islamic calendar begins from Hijrah.',
      ),
    ],
  ),
  TajweedLesson(
    id: 'islamic_8',
    category: 'islamic',
    title: '99 Names of Allah (Asma ul Husna)',
    arabicTitle: '\u0623\u0633\u0645\u0627\u0621 \u0627\u0644\u0644\u0647 \u0627\u0644\u062d\u0633\u0646\u0649',
    description: 'Learn beautiful names of Allah and worship impact.',
    icon: '\u2728',
    color: Colors.deepOrange,
    duration: '22 min',
    sections: <LessonSection>[
      LessonSection(
        title: 'Most Important Names',
        explanation: 'Names such as Allah, Ar-Rahman, and Ar-Raheem establish central relationship with the Creator. They reflect majesty and mercy together. Knowing these names deepens dua and trust. Worship becomes more sincere when names are understood.',
        arabicExample: '\u0627\u0644\u0644\u0647 \u2014 \u0627\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0646 \u2014 \u0627\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645',
        transliteration: 'Allah - Ar-Rahman - Ar-Raheem',
        howToLearn: '1. Learn 3 names with meanings per week.\n2. Use names in dua intentionally.\n3. Note Quran verses containing each name.\n4. Reflect how each name shapes behavior.',
        commonMistake: 'Memorizing names without understanding meaning.',
        tip: 'Meaning transforms memorization into worship.',
        exampleSurah: 1,
        exampleAyah: 1,
      ),
      LessonSection(
        title: 'Names of Power, Knowledge, and Mercy',
        explanation: 'Al-Aziz and Al-Qahhar show divine authority. Al-Alim, Al-Baseer, and As-Samee remind us Allah knows and hears all. Al-Ghafoor and At-Tawwab inspire repentance and hope. Grouping names by themes helps practical reflection.',
        arabicExample: '\u0627\u0644\u0639\u0632\u064a\u0632 \u2014 \u0627\u0644\u0639\u0644\u064a\u0645 \u2014 \u0627\u0644\u063a\u0641\u0648\u0631',
        transliteration: 'al-azeez - al-aleem - al-ghafoor',
        howToLearn: '1. Make thematic groups (power, knowledge, mercy).\n2. Pick one name daily for reflection.\n3. Connect actions to that attribute.\n4. End day with related dua.',
        commonMistake: 'Focusing only on fear names or only on hope names.',
        tip: 'Balance awe and hope in worship.',
        exampleSurah: 59,
        exampleAyah: 22,
      ),
      LessonSection(
        title: 'Names of Creation',
        explanation: 'Names like Al-Khaliq, Al-Bari, and Al-Musawwir describe Allah as creator and shaper of all forms. They build gratitude and humility when observing life. This belief strengthens trust in divine wisdom. It also discourages arrogance about human ability.',
        arabicExample: '\u0627\u0644\u062e\u064e\u0627\u0644\u0650\u0642 \u2014 \u0627\u0644\u0628\u064e\u0627\u0631\u0650\u0626 \u2014 \u0627\u0644\u0645\u064f\u0635\u064e\u0648\u0651\u0650\u0631',
        transliteration: 'al-khaaliq - al-baari - al-musawwir',
        howToLearn: '1. Observe creation consciously each day.\n2. Say SubhanAllah with understanding.\n3. Read verses of creation themes.\n4. Keep gratitude journal tied to names.',
        commonMistake: 'Seeing names as abstract theology without daily effect.',
        tip: 'Creation around you is a daily classroom for Asma ul Husna.',
        exampleSurah: 59,
        exampleAyah: 24,
      ),
    ],
    questions: <QuizQuestion>[
      QuizQuestion(
        question: 'Ar-Rahman and Ar-Raheem are names of?',
        options: <String>['Power only', 'Mercy', 'Punishment only', 'Provision only'],
        correctIndex: 1,
        explanation: 'Both names highlight Allah mercy.',
      ),
      QuizQuestion(
        question: 'Al-Alim means?',
        options: <String>['All-Hearing', 'All-Knowing', 'The Creator', 'The Forgiver'],
        correctIndex: 1,
        explanation: 'Al-Alim means The All-Knowing.',
      ),
      QuizQuestion(
        question: 'Al-Khaliq is grouped under?',
        options: <String>['Names of creation', 'Names of punishment', 'Names of place', 'Names of time'],
        correctIndex: 0,
        explanation: 'Al-Khaliq is a creation-related name.',
      ),
      QuizQuestion(
        question: 'Best way to benefit from Asma ul Husna?',
        options: <String>['Memorize only', 'Use in dua and behavior', 'Write once', 'Read yearly only'],
        correctIndex: 1,
        explanation: 'Names should shape dua and character.',
      ),
    ],
  ),
];


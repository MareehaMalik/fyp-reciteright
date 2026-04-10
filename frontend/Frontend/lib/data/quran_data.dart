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

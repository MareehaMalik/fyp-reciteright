/// Arabic Alphabet Audio Assets Configuration
/// 
/// This file provides a comprehensive mapping of all 28 Arabic alphabet letters
/// to their audio pronunciation files from multiple free sources.
///
/// Sources:
///   - arabicreadingcourse.com (Primary - Letter name pronunciations)
///   - mualim-alquran.com (Mu'alim al-Qur'an - Quranic pronunciation)
///   - equranschool.com (Online Quran Academy - Standard pronunciation)
///
/// Usage:
///   Import this file and use [ArabicAlphabetAudio] to access letter data
///   and audio asset paths for your Arabic Alphabet feature.

class ArabicLetter {
  final int order;
  final String nameEn;
  final String nameAr;
  final String unicode;
  final String transliteration;
  final String soundDescription;

  /// Path to primary audio file (flat structure): assets/audio/arabic_alphabet_flat/{name}.mp3
  final String primaryAudioPath;

  /// Paths to audio files from each source (per-letter folder structure)
  final Map<String, String> sourceAudioPaths;

  const ArabicLetter({
    required this.order,
    required this.nameEn,
    required this.nameAr,
    required this.unicode,
    required this.transliteration,
    required this.soundDescription,
    required this.primaryAudioPath,
    required this.sourceAudioPaths,
  });
}

/// Audio source identifiers
class AudioSource {
  static const String arabicReadingCourse = 'arabicreadingcourse';
  static const String mualimAlQuran = 'mualim_alquran';
  static const String equranSchool = 'equranschool';

  static const List<String> all = [
    arabicReadingCourse,
    mualimAlQuran,
    equranSchool,
  ];

  static String displayName(String sourceId) {
    switch (sourceId) {
      case arabicReadingCourse:
        return 'Arabic Reading Course';
      case mualimAlQuran:
        return "Mu'alim al-Qur'an";
      case equranSchool:
        return 'Online Quran Academy';
      default:
        return sourceId;
    }
  }
}

class ArabicAlphabetAudio {
  static const String _basePath = 'assets/audio/arabic_alphabet';
  static const String _flatPath = 'assets/audio/arabic_alphabet_flat';

  /// All 28 Arabic alphabet letters with metadata and audio paths
  static const List<ArabicLetter> letters = [
    ArabicLetter(
      order: 1,
      nameEn: 'Alif',
      nameAr: 'أَلِف',
      unicode: 'ا',
      transliteration: 'ā / ʾ',
      soundDescription: 'Glottal stop or long "a" vowel carrier',
      primaryAudioPath: '$_flatPath/alif.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/alif/alif_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/alif/alif_mualim_alquran.mp3',
        'equranschool': '$_basePath/alif/alif_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 2,
      nameEn: 'Ba',
      nameAr: 'بَاء',
      unicode: 'ب',
      transliteration: 'b',
      soundDescription: 'Like English "b" in "boy"',
      primaryAudioPath: '$_flatPath/ba.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ba/ba_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ba/ba_mualim_alquran.mp3',
        'equranschool': '$_basePath/ba/ba_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 3,
      nameEn: 'Ta',
      nameAr: 'تَاء',
      unicode: 'ت',
      transliteration: 't',
      soundDescription: 'Like English "t" in "top"',
      primaryAudioPath: '$_flatPath/ta.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ta/ta_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ta/ta_mualim_alquran.mp3',
        'equranschool': '$_basePath/ta/ta_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 4,
      nameEn: 'Tha',
      nameAr: 'ثَاء',
      unicode: 'ث',
      transliteration: 'th',
      soundDescription: 'Like English "th" in "think"',
      primaryAudioPath: '$_flatPath/tha.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/tha/tha_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/tha/tha_mualim_alquran.mp3',
        'equranschool': '$_basePath/tha/tha_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 5,
      nameEn: 'Jeem',
      nameAr: 'جِيم',
      unicode: 'ج',
      transliteration: 'j',
      soundDescription: 'Like English "j" in "jam"',
      primaryAudioPath: '$_flatPath/jeem.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/jeem/jeem_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/jeem/jeem_mualim_alquran.mp3',
        'equranschool': '$_basePath/jeem/jeem_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 6,
      nameEn: 'Ha',
      nameAr: 'حَاء',
      unicode: 'ح',
      transliteration: 'ḥ',
      soundDescription: 'Voiceless pharyngeal fricative, breathy "h" from throat',
      primaryAudioPath: '$_flatPath/ha.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ha/ha_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ha/ha_mualim_alquran.mp3',
        'equranschool': '$_basePath/ha/ha_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 7,
      nameEn: 'Kha',
      nameAr: 'خَاء',
      unicode: 'خ',
      transliteration: 'kh',
      soundDescription: 'Guttural "kh" like Scottish "loch"',
      primaryAudioPath: '$_flatPath/kha.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/kha/kha_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/kha/kha_mualim_alquran.mp3',
        'equranschool': '$_basePath/kha/kha_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 8,
      nameEn: 'Dal',
      nameAr: 'دَال',
      unicode: 'د',
      transliteration: 'd',
      soundDescription: 'Like English "d" in "door"',
      primaryAudioPath: '$_flatPath/dal.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/dal/dal_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/dal/dal_mualim_alquran.mp3',
        'equranschool': '$_basePath/dal/dal_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 9,
      nameEn: 'Dhal',
      nameAr: 'ذَال',
      unicode: 'ذ',
      transliteration: 'dh',
      soundDescription: 'Like English "th" in "this"',
      primaryAudioPath: '$_flatPath/dhal.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/dhal/dhal_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/dhal/dhal_mualim_alquran.mp3',
        'equranschool': '$_basePath/dhal/dhal_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 10,
      nameEn: 'Ra',
      nameAr: 'رَاء',
      unicode: 'ر',
      transliteration: 'r',
      soundDescription: 'Rolled/trilled "r"',
      primaryAudioPath: '$_flatPath/ra.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ra/ra_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ra/ra_mualim_alquran.mp3',
        'equranschool': '$_basePath/ra/ra_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 11,
      nameEn: 'Zay',
      nameAr: 'زَاي',
      unicode: 'ز',
      transliteration: 'z',
      soundDescription: 'Like English "z" in "zoo"',
      primaryAudioPath: '$_flatPath/zay.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/zay/zay_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/zay/zay_mualim_alquran.mp3',
        'equranschool': '$_basePath/zay/zay_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 12,
      nameEn: 'Seen',
      nameAr: 'سِين',
      unicode: 'س',
      transliteration: 's',
      soundDescription: 'Like English "s" in "sun"',
      primaryAudioPath: '$_flatPath/seen.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/seen/seen_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/seen/seen_mualim_alquran.mp3',
        'equranschool': '$_basePath/seen/seen_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 13,
      nameEn: 'Sheen',
      nameAr: 'شِين',
      unicode: 'ش',
      transliteration: 'sh',
      soundDescription: 'Like English "sh" in "ship"',
      primaryAudioPath: '$_flatPath/sheen.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/sheen/sheen_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/sheen/sheen_mualim_alquran.mp3',
        'equranschool': '$_basePath/sheen/sheen_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 14,
      nameEn: 'Saad',
      nameAr: 'صَاد',
      unicode: 'ص',
      transliteration: 'ṣ',
      soundDescription: 'Emphatic "s" - heavier, deeper version of Seen',
      primaryAudioPath: '$_flatPath/saad.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/saad/saad_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/saad/saad_mualim_alquran.mp3',
        'equranschool': '$_basePath/saad/saad_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 15,
      nameEn: 'Daad',
      nameAr: 'ضَاد',
      unicode: 'ض',
      transliteration: 'ḍ',
      soundDescription: 'Emphatic "d" - unique to Arabic, tongue pressed against side teeth',
      primaryAudioPath: '$_flatPath/daad.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/daad/daad_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/daad/daad_mualim_alquran.mp3',
        'equranschool': '$_basePath/daad/daad_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 16,
      nameEn: 'Taa',
      nameAr: 'طَاء',
      unicode: 'ط',
      transliteration: 'ṭ',
      soundDescription: 'Emphatic "t" - stronger, forceful version of Ta',
      primaryAudioPath: '$_flatPath/taa.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/taa/taa_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/taa/taa_mualim_alquran.mp3',
        'equranschool': '$_basePath/taa/taa_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 17,
      nameEn: 'Dhaa',
      nameAr: 'ظَاء',
      unicode: 'ظ',
      transliteration: 'ẓ',
      soundDescription: 'Emphatic "dh" - heavier version of Dhal',
      primaryAudioPath: '$_flatPath/dhaa.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/dhaa/dhaa_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/dhaa/dhaa_mualim_alquran.mp3',
        'equranschool': '$_basePath/dhaa/dhaa_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 18,
      nameEn: 'Ayn',
      nameAr: 'عَيْن',
      unicode: 'ع',
      transliteration: 'ʿ',
      soundDescription: 'Voiced pharyngeal fricative - deep throaty sound, no English equivalent',
      primaryAudioPath: '$_flatPath/ayn.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ayn/ayn_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ayn/ayn_mualim_alquran.mp3',
        'equranschool': '$_basePath/ayn/ayn_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 19,
      nameEn: 'Ghayn',
      nameAr: 'غَيْن',
      unicode: 'غ',
      transliteration: 'gh',
      soundDescription: 'Like French "r" - gargling sound from back of throat',
      primaryAudioPath: '$_flatPath/ghayn.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ghayn/ghayn_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ghayn/ghayn_mualim_alquran.mp3',
        'equranschool': '$_basePath/ghayn/ghayn_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 20,
      nameEn: 'Fa',
      nameAr: 'فَاء',
      unicode: 'ف',
      transliteration: 'f',
      soundDescription: 'Like English "f" in "fish"',
      primaryAudioPath: '$_flatPath/fa.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/fa/fa_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/fa/fa_mualim_alquran.mp3',
        'equranschool': '$_basePath/fa/fa_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 21,
      nameEn: 'Qaf',
      nameAr: 'قَاف',
      unicode: 'ق',
      transliteration: 'q',
      soundDescription: 'Deep "k" from back of throat, near uvula',
      primaryAudioPath: '$_flatPath/qaf.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/qaf/qaf_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/qaf/qaf_mualim_alquran.mp3',
        'equranschool': '$_basePath/qaf/qaf_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 22,
      nameEn: 'Kaf',
      nameAr: 'كَاف',
      unicode: 'ك',
      transliteration: 'k',
      soundDescription: 'Like English "k" in "king"',
      primaryAudioPath: '$_flatPath/kaf.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/kaf/kaf_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/kaf/kaf_mualim_alquran.mp3',
        'equranschool': '$_basePath/kaf/kaf_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 23,
      nameEn: 'Lam',
      nameAr: 'لَام',
      unicode: 'ل',
      transliteration: 'l',
      soundDescription: 'Like English "l" in "lamp"',
      primaryAudioPath: '$_flatPath/lam.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/lam/lam_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/lam/lam_mualim_alquran.mp3',
        'equranschool': '$_basePath/lam/lam_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 24,
      nameEn: 'Meem',
      nameAr: 'مِيم',
      unicode: 'م',
      transliteration: 'm',
      soundDescription: 'Like English "m" in "moon"',
      primaryAudioPath: '$_flatPath/meem.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/meem/meem_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/meem/meem_mualim_alquran.mp3',
        'equranschool': '$_basePath/meem/meem_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 25,
      nameEn: 'Noon',
      nameAr: 'نُون',
      unicode: 'ن',
      transliteration: 'n',
      soundDescription: 'Like English "n" in "noon"',
      primaryAudioPath: '$_flatPath/noon.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/noon/noon_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/noon/noon_mualim_alquran.mp3',
        'equranschool': '$_basePath/noon/noon_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 26,
      nameEn: 'Ha (end)',
      nameAr: 'هَاء',
      unicode: 'ه',
      transliteration: 'h',
      soundDescription: 'Like English "h" in "hat" - lighter than Ḥā (ح)',
      primaryAudioPath: '$_flatPath/ha_end.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ha_end/ha_end_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ha_end/ha_end_mualim_alquran.mp3',
        'equranschool': '$_basePath/ha_end/ha_end_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 27,
      nameEn: 'Waw',
      nameAr: 'وَاو',
      unicode: 'و',
      transliteration: 'w',
      soundDescription: 'Like English "w" in "water"',
      primaryAudioPath: '$_flatPath/waw.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/waw/waw_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/waw/waw_mualim_alquran.mp3',
        'equranschool': '$_basePath/waw/waw_equranschool.mp3',
      },
    ),
    ArabicLetter(
      order: 28,
      nameEn: 'Ya',
      nameAr: 'يَاء',
      unicode: 'ي',
      transliteration: 'y',
      soundDescription: 'Like English "y" in "yes"',
      primaryAudioPath: '$_flatPath/ya.mp3',
      sourceAudioPaths: {
        'arabicreadingcourse': '$_basePath/ya/ya_arabicreadingcourse.mp3',
        'mualim_alquran': '$_basePath/ya/ya_mualim_alquran.mp3',
        'equranschool': '$_basePath/ya/ya_equranschool.mp3',
      },
    ),
  ];

  /// Get a letter by its order (1-28)
  static ArabicLetter? getByOrder(int order) {
    if (order < 1 || order > 28) return null;
    return letters[order - 1];
  }

  /// Get a letter by its English name (case-insensitive)
  static ArabicLetter? getByName(String name) {
    final lower = name.toLowerCase();
    return letters.cast<ArabicLetter?>().firstWhere(
      (l) => l!.nameEn.toLowerCase() == lower,
      orElse: () => null,
    );
  }

  /// Get a letter by its Arabic unicode character
  static ArabicLetter? getByUnicode(String char) {
    return letters.cast<ArabicLetter?>().firstWhere(
      (l) => l!.unicode == char,
      orElse: () => null,
    );
  }

  /// Get all asset paths that need to be declared in pubspec.yaml
  static List<String> get allAssetPaths {
    final paths = <String>[];
    // Flat structure
    paths.add('$_flatPath/');
    // Per-letter folders
    for (final letter in letters) {
      final folderName = letter.primaryAudioPath
          .split('/')
          .last
          .replaceAll('.mp3', '');
      paths.add('$_basePath/$folderName/');
    }
    return paths;
  }
}

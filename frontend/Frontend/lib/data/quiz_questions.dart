import 'dart:math';
import 'package:tajweed_corrector/models/quiz_models.dart';

class QuizQuestionBank {
  static final List<QuizQuestion> _allQuestions = [
    // ============ PROPHETS (10 questions) ============
    QuizQuestion(
      id: 'prophet_001',
      question: 'How many prophets are mentioned in the Holy Quran?',
      options: ['15', '25', '30', '40'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'The Quran mentions 25 prophets by name, including Prophet Adam AS (first) and Prophet Muhammad ﷺ (last).',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'prophet_002',
      question: 'Who is the last prophet of Islam?',
      options: ['Prophet Isa AS', 'Prophet Muhammad ﷺ', 'Prophet Sulaiman AS', 'Prophet Ibrahim AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Muhammad ﷺ is the final messenger of Allah, as stated in Surah Al-Ahzab: "Muhammad is not the father of any man among you, but he is the Messenger of Allah and the last of the prophets."',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'prophet_003',
      question: 'Who was the first prophet of Islam?',
      options: ['Prophet Ibrahim AS', 'Prophet Adam AS', 'Prophet Nuh AS', 'Prophet Musa AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Adam AS was the first prophet and first human being created by Allah. He is mentioned in Surah Al-Fatiha and throughout the Quran.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'prophet_004',
      question: 'Which prophets built the Kaaba together?',
      options: ['Prophet Musa AS and Prophet Harun AS', 'Prophet Ibrahim AS and his son Ismail AS', 'Prophet Sulaiman AS and his father Dawud AS', 'Prophet Muhammad ﷺ and Prophet Isa AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Ibrahim AS and his son Ismail AS built the Kaaba in Makkah as a sacred house of worship for Allah. This is mentioned in Surah Al-Baqarah.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'prophet_005',
      question: 'Which prophet could speak to animals and birds?',
      options: ['Prophet Yunus AS', 'Prophet Sulaiman AS', 'Prophet Nuh AS', 'Prophet Musa AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Sulaiman AS had the unique ability to speak to birds, animals, and jinn. This is mentioned in Surah An-Naml: "And he [Sulaiman] inherited from Dawud, and said: \'O people, we have been taught the language of birds...\'\"',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'prophet_006',
      question: 'Which prophet was swallowed by a whale?',
      options: ['Prophet Isa AS', 'Prophet Yunus AS', 'Prophet Salih AS', 'Prophet Lut AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Yunus AS (Jonah) was swallowed by a great whale when he left his people without permission. Allah saved him and he remained in the whale\'s belly for three days. Surah Yunus is named after him.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'prophet_007',
      question: 'Which prophet was thrown into a fire but was saved by Allah?',
      options: ['Prophet Salih AS', 'Prophet Ibrahim AS', 'Prophet Hud AS', 'Prophet Shuaib AS'],
      correctIndex: 1,
      category: 'prophets',
      explanation: 'Prophet Ibrahim AS was thrown into a blazing fire by the people of Ur for breaking their idols. Allah commanded the fire: "O fire! Be coolness and safety upon Ibrahim AS."',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'prophet_008',
      question: 'Which prophet parted the sea?',
      options: ['Prophet Sulaiman AS', 'Prophet Muhammad ﷺ', 'Prophet Musa AS', 'Prophet Isa AS'],
      correctIndex: 2,
      category: 'prophets',
      explanation: 'Prophet Musa AS parted the sea with his staff as commanded by Allah, allowing the Children of Israel to escape from Pharaoh\'s army. This is described in Surah Ash-Shuara.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'prophet_009',
      question: 'How many of Prophet Muhammad\'s ﷺ companions wrote down the Quran?',
      options: ['5', '10', '20', 'More than 40'],
      correctIndex: 3,
      category: 'prophets',
      explanation: 'More than 40 of Prophet Muhammad\'s ﷺ companions memorized and wrote down the Quran during his lifetime, ensuring its preservation.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'prophet_010',
      question: 'Which prophet was given the Psalms (Zabur)?',
      options: ['Prophet Musa AS', 'Prophet Isa AS', 'Prophet Dawud AS', 'Prophet Sulaiman AS'],
      correctIndex: 2,
      category: 'prophets',
      explanation: 'Prophet Dawud AS (David) was given the Zabur (Psalms), one of the four revealed scriptures, along with the Quran, Torah, and Gospels.',
      difficulty: 'hard',
    ),

    // ============ ISLAMIC (15 questions) ============
    QuizQuestion(
      id: 'islamic_001',
      question: 'How many names of Allah (Asma ul-Husna) are there?',
      options: ['77', '99', '111', '150'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'There are 99 names of Allah mentioned in the Quran and Hadith. The Prophet ﷺ said: "Verily, there are 99 names of Allah; whoever memorizes them will enter Paradise."',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_002',
      question: 'How many times is Salah (prayer) obligatory per day?',
      options: ['3', '4', '5', '7'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'Salah is obligatory five times daily: Fajr (dawn), Dhuhr (noon), Asr (afternoon), Maghrib (sunset), and Isha (night). These are the five pillars of prayer.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_003',
      question: 'How many pillars of Islam are there?',
      options: ['3', '4', '5', '6'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'The Five Pillars of Islam are: (1) Shahadah (testimony of faith), (2) Salah (prayer), (3) Zakat (almsgiving), (4) Sawm (fasting in Ramadan), and (5) Hajj (pilgrimage to Makkah).',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_004',
      question: 'When was the Battle of Badr (Ghazwa-e-Badr) fought?',
      options: ['17 Ramadan, 2 AH (624 CE)', '17 Shawwal, 3 AH (625 CE)', '15 Ramadan, 1 AH (622 CE)', '10 Hijjah, 10 AH (631 CE)'],
      correctIndex: 0,
      category: 'islamic',
      explanation: 'The Battle of Badr, the first major battle between Muslims and Quraysh, occurred on 17 Ramadan, 2 AH (March 625 CE), where Muslims won a decisive victory despite being outnumbered.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'islamic_005',
      question: 'In which month was the Quran revealed?',
      options: ['Muharram', 'Rajab', 'Ramadan', 'Dhul-Hijjah'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'The Quran was revealed during the month of Ramadan. The Quran states: "The month of Ramadan is that in which was revealed the Quran." Revelation began in Ramadan 610 CE and continued for 23 years.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_006',
      question: 'How many Surahs are in the Holy Quran?',
      options: ['100', '114', '120', '150'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'The Holy Quran consists of 114 Surahs (chapters) of varying lengths, from Surah Al-Fatiha (the opening) to Surah An-Nas (mankind).',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_007',
      question: 'What does \'Islam\' mean in Arabic?',
      options: ['Prayer', 'Peace and Submission to Allah', 'Charity', 'Fasting'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'Islam comes from the root word "Salaam" meaning peace, and means "submission" and "surrender to the will of Allah." It emphasizes both inner peace and complete submission to Allah.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'islamic_008',
      question: 'Which is the longest Surah in the Quran?',
      options: ['Surah Al-Fatiha', 'Surah Yaseen', 'Surah Al-Baqarah', 'Surah An-Nur'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'Surah Al-Baqarah (The Cow) is the longest Surah in the Quran with 286 ayahs. It is the second Surah and covers many important Islamic principles and laws.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'islamic_009',
      question: 'Which is the shortest Surah in the Quran?',
      options: ['Surah Al-Fil', 'Surah Al-Kawthar', 'Surah Al-Asr', 'Surah Al-Ikhlas'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'Surah Al-Kawthar (The Abundance) is the shortest Surah with only 3 ayahs. Despite its brevity, it contains profound meaning about the blessings Allah granted to Prophet Muhammad ﷺ.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'islamic_010',
      question: 'What is the first Surah of the Quran?',
      options: ['Surah An-Nas', 'Surah Ad-Duha', 'Surah Al-Fatiha', 'Surah Al-Alaq'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'Surah Al-Fatiha (The Opening) is the first Surah of the Quran with 7 ayahs. It is recited in every unit of prayer and is essential for all Muslims.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_011',
      question: 'How many Ayahs are in Surah Al-Fatiha?',
      options: ['5', '6', '7', '8'],
      correctIndex: 2,
      category: 'islamic',
      explanation: 'Surah Al-Fatiha has 7 ayahs. These verses praise Allah, the Merciful, and seek His guidance on the straight path.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'islamic_012',
      question: 'In which city was Prophet Muhammad ﷺ born?',
      options: ['Madinah', 'Makkah', 'Taif', 'Jerusalem'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'Prophet Muhammad ﷺ was born in Makkah around 570 CE. He was born in a year known as the Year of the Elephant (Aam-ul-Fil).',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'islamic_013',
      question: 'What is the Hijra?',
      options: ['The conquest of Makkah', 'The migration of Prophet Muhammad ﷺ from Makkah to Madinah', 'The night journey to Jerusalem', 'The farewell pilgrimage'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'The Hijra is the migration of Prophet Muhammad ﷺ and his followers from Makkah to Madinah in 622 CE to escape persecution. The Islamic calendar begins from this year (1 AH).',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'islamic_014',
      question: 'How many Rakat are in Fajr prayer?',
      options: ['2 Fard', '4 Fard', '3 Fard', '4 Fard + 2 Sunnah'],
      correctIndex: 0,
      category: 'islamic',
      explanation: 'The Fajr (dawn) prayer consists of 2 Rakat (units), both obligatory (Fard). This is the first of the five daily prayers.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'islamic_015',
      question: 'What does Ihram mean in Hajj?',
      options: ['The holy sanctuary', 'A special state of purity and consecration', 'The ritual circumambulation', 'The standing at Arafah'],
      correctIndex: 1,
      category: 'islamic',
      explanation: 'Ihram is the sacred state a pilgrim enters before performing Hajj, marked by special clothing and spiritual preparation. It represents dedication to Allah.',
      difficulty: 'hard',
    ),

    // ============ QURAN (12 questions) ============
    QuizQuestion(
      id: 'quran_001',
      question: 'How many total Ayahs (verses) are in the Quran?',
      options: ['5,000', '6,000', '6,236', '7,000'],
      correctIndex: 2,
      category: 'quran',
      explanation: 'The Holy Quran contains exactly 6,236 ayahs (verses) distributed across 114 Surahs. This count is universally agreed upon by Islamic scholars.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_002',
      question: 'How many Juz (parts) are in the Quran?',
      options: ['20', '25', '30', '40'],
      correctIndex: 2,
      category: 'quran',
      explanation: 'The Quran is divided into 30 Juz (equal parts) to facilitate reading and memorization. Each Juz can be read in approximately one day.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'quran_003',
      question: 'What is the meaning of \'Al-Fatiha\'?',
      options: ['The Mercy', 'The Opening', 'The Light', 'The Guidance'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'Al-Fatiha means "The Opening." It is the name of the first Surah because it opens (introduces) the Quran and every cycle of prayer.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'quran_004',
      question: 'Which Surah is called the Heart of the Quran?',
      options: ['Surah Al-Fatiha', 'Surah Yaseen', 'Surah Muhammad', 'Surah An-Nur'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'Surah Yaseen is often referred to as the "Heart of the Quran" (Qalb al-Quran). The Prophet ﷺ said it has many benefits and is recited for many purposes.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'quran_005',
      question: 'Which is the only Surah that does not begin with Bismillah?',
      options: ['Surah At-Tawbah', 'Surah Al-Fatiha', 'Surah Al-Baqarah', 'Surah An-Nur'],
      correctIndex: 0,
      category: 'quran',
      explanation: 'Surah At-Tawbah (Chapter 9) is the only Surah that does not begin with "Bismillah ir-Rahman ir-Rahim." This is because it deals with Allah\'s punishment and not mercy.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_006',
      question: 'How many Sajdahs (prostrations) are in the Quran?',
      options: ['12', '14', '16', '20'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'There are 14 Sajdahs (verses of prostration) in the Quran. When a Muslim reaches any of these verses, they should perform a prostration (Sajdah) of gratitude.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_007',
      question: 'What does \'Ayah\' mean in Arabic?',
      options: ['Chapter', 'Sign or Verse', 'Prayer', 'Blessing'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'Ayah means "sign" or "verse." Each verse of the Quran is called an Ayah because it is a sign (evidence) of Allah\'s wisdom and power.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'quran_008',
      question: 'Which Surah contains the longest Ayah?',
      options: ['Surah Al-Baqarah', 'Surah Ali Imran', 'Surah An-Nur', 'Surah Al-Araf'],
      correctIndex: 0,
      category: 'quran',
      explanation: 'The longest Ayah in the Quran is Ayah 282 of Surah Al-Baqarah, which deals with contracts and transactions. This verse is approximately 8-9 lines long in most Quran copies.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_009',
      question: 'How many times is the word "Quran" mentioned in the Quran?',
      options: ['50', '70', '80', '100'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'The word "Quran" appears 70 times throughout the Quran. It emphasizes the importance and centrality of the Quranic text in Islam.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_010',
      question: 'Which Surah begins with the Arabic letters "Alif Lam Meem"?',
      options: ['Surah Al-Baqarah', 'Surah Ar-Rum', 'Surah Ash-Shuara', 'All of the above'],
      correctIndex: 3,
      category: 'quran',
      explanation: 'The letters "Alif Lam Meem" (ا ل م) appear at the beginning of several Surahs: Al-Baqarah, Ar-Rum, Luqman, Ash-Shuara, and Qasas. These are called "Muqatta\'at" (abbreviated letters).',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_011',
      question: 'Which Surah is closest in meaning to a discussion about wealth and material resources?',
      options: ['Surah Al-Kahf', 'Surah Al-Maun', 'Surah Al-Anfal', 'Surah Al-Asr'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'Surah Al-Maun (The Small Kindness) discusses social responsibility and warns against those who neglect orphans and discourage others from helping the poor.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'quran_012',
      question: 'What is a "Waqf" in Quranic recitation?',
      options: ['A type of prayer', 'Rules for stopping and pausing during recitation', 'A unit of measurement', 'A prophetic teaching'],
      correctIndex: 1,
      category: 'quran',
      explanation: 'Waqf refers to the rules and guidelines about where and how to pause or stop during the recitation of the Quran. It\'s an important part of proper Quranic recitation.',
      difficulty: 'medium',
    ),

    // ============ TAJWEED (21 questions) ============
    QuizQuestion(
      id: 'tajweed_001',
      question: 'What is Tajweed?',
      options: [
        'A prayer performed during Ramadan',
        'The set of rules for correct pronunciation of Quranic Arabic',
        'A type of Islamic poetry',
        'A chapter of the Quran'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Tajweed is the science of correctly pronouncing the Arabic letters of the Quran with proper articulation, timing, and intonation according to specific rules.',
      difficulty: 'easy',
    ),
    QuizQuestion(
      id: 'tajweed_002',
      question: 'What is Ghunnah?',
      options: [
        'A call to prayer',
        'Nasalization — pronouncing sound through the nose for 2 counts',
        'A type of fasting',
        'A specific Surah'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Ghunnah is the nasalization or resonance that occurs when pronouncing the letter Noon (ن) or Meem (م), creating a nasal sound that lasts for 2 counts (harakaat).',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_003',
      question: 'What is Madd?',
      options: [
        'A type of speed in recitation',
        'Elongation of a vowel sound',
        'A form of prayer',
        'A fasting practice'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Madd is the elongation or extension of vowel sounds. When certain vowels are followed by specific letters, they are lengthened beyond their normal pronunciation duration.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_004',
      question: 'What is Ikhfa?',
      options: [
        'The fastest recitation',
        'Concealment — pronouncing a letter between clarity and merging',
        'A type of prayer position',
        'A Quranic story'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Ikhfa (concealment) occurs when the letter Noon Sakin or Tanween is followed by specific letters. The Noon is pronounced with a hidden quality, neither fully clear nor fully merged.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_005',
      question: 'What is Idgham?',
      options: [
        'A type of rhythm',
        'Merging — blending one letter into the next',
        'A style of chanting',
        'A specific Islamic rule'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Idgham is the process of merging or assimilating one letter into the next. When Noon Sakin or Tanween is followed by certain letters (ي, ر, ل, و, ن, م), it merges with that letter.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_006',
      question: 'What is Qalqalah?',
      options: [
        'A form of meditation',
        'An echoing or bouncing sound on certain letters',
        'A type of musical rhythm',
        'A prayer technique'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Qalqalah is the echoing or bouncing sound that occurs when pronouncing the letters with heavy sounds (ق, ط, ب, ج, د), especially when they have the Sukoon (no vowel).',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_007',
      question: 'What are the Qalqalah letters?',
      options: [
        'ق ط ب ج د (QTBGD)',
        'ه خ ع غ (HKHAG)',
        'ص ض ط ظ (SSDZ)',
        'ش س ز (SSZ)'
      ],
      correctIndex: 0,
      category: 'tajweed',
      explanation: 'The Qalqalah letters are the 5 letters: ق (Qaf), ط (Tah), ب (Ba), ج (Jeem), and د (Dal). These are pronounced with a bouncing echo, especially when they have no vowel.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_008',
      question: 'What is Izhar?',
      options: [
        'Hidden pronunciation',
        'Clear pronunciation of Noon Sakin or Tanween',
        'Merged pronunciation',
        'Soft pronunciation'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Izhar (clarity) is when the Noon Sakin or Tanween is pronounced clearly and distinctly before the letters of the throat (ء، ه، ع، غ، خ، ح).',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_009',
      question: 'What is Iqlab?',
      options: [
        'Moving from one letter to another',
        'Converting Noon Sakin into a Meem sound before the letter Ba',
        'Stopping at specific points',
        'Extending the vowels'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Iqlab is the conversion of Noon Sakin or Tanween into a Meem (م) sound before the letter Ba (ب). For example, in "من بعد" the Noon is pronounced as Meem.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_010',
      question: 'What is Waqf?',
      options: [
        'A prayer',
        'Rules for stopping and pausing during recitation',
        'A type of letter',
        'A Quranic division'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Waqf is the practice of properly stopping at specific points in the Quran. There are rules about where stopping is permitted, recommended, or prohibited to maintain proper meaning.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_011',
      question: 'What is Shadda in Tajweed?',
      options: [
        'A musical tone',
        'A doubled consonant held for 2 counts',
        'A breathing technique',
        'A prayer position'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Shadda (ّ) is a diacritical mark indicating that a consonant is doubled or geminated. The letter is pronounced for 2 counts instead of 1, with emphasis.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_012',
      question: 'How many main types of Madd are there?',
      options: ['3', '4', '5', '6'],
      correctIndex: 3,
      category: 'tajweed',
      explanation: 'There are 6 main types of Madd: (1) Taabi\'i (natural), (2) Muttasil (connected), (3) Munfasil (separated), (4) Lazim (required), (5) Ard for Sukoon, and (6) Ard for Hamzah.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_013',
      question: 'What is the basic Madd duration?',
      options: ['1 count', '2 counts (harakaat)', '3 counts', '4 counts'],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'The basic duration for Madd (vowel elongation) is 2 counts or harakaat (حركات). This refers to the time it takes to pronounce one basic Arabic letter.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_014',
      question: 'What does Ara mean in the context of Quranic letters?',
      options: [
        'Light',
        'Vision',
        'The Raa letter when it has a particular sound quality',
        'A type of prayer'
      ],
      correctIndex: 2,
      category: 'tajweed',
      explanation: 'Ara refers to the specific pronunciation and sound quality of the letter Raa (ر). It can be pronounced with different qualities (emphatic or light) depending on its position and surrounding letters.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_015',
      question: 'What is Tafkheem in Tajweed?',
      options: [
        'Quick pronunciation',
        'Soft pronunciation',
        'Emphatic pronunciation with a thicker sound',
        'Clear pronunciation'
      ],
      correctIndex: 2,
      category: 'tajweed',
      explanation: 'Tafkheem is the emphatic, thick, and grave pronunciation of certain letters (ق، غ، ص، ض، ط، ظ، ذ، د، خ). These are pronounced from the back of the mouth.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_016',
      question: 'What is Tarqeeq in Tajweed?',
      options: [
        'Very fast recitation',
        'Light, thin pronunciation opposite to Tafkheem',
        'A prayer technique',
        'A Quranic story'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Tarqeeq is the light, thin, and soft pronunciation of certain letters, as opposed to Tafkheem (emphatic). Most Arabic letters are pronounced with Tarqeeq by default.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_017',
      question: 'What is Hamza?',
      options: [
        'A prophet',
        'The glottal stop sound (ء)',
        'A prayer time',
        'A Quranic verse'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Hamza (ء) is a glottal stop, the sound of closing the vocal cords momentarily. It\'s considered a full consonant letter in Arabic and must be pronounced clearly.',
      difficulty: 'medium',
    ),
    QuizQuestion(
      id: 'tajweed_018',
      question: 'What is Assimilation in Tajweed?',
      options: [
        'Slowing down',
        'Merging one letter into another (Idgham)',
        'Stopping the recitation',
        'Changing the meaning'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Assimilation in Tajweed refers to Idgham, where one letter merges into the next letter or a similar letter, creating a single pronounced unit.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_019',
      question: 'What are the conditions for correct Idgham?',
      options: [
        'Any two letters can merge',
        'Noon Sakin/Tanween followed by يرلونم',
        'Only vowels can merge',
        'Letters at the end of Surahs only'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Perfect Idgham occurs specifically when Noon Sakin or Tanween is followed by the letters ي (Ya), ر (Ra), ل (Lam), و (Waw), ن (Noon), or م (Meem).',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_020',
      question: 'What is the Lahn al-Jali in Tajweed?',
      options: [
        'Light pronunciation',
        'A grave mistake in Quranic recitation that changes the meaning',
        'A type of prayer technique',
        'Stopping in the middle of words'
      ],
      correctIndex: 1,
      category: 'tajweed',
      explanation: 'Lahn al-Jali (obvious error) is a mistake in Quranic recitation that changes or distorts the meaning of the text due to improper pronunciation or application of Tajweed rules.',
      difficulty: 'hard',
    ),
    QuizQuestion(
      id: 'tajweed_021',
      question: 'How many points of articulation are there for Arabic letters?',
      options: ['12', '14', '16', '18'],
      correctIndex: 2,
      category: 'tajweed',
      explanation: 'There are 16 points of articulation (Makharij) for the 28 Arabic letters. Understanding these points is fundamental to proper Tajweed pronunciation.',
      difficulty: 'hard',
    ),
  ];

  /// Returns exactly 10 random questions: 3 tajweed, 3 islamic, 2 quran, 2 prophets
  static List<QuizQuestion> getRandomQuiz() {
    final random = Random(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    final tajweedQuestions =
        _allQuestions.where((q) => q.category == 'tajweed').toList();
    final islamicQuestions =
        _allQuestions.where((q) => q.category == 'islamic').toList();
    final quranQuestions =
        _allQuestions.where((q) => q.category == 'quran').toList();
    final prophetQuestions =
        _allQuestions.where((q) => q.category == 'prophets').toList();

    tajweedQuestions.shuffle(random);
    islamicQuestions.shuffle(random);
    quranQuestions.shuffle(random);
    prophetQuestions.shuffle(random);

    final quiz = <QuizQuestion>[
      ...tajweedQuestions.take(3),
      ...islamicQuestions.take(3),
      ...quranQuestions.take(2),
      ...prophetQuestions.take(2),
    ];

    quiz.shuffle(random);
    return quiz;
  }

  /// Get all questions of a specific category
  static List<QuizQuestion> getQuestionsByCategory(String category) {
    return _allQuestions.where((q) => q.category == category).toList();
  }

  /// Get all available questions
  static List<QuizQuestion> getAllQuestions() {
    return List.from(_allQuestions);
  }

  /// Get questions by category and limit count
  static List<QuizQuestion> getRandomQuizFiltered(
    String category, {
    int count = 10,
  }) {
    final filtered =
        _allQuestions.where((q) => q.category == category).toList();
    final random = Random(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    filtered.shuffle(random);
    return filtered.take(count).toList();
  }
}


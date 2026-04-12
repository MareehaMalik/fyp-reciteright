import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AyahDisplayScreen.dart';

const Color PRIMARY_COLOR = Color(0xFF1E4976);
const Color BACKGROUND_COLOR = Color(0xFFF5F7FB);
const Color CARD_COLOR = Colors.white;
const Color TEXT_PRIMARY = Color(0xFF1a1a1a);
const Color TEXT_SECONDARY_COLOR = Color(0xFF666666);

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSurahs = [];

  // All 114 Surahs - hardcoded data
  final List<Map<String, dynamic>> allSurahs = [
    {'number': 1, 'english': 'Al-Fatihah', 'arabic': 'الفاتحة', 'meaning': 'The Opening', 'ayahs': 7, 'type': 'Meccan'},
    {'number': 2, 'english': 'Al-Baqarah', 'arabic': 'البقرة', 'meaning': 'The Cow', 'ayahs': 286, 'type': 'Medinan'},
    {'number': 3, 'english': 'Aal-E-Imran', 'arabic': 'آل عمران', 'meaning': 'Family of Imran', 'ayahs': 200, 'type': 'Medinan'},
    {'number': 4, 'english': 'An-Nisa', 'arabic': 'النساء', 'meaning': 'The Women', 'ayahs': 176, 'type': 'Medinan'},
    {'number': 5, 'english': 'Al-Maidah', 'arabic': 'المائدة', 'meaning': 'The Table Spread', 'ayahs': 120, 'type': 'Medinan'},
    {'number': 6, 'english': 'Al-Anam', 'arabic': 'الأنعام', 'meaning': 'The Cattle', 'ayahs': 165, 'type': 'Meccan'},
    {'number': 7, 'english': 'Al-Araf', 'arabic': 'الأعراف', 'meaning': 'The Heights', 'ayahs': 206, 'type': 'Meccan'},
    {'number': 8, 'english': 'Al-Anfal', 'arabic': 'الأنفال', 'meaning': 'The Spoils of War', 'ayahs': 75, 'type': 'Medinan'},
    {'number': 9, 'english': 'At-Tawbah', 'arabic': 'التوبة', 'meaning': 'The Repentance', 'ayahs': 129, 'type': 'Medinan'},
    {'number': 10, 'english': 'Yunus', 'arabic': 'يونس', 'meaning': 'Jonah', 'ayahs': 109, 'type': 'Meccan'},
    {'number': 11, 'english': 'Hud', 'arabic': 'هود', 'meaning': 'Hud', 'ayahs': 123, 'type': 'Meccan'},
    {'number': 12, 'english': 'Yusuf', 'arabic': 'يوسف', 'meaning': 'Joseph', 'ayahs': 111, 'type': 'Meccan'},
    {'number': 13, 'english': 'Ar-Rad', 'arabic': 'الرعد', 'meaning': 'The Thunder', 'ayahs': 43, 'type': 'Medinan'},
    {'number': 14, 'english': 'Ibrahim', 'arabic': 'إبراهيم', 'meaning': 'Abraham', 'ayahs': 52, 'type': 'Meccan'},
    {'number': 15, 'english': 'Al-Hijr', 'arabic': 'الحجر', 'meaning': 'The Rocky Tract', 'ayahs': 99, 'type': 'Meccan'},
    {'number': 16, 'english': 'An-Nahl', 'arabic': 'النحل', 'meaning': 'The Bee', 'ayahs': 128, 'type': 'Meccan'},
    {'number': 17, 'english': 'Al-Isra', 'arabic': 'الإسراء', 'meaning': 'The Night Journey', 'ayahs': 111, 'type': 'Meccan'},
    {'number': 18, 'english': 'Al-Kahf', 'arabic': 'الكهف', 'meaning': 'The Cave', 'ayahs': 110, 'type': 'Meccan'},
    {'number': 19, 'english': 'Maryam', 'arabic': 'مريم', 'meaning': 'Mary', 'ayahs': 98, 'type': 'Meccan'},
    {'number': 20, 'english': 'Ta-Ha', 'arabic': 'طه', 'meaning': 'Ta-Ha', 'ayahs': 135, 'type': 'Meccan'},
    {'number': 21, 'english': 'Al-Anbiya', 'arabic': 'الأنبياء', 'meaning': 'The Prophets', 'ayahs': 112, 'type': 'Meccan'},
    {'number': 22, 'english': 'Al-Hajj', 'arabic': 'الحج', 'meaning': 'The Pilgrimage', 'ayahs': 78, 'type': 'Medinan'},
    {'number': 23, 'english': 'Al-Muminun', 'arabic': 'المؤمنون', 'meaning': 'The Believers', 'ayahs': 118, 'type': 'Meccan'},
    {'number': 24, 'english': 'An-Nur', 'arabic': 'النور', 'meaning': 'The Light', 'ayahs': 64, 'type': 'Medinan'},
    {'number': 25, 'english': 'Al-Furqan', 'arabic': 'الفرقان', 'meaning': 'The Criterion', 'ayahs': 77, 'type': 'Meccan'},
    {'number': 26, 'english': 'Ash-Shuara', 'arabic': 'الشعراء', 'meaning': 'The Poets', 'ayahs': 227, 'type': 'Meccan'},
    {'number': 27, 'english': 'An-Naml', 'arabic': 'النمل', 'meaning': 'The Ant', 'ayahs': 93, 'type': 'Meccan'},
    {'number': 28, 'english': 'Al-Qasas', 'arabic': 'القصص', 'meaning': 'The Stories', 'ayahs': 88, 'type': 'Meccan'},
    {'number': 29, 'english': 'Al-Ankabut', 'arabic': 'العنكبوت', 'meaning': 'The Spider', 'ayahs': 69, 'type': 'Meccan'},
    {'number': 30, 'english': 'Ar-Rum', 'arabic': 'الروم', 'meaning': 'The Romans', 'ayahs': 60, 'type': 'Meccan'},
    {'number': 31, 'english': 'Luqman', 'arabic': 'لقمان', 'meaning': 'Luqman', 'ayahs': 34, 'type': 'Meccan'},
    {'number': 32, 'english': 'As-Sajdah', 'arabic': 'السجدة', 'meaning': 'The Prostration', 'ayahs': 30, 'type': 'Meccan'},
    {'number': 33, 'english': 'Al-Ahzab', 'arabic': 'الأحزاب', 'meaning': 'The Confederates', 'ayahs': 73, 'type': 'Medinan'},
    {'number': 34, 'english': 'Saba', 'arabic': 'سبأ', 'meaning': 'Sheba', 'ayahs': 54, 'type': 'Meccan'},
    {'number': 35, 'english': 'Fatir', 'arabic': 'فاطر', 'meaning': 'Originator', 'ayahs': 45, 'type': 'Meccan'},
    {'number': 36, 'english': 'Ya-Sin', 'arabic': 'يس', 'meaning': 'Ya-Sin', 'ayahs': 83, 'type': 'Meccan'},
    {'number': 37, 'english': 'As-Saffat', 'arabic': 'الصافات', 'meaning': 'Those Ranged in Rows', 'ayahs': 182, 'type': 'Meccan'},
    {'number': 38, 'english': 'Sad', 'arabic': 'ص', 'meaning': 'The Letter Sad', 'ayahs': 88, 'type': 'Meccan'},
    {'number': 39, 'english': 'Az-Zumar', 'arabic': 'الزمر', 'meaning': 'The Groups', 'ayahs': 75, 'type': 'Meccan'},
    {'number': 40, 'english': 'Ghafir', 'arabic': 'غافر', 'meaning': 'The Forgiver', 'ayahs': 85, 'type': 'Meccan'},
    {'number': 41, 'english': 'Fussilat', 'arabic': 'فصلت', 'meaning': 'Explained in Detail', 'ayahs': 54, 'type': 'Meccan'},
    {'number': 42, 'english': 'Ash-Shura', 'arabic': 'الشورى', 'meaning': 'The Consultation', 'ayahs': 53, 'type': 'Meccan'},
    {'number': 43, 'english': 'Az-Zukhruf', 'arabic': 'الزخرف', 'meaning': 'The Gold Adornments', 'ayahs': 89, 'type': 'Meccan'},
    {'number': 44, 'english': 'Ad-Dukhan', 'arabic': 'الدخان', 'meaning': 'The Smoke', 'ayahs': 59, 'type': 'Meccan'},
    {'number': 45, 'english': 'Al-Jathiyah', 'arabic': 'الجاثية', 'meaning': 'The Crouching', 'ayahs': 37, 'type': 'Meccan'},
    {'number': 46, 'english': 'Al-Ahqaf', 'arabic': 'الأحقاف', 'meaning': 'The Wind-Curved Sandhills', 'ayahs': 35, 'type': 'Meccan'},
    {'number': 47, 'english': 'Muhammad', 'arabic': 'محمد', 'meaning': 'Muhammad', 'ayahs': 38, 'type': 'Medinan'},
    {'number': 48, 'english': 'Al-Fath', 'arabic': 'الفتح', 'meaning': 'The Victory', 'ayahs': 29, 'type': 'Medinan'},
    {'number': 49, 'english': 'Al-Hujurat', 'arabic': 'الحجرات', 'meaning': 'The Rooms', 'ayahs': 18, 'type': 'Medinan'},
    {'number': 50, 'english': 'Qaf', 'arabic': 'ق', 'meaning': 'The Letter Qaf', 'ayahs': 45, 'type': 'Meccan'},
    {'number': 51, 'english': 'Adh-Dhariyat', 'arabic': 'الذاريات', 'meaning': 'The Winnowing Winds', 'ayahs': 60, 'type': 'Meccan'},
    {'number': 52, 'english': 'At-Tur', 'arabic': 'الطور', 'meaning': 'The Mount', 'ayahs': 49, 'type': 'Meccan'},
    {'number': 53, 'english': 'An-Najm', 'arabic': 'النجم', 'meaning': 'The Star', 'ayahs': 62, 'type': 'Meccan'},
    {'number': 54, 'english': 'Al-Qamar', 'arabic': 'القمر', 'meaning': 'The Moon', 'ayahs': 55, 'type': 'Meccan'},
    {'number': 55, 'english': 'Ar-Rahman', 'arabic': 'الرحمن', 'meaning': 'The Beneficent', 'ayahs': 78, 'type': 'Medinan'},
    {'number': 56, 'english': 'Al-Waqiah', 'arabic': 'الواقعة', 'meaning': 'The Inevitable', 'ayahs': 96, 'type': 'Meccan'},
    {'number': 57, 'english': 'Al-Hadid', 'arabic': 'الحديد', 'meaning': 'The Iron', 'ayahs': 29, 'type': 'Medinan'},
    {'number': 58, 'english': 'Al-Mujadila', 'arabic': 'المجادلة', 'meaning': 'The Pleading Woman', 'ayahs': 22, 'type': 'Medinan'},
    {'number': 59, 'english': 'Al-Hashr', 'arabic': 'الحشر', 'meaning': 'The Exile', 'ayahs': 24, 'type': 'Medinan'},
    {'number': 60, 'english': 'Al-Mumtahanah', 'arabic': 'الممتحنة', 'meaning': 'She That is to be Examined', 'ayahs': 13, 'type': 'Medinan'},
    {'number': 61, 'english': 'As-Saf', 'arabic': 'الصف', 'meaning': 'The Ranks', 'ayahs': 14, 'type': 'Medinan'},
    {'number': 62, 'english': 'Al-Jumuah', 'arabic': 'الجمعة', 'meaning': 'Friday', 'ayahs': 11, 'type': 'Medinan'},
    {'number': 63, 'english': 'Al-Munafiqun', 'arabic': 'المنافقون', 'meaning': 'The Hypocrites', 'ayahs': 11, 'type': 'Medinan'},
    {'number': 64, 'english': 'At-Taghabun', 'arabic': 'التغابن', 'meaning': 'The Mutual Disillusion', 'ayahs': 18, 'type': 'Medinan'},
    {'number': 65, 'english': 'At-Talaq', 'arabic': 'الطلاق', 'meaning': 'The Divorce', 'ayahs': 12, 'type': 'Medinan'},
    {'number': 66, 'english': 'At-Tahrim', 'arabic': 'التحريم', 'meaning': 'The Prohibition', 'ayahs': 12, 'type': 'Medinan'},
    {'number': 67, 'english': 'Al-Mulk', 'arabic': 'الملك', 'meaning': 'The Sovereignty', 'ayahs': 30, 'type': 'Meccan'},
    {'number': 68, 'english': 'Al-Qalam', 'arabic': 'القلم', 'meaning': 'The Pen', 'ayahs': 52, 'type': 'Meccan'},
    {'number': 69, 'english': 'Al-Haqqah', 'arabic': 'الحاقة', 'meaning': 'The Reality', 'ayahs': 52, 'type': 'Meccan'},
    {'number': 70, 'english': 'Al-Maarij', 'arabic': 'المعارج', 'meaning': 'The Ascending Stairways', 'ayahs': 44, 'type': 'Meccan'},
    {'number': 71, 'english': 'Nuh', 'arabic': 'نوح', 'meaning': 'Noah', 'ayahs': 28, 'type': 'Meccan'},
    {'number': 72, 'english': 'Al-Jinn', 'arabic': 'الجن', 'meaning': 'The Jinn', 'ayahs': 28, 'type': 'Meccan'},
    {'number': 73, 'english': 'Al-Muzzammil', 'arabic': 'المزمل', 'meaning': 'The Enshrouded One', 'ayahs': 20, 'type': 'Meccan'},
    {'number': 74, 'english': 'Al-Muddaththir', 'arabic': 'المدثر', 'meaning': 'The Cloaked One', 'ayahs': 56, 'type': 'Meccan'},
    {'number': 75, 'english': 'Al-Qiyamah', 'arabic': 'القيامة', 'meaning': 'The Resurrection', 'ayahs': 40, 'type': 'Meccan'},
    {'number': 76, 'english': 'Al-Insan', 'arabic': 'الإنسان', 'meaning': 'The Man', 'ayahs': 31, 'type': 'Medinan'},
    {'number': 77, 'english': 'Al-Mursalat', 'arabic': 'المرسلات', 'meaning': 'The Emissaries', 'ayahs': 50, 'type': 'Meccan'},
    {'number': 78, 'english': 'An-Naba', 'arabic': 'النبأ', 'meaning': 'The Tidings', 'ayahs': 40, 'type': 'Meccan'},
    {'number': 79, 'english': 'An-Naziat', 'arabic': 'النازعات', 'meaning': 'Those Who Drag Forth', 'ayahs': 46, 'type': 'Meccan'},
    {'number': 80, 'english': 'Abasa', 'arabic': 'عبس', 'meaning': 'He Frowned', 'ayahs': 42, 'type': 'Meccan'},
    {'number': 81, 'english': 'At-Takwir', 'arabic': 'التكوير', 'meaning': 'The Overthrowing', 'ayahs': 29, 'type': 'Meccan'},
    {'number': 82, 'english': 'Al-Infitar', 'arabic': 'الإنفطار', 'meaning': 'The Cleaving', 'ayahs': 19, 'type': 'Meccan'},
    {'number': 83, 'english': 'Al-Mutaffifin', 'arabic': 'المطففين', 'meaning': 'The Defrauding', 'ayahs': 36, 'type': 'Meccan'},
    {'number': 84, 'english': 'Al-Inshiqaq', 'arabic': 'الإنشقاق', 'meaning': 'The Sundering', 'ayahs': 25, 'type': 'Meccan'},
    {'number': 85, 'english': 'Al-Buruj', 'arabic': 'البروج', 'meaning': 'The Mansions of the Stars', 'ayahs': 22, 'type': 'Meccan'},
    {'number': 86, 'english': 'At-Tariq', 'arabic': 'الطارق', 'meaning': 'The Morning Star', 'ayahs': 17, 'type': 'Meccan'},
    {'number': 87, 'english': 'Al-Ala', 'arabic': 'الأعلى', 'meaning': 'The Most High', 'ayahs': 19, 'type': 'Meccan'},
    {'number': 88, 'english': 'Al-Ghashiyah', 'arabic': 'الغاشية', 'meaning': 'The Overwhelming', 'ayahs': 26, 'type': 'Meccan'},
    {'number': 89, 'english': 'Al-Fajr', 'arabic': 'الفجر', 'meaning': 'The Dawn', 'ayahs': 30, 'type': 'Meccan'},
    {'number': 90, 'english': 'Al-Balad', 'arabic': 'البلد', 'meaning': 'The City', 'ayahs': 20, 'type': 'Meccan'},
    {'number': 91, 'english': 'Ash-Shams', 'arabic': 'الشمس', 'meaning': 'The Sun', 'ayahs': 15, 'type': 'Meccan'},
    {'number': 92, 'english': 'Al-Layl', 'arabic': 'الليل', 'meaning': 'The Night', 'ayahs': 21, 'type': 'Meccan'},
    {'number': 93, 'english': 'Ad-Duha', 'arabic': 'الضحى', 'meaning': 'The Morning Hours', 'ayahs': 11, 'type': 'Meccan'},
    {'number': 94, 'english': 'Ash-Sharh', 'arabic': 'الشرح', 'meaning': 'The Relief', 'ayahs': 8, 'type': 'Meccan'},
    {'number': 95, 'english': 'At-Tin', 'arabic': 'التين', 'meaning': 'The Fig', 'ayahs': 8, 'type': 'Meccan'},
    {'number': 96, 'english': 'Al-Alaq', 'arabic': 'العلق', 'meaning': 'The Clot', 'ayahs': 19, 'type': 'Meccan'},
    {'number': 97, 'english': 'Al-Qadr', 'arabic': 'القدر', 'meaning': 'The Power', 'ayahs': 5, 'type': 'Meccan'},
    {'number': 98, 'english': 'Al-Bayyinah', 'arabic': 'البينة', 'meaning': 'The Clear Proof', 'ayahs': 8, 'type': 'Medinan'},
    {'number': 99, 'english': 'Az-Zalzalah', 'arabic': 'الزلزلة', 'meaning': 'The Earthquake', 'ayahs': 8, 'type': 'Medinan'},
    {'number': 100, 'english': 'Al-Adiyat', 'arabic': 'العاديات', 'meaning': 'The Courser', 'ayahs': 11, 'type': 'Meccan'},
    {'number': 101, 'english': 'Al-Qariah', 'arabic': 'القارعة', 'meaning': 'The Calamity', 'ayahs': 11, 'type': 'Meccan'},
    {'number': 102, 'english': 'At-Takathur', 'arabic': 'التكاثر', 'meaning': 'The Rivalry in World Increase', 'ayahs': 8, 'type': 'Meccan'},
    {'number': 103, 'english': 'Al-Asr', 'arabic': 'العصر', 'meaning': 'The Declining Day', 'ayahs': 3, 'type': 'Meccan'},
    {'number': 104, 'english': 'Al-Humazah', 'arabic': 'الهمزة', 'meaning': 'The Traducer', 'ayahs': 9, 'type': 'Meccan'},
    {'number': 105, 'english': 'Al-Fil', 'arabic': 'الفيل', 'meaning': 'The Elephant', 'ayahs': 5, 'type': 'Meccan'},
    {'number': 106, 'english': 'Quraysh', 'arabic': 'قريش', 'meaning': 'Quraysh', 'ayahs': 4, 'type': 'Meccan'},
    {'number': 107, 'english': 'Al-Maun', 'arabic': 'الماعون', 'meaning': 'The Small Kindnesses', 'ayahs': 7, 'type': 'Meccan'},
    {'number': 108, 'english': 'Al-Kawthar', 'arabic': 'الكوثر', 'meaning': 'The Abundance', 'ayahs': 3, 'type': 'Meccan'},
    {'number': 109, 'english': 'Al-Kafirun', 'arabic': 'الكافرون', 'meaning': 'The Disbelievers', 'ayahs': 6, 'type': 'Meccan'},
    {'number': 110, 'english': 'An-Nasr', 'arabic': 'النصر', 'meaning': 'The Divine Support', 'ayahs': 3, 'type': 'Medinan'},
    {'number': 111, 'english': 'Al-Masad', 'arabic': 'المسد', 'meaning': 'The Palm Fiber', 'ayahs': 5, 'type': 'Meccan'},
    {'number': 112, 'english': 'Al-Ikhlas', 'arabic': 'الإخلاص', 'meaning': 'The Sincerity', 'ayahs': 4, 'type': 'Meccan'},
    {'number': 113, 'english': 'Al-Falaq', 'arabic': 'الفلق', 'meaning': 'The Daybreak', 'ayahs': 5, 'type': 'Meccan'},
    {'number': 114, 'english': 'An-Nas', 'arabic': 'الناس', 'meaning': 'The Mankind', 'ayahs': 6, 'type': 'Meccan'},
  ];

  @override
  void initState() {
    super.initState();
    filteredSurahs = List.from(allSurahs);
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = List.from(allSurahs);
      } else {
        final lowerQuery = query.toLowerCase();
        filteredSurahs = allSurahs.where((surah) {
          return surah['english'].toString().toLowerCase().contains(lowerQuery) ||
              surah['arabic'].toString().contains(query) ||
              surah['number'].toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: const Text(
          'Select Surah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: PRIMARY_COLOR,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
                _filterSurahs(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Surah name or number...',
                prefixIcon: const Icon(Icons.search, color: PRIMARY_COLOR),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterSurahs('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: CARD_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Surahs List
          Expanded(
            child: filteredSurahs.isEmpty
                ? Center(
                    child: Text(
                      'No Surah found',
                      style: TextStyle(color: TEXT_SECONDARY_COLOR, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = filteredSurahs[index];
                      return _buildSurahCard(surah);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AyahDisplayScreen(surah: surah),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CARD_COLOR,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Number Circle
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: PRIMARY_COLOR,
                ),
                child: Center(
                  child: Text(
                    surah['number'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Names and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah['english'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TEXT_PRIMARY,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah['meaning'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: TEXT_SECONDARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              // Arabic and Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah['arabic'] ?? '',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${surah['ayahs']} Verses',
                      style: const TextStyle(
                        fontSize: 11,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


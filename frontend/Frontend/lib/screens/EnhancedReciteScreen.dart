import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:tajweed_corrector/widgets/tajweed_text_widget.dart';
import 'ComparisonResultsScreen.dart';
import 'dart:async';

class EnhancedReciteScreen extends StatefulWidget {
  const EnhancedReciteScreen({super.key});

  @override
  State<EnhancedReciteScreen> createState() => _EnhancedReciteScreenState();
}

class _EnhancedReciteScreenState extends State<EnhancedReciteScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Record _recorder = Record();
  late final Dio _dio;
  final Map<String, Map<String, String>> _ayahCache = {};

  _EnhancedReciteScreenState() {
    // Configure Dio with longer timeouts for slow connections
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 180),
        receiveTimeout: const Duration(seconds: 180),
        sendTimeout: const Duration(seconds: 180),
      ),
    );
    _initializeCache();
  }

  // Initialize cache with pre-loaded common Ayahs to avoid network delays
  void _initializeCache() {
    // Pre-populate cache with Surah 1 (Al-Fatiha) for quick offline access
    _ayahCache['1:1'] = {
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'translation': 'In the name of Allah, the Most Gracious, the Most Merciful'
    };
    _ayahCache['1:2'] = {
      'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'translation': 'All praise is due to Allah, Lord of the worlds'
    };
    _ayahCache['1:3'] = {
      'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
      'translation': 'The Most Gracious, the Most Merciful'
    };
    _ayahCache['1:4'] = {
      'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
      'translation': 'Master of the Day of Judgment'
    };
    _ayahCache['1:5'] = {
      'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'translation': 'You alone we worship, and You alone we ask for help'
    };
    _ayahCache['1:6'] = {
      'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      'translation': 'Guide us to the straight path'
    };
    _ayahCache['1:7'] = {
      'arabic': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
      'translation': 'The path of those upon whom You have bestowed favor, not of those who have earned Your anger, nor of those who go astray'
    };
  }

  // ── Data ──────────────────────────────────────────
  final List<Map<String, dynamic>> surahs = [
    {'number': 1,   'name': 'Al-Fatiha',  'ayahs': 7},
    {'number': 99,  'name': 'Az-Zalzala', 'ayahs': 8},
    {'number': 100, 'name': 'Al-Adiyat',  'ayahs': 11},
    {'number': 101, 'name': 'Al-Qaria',   'ayahs': 11},
    {'number': 103, 'name': 'Al-Asr',     'ayahs': 3},
    {'number': 104, 'name': 'Al-Humaza',  'ayahs': 9},
    {'number': 105, 'name': 'Al-Fil',     'ayahs': 5},
    {'number': 108, 'name': 'Al-Kawthar', 'ayahs': 3},
    {'number': 112, 'name': 'Al-Ikhlas',  'ayahs': 4},
    {'number': 113, 'name': 'Al-Falaq',   'ayahs': 5},
    {'number': 114, 'name': 'An-Nas',     'ayahs': 6},
  ];

  final List<Map<String, String>> qaris = [
    {'id': '7',  'name': 'Mishary Rashid Alafasy'},
    {'id': '1',  'name': 'AbdulBaset AbdulSamad'},
    {'id': '5',  'name': 'Mahmoud Khalil Al-Hussary'},
    {'id': '12', 'name': 'Saad Al-Ghamdi'},
    {'id': '9',  'name': 'Abdul Rahman Al-Sudais'},
  ];

  // Qari folder mapping
  final Map<String, String> qariFolder = {
    '7':  'Alafasy',
    '1':  'AbdulBaset/Mujawwad',
    '5':  'Husary',
    '12': 'Ghamdi',
    '9':  'Sudais',
  };

  // ── State ─────────────────────────────────────────
  int?    selectedSurah;
  int?    selectedAyah;
  String  selectedQariId   = '7';
  String  selectedQariName = 'Mishary Rashid Alafasy';
  bool    isRecording      = false;
  bool    isPlaying        = false;
  bool    isAnalyzing      = false;
  bool    isFetchingAyah   = false;
  String? recordingPath;
  String? status;
  String? ayahArabic;
  String? ayahTranslation;

  // ── Helpers ───────────────────────────────────────
  String _qariAudioUrl(int surah, int ayah, String qariId) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    final folder = qariFolder[qariId] ?? 'Alafasy';
    return 'https://verses.quran.com/$folder/mp3/$s$a.mp3';
  }

  int get ayahCount =>
      surahs.firstWhere((s) => s['number'] == selectedSurah,
          orElse: () => {'ayahs': 1})['ayahs'] as int;

  // ── Fetch Ayah Text ───────────────────────────────
  Future<void> _fetchAyahText(int surah, int ayah) async {
    setState(() {
      isFetchingAyah = true;
      ayahArabic = null;
      ayahTranslation = null;
    });

    final cacheKey = '$surah:$ayah';
    
    // Check cache first
    if (_ayahCache.containsKey(cacheKey)) {
      final cached = _ayahCache[cacheKey]!;
      if (mounted) {
        setState(() {
          ayahArabic = cached['arabic'];
          ayahTranslation = cached['translation'];
          isFetchingAyah = false;
        });
      }
      return;
    }

    int retries = 2;
    while (retries > 0) {
      try {
        // Fetch Arabic text with shorter individual timeout
        final arabicResponse = await _dio.get(
          'https://api.quran.com/api/v4/verses/by_key/$surah:$ayah?fields=text_uthmani',
          options: Options(receiveTimeout: const Duration(seconds: 60)),
        ).timeout(const Duration(seconds: 70), onTimeout: () {
          throw TimeoutException('Arabic text fetch timeout', null);
        });
        
        // Fetch translation with shorter individual timeout
        final translationResponse = await _dio.get(
          'https://api.quran.com/api/v4/verses/by_key/$surah:$ayah?translations=131',
          options: Options(receiveTimeout: const Duration(seconds: 60)),
        ).timeout(const Duration(seconds: 70), onTimeout: () {
          throw TimeoutException('Translation fetch timeout', null);
        });

        final arabic = arabicResponse.data['verse']['text_uthmani'] as String?;
        final translations = translationResponse.data['verse']['translations'] as List?;
        final translation = translations != null && translations.isNotEmpty
            ? translations[0]['text'] as String?
            : null;

        // Cache the result
        if (arabic != null) {
          _ayahCache[cacheKey] = {
            'arabic': arabic,
            'translation': translation ?? '',
          };
        }

        if (mounted) {
          setState(() {
            ayahArabic = arabic;
            ayahTranslation = translation;
            isFetchingAyah = false;
          });
        }
        return; // Success
      } catch (e) {
        retries--;
        print('❌ Error fetching ayah (retries left: $retries): $e');
        
        if (retries == 0) {
          if (mounted) {
            setState(() => isFetchingAyah = false);
            _snack('⚠️ Loading from cache or using default. Check internet.', color: Colors.orange);
            // Use empty defaults if all retries fail
            setState(() {
              ayahArabic = 'Unable to load text';
              ayahTranslation = 'Please check your internet connection';
            });
          }
        } else {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }
  }

  void _snack(String msg, {Color color = const Color(0xFF1E4976)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color,
          duration: const Duration(seconds: 2)),
    );
  }

  // ── Play Qari Audio ───────────────────────────────
  Future<void> _playQari() async {
    if (selectedSurah == null || selectedAyah == null) {
      _snack('Please select Surah and Ayah first', color: Colors.orange);
      return;
    }
    try {
      if (_player.playing) {
        await _player.stop();
        setState(() => isPlaying = false);
        return;
      }
      setState(() => isPlaying = true);
      final url = _qariAudioUrl(selectedSurah!, selectedAyah!, selectedQariId);
      await _player.setUrl(url);
      await _player.play();
      _player.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed) {
          if (mounted) setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      setState(() => isPlaying = false);
      _snack('Could not play audio: $e', color: Colors.red);
    }
  }

  // ── Recording ─────────────────────────────────────
  Future<void> _toggleRecording() async {
    if (selectedSurah == null || selectedAyah == null) {
      _snack('Please select Surah and Ayah first', color: Colors.orange);
      return;
    }
    if (isRecording) {
      final path = await _recorder.stop();
      setState(() {
        isRecording = false;
        recordingPath = path;
        status = '✅ Recording complete — tap Compare!';
      });
    } else {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _snack('Please allow microphone permission', color: Colors.red);
        return;
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/recitation_${DateTime.now().millisecondsSinceEpoch}.wav';
      await _recorder.start(
        path: path,
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        samplingRate: 16000,
      );
      setState(() {
        isRecording = true;
        recordingPath = null;
        status = '🔴 Recording... tap again to stop';
      });
    }
  }

  // ── Compare with Backend ──────────────────────────
  Future<void> _compare() async {
    if (recordingPath == null) {
      _snack('Please record your recitation first', color: Colors.orange);
      return;
    }
    setState(() {
      isAnalyzing = true;
      status      = '🔄 Comparing with Qari...';
    });

    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(recordingPath!, filename: 'recitation.wav'),
        'surah': selectedSurah.toString(),
        'ayah':  selectedAyah.toString(),
        'correct_text': ayahArabic ?? '',  // Add Arabic text
      });

      final response = await _dio.post(
        'http://192.168.100.7:8000/api/compare', // Backend server
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout:    const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data as Map<String, dynamic>;
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComparisonResultsScreen(
                surah:            selectedSurah!,
                verse:            selectedAyah!,
                comparisonResult: result,
                referenceAudioUrl: _qariAudioUrl(selectedSurah!, selectedAyah!, selectedQariId),
                userAudioPath:    recordingPath,
              ),
            ),
          );
        }
      }
    } catch (e) {
      _snack('Error: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => isAnalyzing = false);
    }

  }

  @override
  void dispose() {
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Practice Recitation'),
        backgroundColor: const Color(0xFF1E4976),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Surah Selector ──────────────────────
            _label('1. Select Surah'),
            const SizedBox(height: 8),
             _dropdown<int>(
              value: selectedSurah,
              hint: 'Choose Surah',
              items: surahs.map((s) => DropdownMenuItem<int>(
                value: s['number'] as int,
                child: Text('${s['number']}. ${s['name']}'),
              )).toList(),
              onChanged: (v) => setState(() {
                selectedSurah = v;
                selectedAyah  = null;
              }),
            ),

            const SizedBox(height: 16),

            // ── Ayah Selector ───────────────────────
            _label('2. Select Ayah'),
            const SizedBox(height: 8),
            _dropdown<int>(
              value: selectedAyah,
              hint: 'Choose Ayah',
              items: selectedSurah == null ? [] :
                List.generate(ayahCount, (i) => DropdownMenuItem<int>(
                  value: i + 1,
                  child: Text('Ayah ${i + 1}'),
                )),
              onChanged: (v) {
                setState(() => selectedAyah = v);
                if (v != null && selectedSurah != null) {
                  _fetchAyahText(selectedSurah!, v);
                }
              },
            ),

            const SizedBox(height: 16),

            // ── Ayah Arabic Text and Translation ────
            if (isFetchingAyah)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade400,
                    ),
                  ),
                ),
              ),

            if (!isFetchingAyah && ayahArabic != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E4976), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Arabic text with per-word tajweed highlighting
                    TajweedTextWidget(arabicText: ayahArabic!),
                    const SizedBox(height: 12),
                    // Translation
                    if (ayahTranslation != null)
                      Text(
                        ayahTranslation!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Qari Selector ───────────────────────
            _label('3. Select Qari'),
            const SizedBox(height: 8),
             _dropdown<String>(
              value: selectedQariId,
              hint: 'Choose Qari',
              items: qaris.map((q) => DropdownMenuItem<String>(
                value: q['id'],
                child: Text(q['name']!),
              )).toList(),
              onChanged: (v) => setState(() {
                selectedQariId   = v!;
                selectedQariName = qaris
                    .firstWhere((q) => q['id'] == v)['name']!;
              }),
            ),

            const SizedBox(height: 24),

            // ── Play Qari Button ────────────────────
            _label('4. Listen to Qari'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                 icon: Icon(isPlaying ? Icons.stop : Icons.play_circle),
                 label: Text(isPlaying
                     ? 'Stop'
                     : 'Listen to Qari — $selectedQariName'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E4976),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _playQari,
              ),
            ),

            const SizedBox(height: 24),

            // ── Record Button ───────────────────────
            _label('5. Record Your Recitation'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                 icon: Icon(isRecording ? Icons.stop_circle : Icons.mic),
                 label: Text(isRecording
                     ? '⏹ Stop Recording'
                     : '🎙 Start Recording'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecording ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _toggleRecording,
              ),
            ),

            // ── Status ──────────────────────────────
            if (status != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status!,
                    style: TextStyle(color: Colors.blue.shade700)),
              ),
            ],

            const SizedBox(height: 24),

            // ── Compare Button ──────────────────────
            _label('6. Compare with Qari'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isAnalyzing
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.compare_arrows),
                 label: Text(isAnalyzing
                     ? 'Comparing...'
                     : 'Compare with Qari'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: recordingPath != null
                      ? const Color(0xFF1E4976)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: (recordingPath != null && !isAnalyzing)
                    ? _compare
                    : null,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Reusable Widgets ──────────────────────────────
  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E4976)));

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF1E4976), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          items: items,
          onChanged: onChanged,
        ),
      );
}
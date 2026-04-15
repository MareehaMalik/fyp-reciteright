import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:tajweed_corrector/models/memorization_item.dart';
import 'package:tajweed_corrector/services/backend_config.dart';
import 'package:tajweed_corrector/services/session_service.dart';

import 'ComparisonResultsScreen.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

class AyahDisplayScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  final String recitationMode;
  final int? initialAyahNumber;

  const AyahDisplayScreen({
    super.key,
    required this.surah,
    this.recitationMode = 'practice',
    this.initialAyahNumber,
  });

  @override
  State<AyahDisplayScreen> createState() => _AyahDisplayScreenState();
}

class _AyahDisplayScreenState extends State<AyahDisplayScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Record _recorder = Record();
  final PageController _cardPageController = PageController();
  final SessionService _sessionService = SessionService();

  final List<Map<String, String>> _qaris = const [
    {'id': '7', 'name': 'Mishary Alafasy', 'folder': 'Alafasy'},
    {'id': '1', 'name': 'Abdul Basit', 'folder': 'AbdulBaset/Mujawwad'},
    {'id': '5', 'name': 'Al-Hussary', 'folder': 'Husary'},
    {'id': '12', 'name': 'Saad Al-Ghamdi', 'folder': 'Ghamdi'},
    {'id': '9', 'name': 'Al-Sudais', 'folder': 'Sudais'},
  ];

  List<Map<String, dynamic>> _ayahs = [];
  int? _selectedAyahIndex;

  bool _isLoadingAyahs = true;
  bool _isPracticeCardExpanded = false;
  bool _isAudioLoading = false;
  bool _isPlayingAudio = false;
  bool _isRecording = false;
  bool _isComparing = false;
  bool _isLoadingMemorization = false;

  bool _repeatCurrentAyah = false;
  bool _autoPlayRange = false;
  bool _repeatRange = false;

  int _rangeStartAyah = 1;
  int _rangeEndAyah = 1;

  String _selectedQariId = '7';
  String? _recordingPath;

  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  Duration _recordingDuration = Duration.zero;

  Timer? _recordingTimer;

  Map<String, dynamic>? get _selectedAyah => _selectedAyahIndex == null
      ? null
      : _ayahs[_selectedAyahIndex!.clamp(0, _ayahs.length - 1)];

  String get _selectedQariName {
    return _qaris
            .firstWhere((q) => q['id'] == _selectedQariId)['name'] ??
        'Qari';
  }

  final Map<int, MemorizationItem> _memorizationByAyah = {};

  bool get _isMemorizationMode => widget.recitationMode == 'memorization';

  String _memorizationStatusLabel(String status) {
    switch (status) {
      case 'memorized':
        return 'Memorized';
      case 'learning':
        return 'Learning';
      case 'needs_review':
        return 'Needs review';
      default:
        return 'Not started';
    }
  }

  Color _memorizationStatusColor(String status) {
    switch (status) {
      case 'memorized':
        return const Color(0xFF2E7D32);
      case 'learning':
        return const Color(0xFF1565C0);
      case 'needs_review':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF757575);
    }
  }

  Future<void> _loadMemorizationStatuses() async {
    if (!_isMemorizationMode) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final surahNumber = widget.surah['number'];
    if (surahNumber is! int) return;

    try {
      setState(() => _isLoadingMemorization = true);
      final items = await _sessionService.getMemorizationItems(
        userId: user.uid,
        surahNumber: surahNumber,
      );

      if (!mounted) return;
      setState(() {
        _memorizationByAyah
          ..clear()
          ..addEntries(items.map((item) => MapEntry(item.ayahNumber, item)));
        _isLoadingMemorization = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingMemorization = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
    _fetchAyahs();
    _loadMemorizationStatuses();
  }

  void _setupAudioListeners() {
    _player.durationStream.listen((d) {
      if (!mounted) return;
      setState(() => _audioDuration = d ?? Duration.zero);
    });

    _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _audioPosition = position);
    });

    _player.playerStateStream.listen((state) async {
      if (!mounted) return;
      setState(() {
        _isPlayingAudio = state.playing;
      });
      if (state.processingState == ProcessingState.completed) {
        await _handlePlaybackCompleted();
      }
    });
  }

  Future<void> _fetchAyahs() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://api.quran.com/api/v4/verses/by_chapter/${widget.surah['number']}?language=en&fields=text_uthmani&translations=131&per_page=300',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Status ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final verses = decoded['verses'] as List? ?? [];
      final mapped = List<Map<String, dynamic>>.from(
        verses.map((v) => {
              'number': v['verse_number'] ?? 0,
              'text': v['text_uthmani'] ?? '',
              'translation': v['translations']?[0]?['text'] ?? '',
            }),
      );

      if (!mounted) return;
      setState(() {
        _ayahs = mapped;
        _isLoadingAyahs = false;
        if (_ayahs.isNotEmpty) {
          if (widget.initialAyahNumber != null) {
            final idx = _ayahs.indexWhere((a) => a['number'] == widget.initialAyahNumber);
            _selectedAyahIndex = idx >= 0 ? idx : 0;
          } else {
            _selectedAyahIndex = 0;
          }
          _rangeStartAyah = _ayahs.first['number'] as int;
          _rangeEndAyah = _ayahs.first['number'] as int;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingAyahs = false);
      _showError('Could not load ayahs. Check internet connection.');
    }
  }

  String _audioUrlForAyahNumber(int ayahNumber) {
    final qari = _qaris.firstWhere((q) => q['id'] == _selectedQariId);
    final folder = qari['folder'] ?? 'Alafasy';
    final surahPadded = widget.surah['number'].toString().padLeft(3, '0');
    final ayahPadded = ayahNumber.toString().padLeft(3, '0');
    return 'https://verses.quran.com/$folder/mp3/$surahPadded$ayahPadded.mp3';
  }

  Future<void> _playSelectedAyah() async {
    final ayah = _selectedAyah;
    if (ayah == null) return;

    final ayahNumber = ayah['number'] as int;

    try {
      setState(() => _isAudioLoading = true);
      await _player.setUrl(_audioUrlForAyahNumber(ayahNumber));
      await _player.play();
      if (!mounted) return;
      setState(() => _isAudioLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isAudioLoading = false);
      _showError('Failed to play audio for ayah $ayahNumber.');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_selectedAyah == null) return;
    if (_isPlayingAudio) {
      await _player.pause();
      return;
    }
    if (_audioPosition > Duration.zero && _audioPosition < _audioDuration) {
      await _player.play();
      return;
    }
    await _playSelectedAyah();
  }

  Future<void> _goToAyahIndex(
    int index, {
    bool autoplay = false,
    bool syncPage = true,
  }) async {
    if (_ayahs.isEmpty) return;
    final clampedIndex = index.clamp(0, _ayahs.length - 1);
    if (!mounted) return;
    setState(() {
      _selectedAyahIndex = clampedIndex;
      _isPracticeCardExpanded = true;
      _audioPosition = Duration.zero;
      _audioDuration = Duration.zero;
    });
    if (syncPage && _cardPageController.hasClients) {
      _cardPageController.animateToPage(
        clampedIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
    if (autoplay) {
      await _playSelectedAyah();
    }
  }

  Future<void> _goToNextAyah({bool autoplay = false}) async {
    if (_selectedAyahIndex == null) return;
    await _goToAyahIndex(_selectedAyahIndex! + 1, autoplay: autoplay);
  }

  Future<void> _goToPreviousAyah({bool autoplay = false}) async {
    if (_selectedAyahIndex == null) return;
    await _goToAyahIndex(_selectedAyahIndex! - 1, autoplay: autoplay);
  }

  Future<void> _handlePlaybackCompleted() async {
    final ayah = _selectedAyah;
    if (ayah == null || _selectedAyahIndex == null) return;

    final currentAyahNumber = ayah['number'] as int;

    if (_repeatCurrentAyah) {
      await _playSelectedAyah();
      return;
    }

    if (_autoPlayRange && currentAyahNumber >= _rangeStartAyah) {
      if (currentAyahNumber < _rangeEndAyah) {
        await _goToNextAyah(autoplay: true);
        return;
      }
      if (_repeatRange) {
        final rangeStartIndex =
            _ayahs.indexWhere((a) => a['number'] == _rangeStartAyah);
        if (rangeStartIndex != -1) {
          await _goToAyahIndex(rangeStartIndex, autoplay: true);
          return;
        }
      }
    }

    if (mounted) {
      setState(() => _isPlayingAudio = false);
    }
  }

  Future<void> _startRecording() async {
    if (_selectedAyah == null) return;

    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _showError('Microphone permission denied.');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/recite_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _recorder.start(path: path, encoder: AudioEncoder.wav);

      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _recordingDuration = Duration.zero;
      });

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || !_isRecording) return;
        setState(() {
          _recordingDuration =
              Duration(seconds: _recordingDuration.inSeconds + 1);
        });
      });
    } catch (_) {
      _showError('Failed to start recording.');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _recordingTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        if (path != null) {
          _recordingPath = path;
        }
      });
      _showSnackBar('Recording saved.');
    } catch (_) {
      _showError('Failed to stop recording.');
    }
  }

  Future<void> _compareRecording() async {
    final ayah = _selectedAyah;
    if (ayah == null || _recordingPath == null) return;

    try {
      setState(() => _isComparing = true);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(BackendConfig.compareUrl()),
      );

      request.fields['surah'] = widget.surah['number'].toString();
      request.fields['ayah'] = ayah['number'].toString();
      request.fields['correct_text'] = ayah['text'] as String? ?? '';
      request.fields['qari_id'] = _selectedQariId;
      request.files
          .add(await http.MultipartFile.fromPath('audio', _recordingPath!));

      final response = await request.send().timeout(const Duration(seconds: 60));
      final body = await response.stream.bytesToString();
      final result = body.isNotEmpty ? (jsonDecode(body) as Map<String, dynamic>) : <String, dynamic>{};

      if (response.statusCode == 422) {
        final reason = (result['reason'] ?? '').toString();
        if (reason == 'no_speech_detected') {
          _showError('No recitation detected. Recite clearly and try again.');
        } else if (reason == 'low_transcription_confidence') {
          _showError('Voice was unclear. Please recite louder and closer to microphone.');
        } else {
          _showError((result['error'] ?? 'Comparison rejected. Please try again.').toString());
        }
        return;
      }

      if (response.statusCode != 200 || result['success'] != true) {
        final errorMessage = (result['error'] ?? 'Comparison failed. Please try again.').toString();
        _showError(errorMessage);
        return;
      }

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ComparisonResultsScreen(
            surah: widget.surah['number'] as int,
            verse: ayah['number'] as int,
            comparisonResult: result,
            referenceAudioUrl: _audioUrlForAyahNumber(ayah['number'] as int),
            userAudioPath: _recordingPath,
            recitationMode: widget.recitationMode,
          ),
        ),
      );

      if (_isMemorizationMode && mounted) {
        await _loadMemorizationStatuses();
      }
    } catch (e) {
      _showError('Comparison failed. ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isComparing = false);
      }
    }
  }

  Future<void> _openPracticeMode() async {
    if (_ayahs.isEmpty) return;
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => _PracticeModeScreen(
          ayahs: _ayahs,
          initialIndex: _selectedAyahIndex ?? 0,
          surahNumber: widget.surah['number'] as int,
          surahName: widget.surah['english'] as String? ?? 'Surah',
          arabicSurahName: widget.surah['arabic'] as String? ?? '',
          qaris: _qaris,
          initialQariId: _selectedQariId,
        ),
      ),
    );

    if (selectedIndex != null) {
      await _goToAyahIndex(selectedIndex);
    }
  }

  double _safeSliderMax() {
    final totalMs = _audioDuration.inMilliseconds;
    return totalMs <= 0 ? 1 : totalMs.toDouble();
  }

  double _expandedPracticeCardHeight(BuildContext context) {
    return (MediaQuery.of(context).size.height * 0.66).clamp(320.0, 520.0);
  }

  double _collapsedPracticeCardHeight(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1.0);
    return (124.0 + ((scale - 1.0) * 28.0)).clamp(124.0, 156.0);
  }

  double _stickyCardFootprint(BuildContext context) {
    final media = MediaQuery.of(context);
    final cardHeight = _isPracticeCardExpanded
        ? _expandedPracticeCardHeight(context)
        : _collapsedPracticeCardHeight(context);
    // Card vertical margins (10 + 10) + SafeArea minimum bottom (6) + device bottom inset.
    return cardHeight + 26 + media.padding.bottom;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _cardPageController.dispose();
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          widget.surah['english'] as String? ?? 'Surah',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Practice Mode',
            onPressed: _openPracticeMode,
            icon: Icon(
              Icons.menu_book_rounded,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
      body: _isLoadingAyahs
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(theme.primaryColor),
              ),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    _buildCompactSurahHeader(context),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          12,
                          12,
                          12,
                          _selectedAyahIndex == null
                              ? 24
                              : (_stickyCardFootprint(context) + 8),
                        ),
                        itemCount: _ayahs.length,
                        itemBuilder: (context, index) {
                          final ayah = _ayahs[index];
                          final isSelected = index == _selectedAyahIndex;
                          return _buildAyahRow(ayah, index, isSelected, context);
                        },
                      ),
                    ),
                  ],
                ),
                if (_selectedAyahIndex != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildStickyPracticeCard(context),
                  ),
              ],
            ),
    );
  }

  Widget _buildCompactSurahHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            widget.surah['arabic'] as String? ?? '',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.scheherazadeNew(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _metaChip('${widget.surah['ayahs']} ayahs', context),
                    _metaChip(widget.surah['type'] as String? ?? 'Meccan', context),
                    if (_isMemorizationMode)
                      _metaChip(
                        _isLoadingMemorization ? 'Loading statuses...' : 'Memorization mode',
                        context,
                      ),
                  ],
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onPressed: _openPracticeMode,
                icon: const Icon(Icons.fullscreen_rounded, size: 16),
                label: const Text('Practice Mode'),
              ),
            ],
          ),
          if (widget.surah['number'] != 1 && widget.surah['number'] != 9)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 20,
                  color: Colors.amber[200],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metaChip(String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAyahRow(Map<String, dynamic> ayah, int index, bool isSelected, BuildContext context) {
    final theme = Theme.of(context);
    final ayahNumber = ayah['number'] as int? ?? 0;
    final status = _memorizationByAyah[ayahNumber]?.status ?? 'not_started';
    final statusColor = _memorizationStatusColor(status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _goToAyahIndex(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.primaryColor),
                    color: theme.cardColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ayah['number'].toString(),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ayah['text'] as String? ?? '',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 25,
                      color: theme.textTheme.bodyLarge?.color,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (_isMemorizationMode)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    _memorizationStatusLabel(status),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
            Text(
              ayah['translation'] as String? ?? '',
              maxLines: isSelected ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyPracticeCard(BuildContext context) {
    final selected = _selectedAyah;
    if (selected == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final expandedHeight = _expandedPracticeCardHeight(context);
    final collapsedHeight = _collapsedPracticeCardHeight(context);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: _isPracticeCardExpanded ? expandedHeight : collapsedHeight,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            onTap: () {
              setState(() => _isPracticeCardExpanded = !_isPracticeCardExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selected['number'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayah ${selected['number']}',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${(_selectedAyahIndex ?? 0) + 1}/${_ayahs.length}',
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isPracticeCardExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (!_isPracticeCardExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selected['text'] as String,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 18,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _togglePlayPause,
                    icon: Icon(_isPlayingAudio ? Icons.pause : Icons.play_arrow),
                    label: const Text('Listen'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
           if (_isPracticeCardExpanded)
             Expanded(
               child: LayoutBuilder(
                 builder: (context, constraints) {
                   return SingleChildScrollView(
                     physics: const BouncingScrollPhysics(),
                     padding: EdgeInsets.fromLTRB(
                       12,
                       0,
                       12,
                       12 + media.padding.bottom,
                     ),
                     child: ConstrainedBox(
                       constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCardAyahNavigator(context),
                            const SizedBox(height: 16),
                            _buildSection('Qari', _buildQariSelector(context), context),
                            const SizedBox(height: 16),
                            _buildListenButton(context),
                            const SizedBox(height: 12),
                            _buildProgressSection(context),
                            const SizedBox(height: 16),
                            _buildSection('Practice', _buildRecordCompareRow(context), context),
                            const SizedBox(height: 16),
                            _buildRepeatAndRangeControls(context),
                          ],
                        ),
                     ),
                   );
                 },
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardAyahNavigator(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) {
          _goToNextAyah();
        } else {
          _goToPreviousAyah();
        }
      },
      child: Row(
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: _selectedAyahIndex == 0 ? null : _goToPreviousAyah,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: SizedBox(
              height: 72,
              child: PageView.builder(
                controller: _cardPageController,
                itemCount: _ayahs.length,
                onPageChanged: (index) {
                  if (index == _selectedAyahIndex) return;
                  _goToAyahIndex(index, syncPage: false);
                },
                itemBuilder: (_, index) {
                  final ayah = _ayahs[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ayah['text'] as String,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 25,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        '${index + 1}/${_ayahs.length}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed:
                _selectedAyahIndex == _ayahs.length - 1 ? null : _goToNextAyah,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
  Widget _buildQariSelector(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _qaris.map((qari) {
          final isSelected = qari['id'] == _selectedQariId;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              selectedColor: theme.primaryColor,
              backgroundColor: theme.brightness == Brightness.dark
                  ? AppThemes.darkSurfaceLow
                  : AppThemes.lightSurfaceLow,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: isSelected
                    ? theme.primaryColor
                    : (theme.brightness == Brightness.dark
                        ? AppThemes.darkBorderSubtle
                        : AppThemes.lightBorderSubtle),
                width: 1.5,
              ),
              selected: isSelected,
              label: Text(qari['name'] ?? ''),
              onSelected: (_) {
                setState(() => _selectedQariId = qari['id']!);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListenButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isAudioLoading ? null : _togglePlayPause,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          disabledBackgroundColor: theme.brightness == Brightness.dark
              ? AppThemes.darkDisabledBackground
              : AppThemes.lightDisabledBackground,
          disabledForegroundColor: theme.brightness == Brightness.dark
              ? AppThemes.darkDisabledText
              : AppThemes.lightDisabledText,
        ),
        icon: _isAudioLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                _isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 22,
              ),
        label: Text(
          _isPlayingAudio ? 'Pause' : 'Listen — $_selectedQariName',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }


  Widget _buildSection(String title, Widget child, BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Slider(
            value: _audioPosition.inMilliseconds.clamp(0, _safeSliderMax().toInt()).toDouble(),
            max: _safeSliderMax(),
            activeColor: theme.primaryColor,
            inactiveColor: theme.brightness == Brightness.dark
                ? AppThemes.darkBorderSubtle
                : AppThemes.lightBorderSubtle,
            onChanged: (value) async {
              await _player.seek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_audioPosition),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Tooltip(
                    message: 'Repeat current ayah',
                    child: IconButton(
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() => _repeatCurrentAyah = !_repeatCurrentAyah);
                      },
                      icon: Icon(
                        Icons.repeat_one_rounded,
                        size: 20,
                        color: _repeatCurrentAyah ? theme.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _formatDuration(_audioDuration),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCompareRow(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(
                color: theme.primaryColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: Icon(
              _isRecording ? Icons.stop_circle_rounded : Icons.mic_rounded,
              color: theme.primaryColor,
            ),
            label: Text(
              _isRecording
                  ? 'Stop — ${_formatDuration(_recordingDuration)}'
                  : 'Start Recording',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _recordingPath == null || _isComparing ? null : _compareRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledBackgroundColor: theme.brightness == Brightness.dark
                  ? AppThemes.darkDisabledBackground
                  : AppThemes.lightDisabledBackground,
            ),
            icon: _isComparing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.compare_arrows_rounded),
            label: Text(
              _isComparing ? 'Comparing...' : 'Compare with Qari',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatAndRangeControls(BuildContext context) {
    final theme = Theme.of(context);
    final ayahNumbers = _ayahs.map((e) => e['number'] as int).toList();
    final borderColor = theme.brightness == Brightness.dark
        ? AppThemes.darkBorderSubtle
        : AppThemes.lightBorderSubtle;
    final bgColor = theme.brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.grey[50];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Playback Settings',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto-play range', style: TextStyle(fontSize: 12)),
          value: _autoPlayRange,
          onChanged: (v) => setState(() => _autoPlayRange = v),
        ),
        SwitchListTile.adaptive(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Repeat range', style: TextStyle(fontSize: 12)),
          value: _repeatRange,
          onChanged: (v) => setState(() => _repeatRange = v),
        ),
        const SizedBox(height: 8),
        Text(
          'Range',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      value: _rangeStartAyah,
                      items: ayahNumbers
                          .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _rangeStartAyah = v;
                          if (_rangeEndAyah < v) _rangeEndAyah = v;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      value: _rangeEndAyah,
                      items: ayahNumbers
                          .where((n) => n >= _rangeStartAyah)
                          .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _rangeEndAyah = v);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

class _PracticeModeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ayahs;
  final int initialIndex;
  final int surahNumber;
  final String surahName;
  final String arabicSurahName;
  final List<Map<String, String>> qaris;
  final String initialQariId;

  const _PracticeModeScreen({
    required this.ayahs,
    required this.initialIndex,
    required this.surahNumber,
    required this.surahName,
    required this.arabicSurahName,
    required this.qaris,
    required this.initialQariId,
  });

  @override
  State<_PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends State<_PracticeModeScreen> {
  late final AudioPlayer _player;
  late final PageController _pageController;

  late int _selectedIndex;
  late int _rangeStart;
  late int _rangeEnd;

  late String _selectedQariId;

  bool _showTranslation = true;
  bool _repeatCurrentAyah = false;
  bool _autoPlayRange = false;
  bool _repeatRange = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _selectedIndex = widget.initialIndex.clamp(0, widget.ayahs.length - 1);
    _selectedQariId = widget.initialQariId;
    _rangeStart = widget.ayahs.first['number'] as int;
    _rangeEnd = widget.ayahs.first['number'] as int;
    _pageController = PageController(initialPage: _selectedIndex);

    _player.playerStateStream.listen((state) async {
      if (!mounted) return;
      setState(() => _isPlaying = state.playing);
      if (state.processingState == ProcessingState.completed) {
        await _handleCompletion();
      }
    });
  }

  String _audioUrlFromIndex() {
    final qari = widget.qaris.firstWhere((q) => q['id'] == _selectedQariId);
    final folder = qari['folder'] ?? 'Alafasy';
    final ayah = widget.ayahs[_selectedIndex];
    final ayahNumber = ayah['number'] as int;
    final surahNum = widget.surahNumber.toString().padLeft(3, '0');
    final ayahPadded = ayahNumber.toString().padLeft(3, '0');
    return 'https://verses.quran.com/$folder/mp3/$surahNum$ayahPadded.mp3';
  }

  Future<void> _playCurrent() async {
    try {
      await _player.setUrl(_audioUrlFromIndex());
      await _player.play();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio failed in Practice Mode.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCompletion() async {
    final currentAyah = widget.ayahs[_selectedIndex]['number'] as int;
    if (_repeatCurrentAyah) {
      await _playCurrent();
      return;
    }
    if (_autoPlayRange && currentAyah < _rangeEnd) {
      _goToIndex(_selectedIndex + 1, autoplay: true);
      return;
    }
    if (_autoPlayRange && _repeatRange && currentAyah == _rangeEnd) {
      final startIndex =
          widget.ayahs.indexWhere((a) => a['number'] == _rangeStart);
      if (startIndex != -1) {
        _goToIndex(startIndex, autoplay: true);
      }
    }
  }

  void _goToIndex(int index, {bool autoplay = false}) {
    final target = index.clamp(0, widget.ayahs.length - 1);
    setState(() => _selectedIndex = target);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
    if (autoplay) {
      _playCurrent();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numbers = widget.ayahs.map((e) => e['number'] as int).toList();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Practice Mode',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showTranslation = !_showTranslation),
            icon: Icon(
              _showTranslation ? Icons.visibility : Icons.visibility_off,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              children: [
                Text(
                  widget.arabicSurahName,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 30,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_selectedIndex + 1}/${widget.ayahs.length}',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _selectedIndex = i),
              itemCount: widget.ayahs.length,
              itemBuilder: (_, index) {
                final ayah = widget.ayahs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ayah['text'] as String,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 40,
                          color: theme.textTheme.bodyLarge?.color,
                          height: 1.9,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_showTranslation)
                        Text(
                          ayah['translation'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
            decoration: BoxDecoration(color: theme.cardColor),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: IconButton.filledTonal(
                        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                        onPressed:
                            _selectedIndex == 0 ? null : () => _goToIndex(_selectedIndex - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Previous ayah',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _playCurrent,
                        icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        label: Text(_isPlaying ? 'Pause' : 'Listen'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 48,
                      child: IconButton.filledTonal(
                        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                        onPressed: _selectedIndex == widget.ayahs.length - 1
                            ? null
                            : () => _goToIndex(_selectedIndex + 1),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        tooltip: 'Next ayah',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.qaris.map((qari) {
                      final selected = _selectedQariId == qari['id'];
                      final borderColor = theme.brightness == Brightness.dark
                          ? AppThemes.darkBorderSubtle
                          : AppThemes.lightBorderSubtle;
                      final bgColor = theme.brightness == Brightness.dark
                          ? AppThemes.darkSurfaceLow
                          : AppThemes.lightSurfaceLow;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          selected: selected,
                          selectedColor: theme.primaryColor,
                          backgroundColor: bgColor,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : theme.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: selected ? theme.primaryColor : borderColor,
                            width: 1.5,
                          ),
                          label: Text(qari['name'] ?? ''),
                          onSelected: (_) => setState(() => _selectedQariId = qari['id']!),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.brightness == Brightness.dark
                          ? AppThemes.darkBorderSubtle
                          : AppThemes.lightBorderSubtle,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Playback Options',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile.adaptive(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Auto-play', style: TextStyle(fontSize: 11)),
                              value: _autoPlayRange,
                              onChanged: (v) => setState(() => _autoPlayRange = v),
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile.adaptive(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Repeat', style: TextStyle(fontSize: 11)),
                              value: _repeatRange,
                              onChanged: (v) => setState(() => _repeatRange = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.brightness == Brightness.dark
                                          ? AppThemes.darkBorderSubtle
                                          : AppThemes.lightBorderSubtle,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: theme.cardColor,
                                  ),
                                  child: DropdownButton<int>(
                                    underline: const SizedBox.shrink(),
                                    isExpanded: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    value: _rangeStart,
                                    items: numbers
                                        .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() {
                                        _rangeStart = v;
                                        if (_rangeEnd < v) _rangeEnd = v;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.brightness == Brightness.dark
                                          ? AppThemes.darkBorderSubtle
                                          : AppThemes.lightBorderSubtle,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: theme.cardColor,
                                  ),
                                  child: DropdownButton<int>(
                                    underline: const SizedBox.shrink(),
                                    isExpanded: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    value: _rangeEnd,
                                    items: numbers
                                        .where((n) => n >= _rangeStart)
                                        .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _rangeEnd = v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Tooltip(
                            message: 'Repeat current ayah',
                            child: IconButton.filledTonal(
                              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                              onPressed: () {
                                setState(() => _repeatCurrentAyah = !_repeatCurrentAyah);
                              },
                              icon: Icon(
                                Icons.repeat_one_rounded,
                                size: 20,
                                color: _repeatCurrentAyah ? theme.primaryColor : Colors.grey,
                              ),
                            ),
                          ),
                          const Spacer(),
                          FilledButton.tonalIcon(
                            onPressed: () => Navigator.pop(context, _selectedIndex),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Back to Surah'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

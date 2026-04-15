import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tajweed_corrector/services/user_service.dart';
import 'package:tajweed_corrector/screens/ProfileScreen.dart';
import 'package:tajweed_corrector/screens/ProgressScreen.dart';
import 'package:tajweed_corrector/screens/EnhancedProgressScreen.dart';
import 'package:tajweed_corrector/screens/TajweedLessonsScreen.dart';
import 'package:tajweed_corrector/screens/AudioLessonsScreen.dart';
import 'package:tajweed_corrector/screens/EnhancedReciteScreen.dart';
import 'package:tajweed_corrector/screens/QariListenScreen.dart';
import 'package:tajweed_corrector/screens/EnhancedStatsScreen.dart';
import 'package:tajweed_corrector/services/sample_data_initializer.dart';
import 'package:tajweed_corrector/widgets/index.dart';
import 'home1.dart';

class ReciteRightScreen extends StatefulWidget {
  const ReciteRightScreen({super.key});

  @override
  State<ReciteRightScreen> createState() => _ReciteRightScreenState();
}

class _ReciteRightScreenState extends State<ReciteRightScreen> {
  int _currentIndex = 0;
  String _userName = 'User';
  String? _userAvatar;
  final UserService _userService = UserService();

  PageRouteBuilder _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initializeLessons();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _userName = 'Guest');
        return;
      }

      final profile = await _userService.getUserProfile();

      String? fullName = profile?['fullName'];

      if (fullName == 'Google User') {
        fullName = user.displayName ?? user.email?.split('@')[0] ?? 'User';

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'fullName': fullName,
          'updatedAt': DateTime.now(),
        });
      }

      if (profile == null || fullName == null) {
        fullName = user.displayName ?? user.email?.split('@')[0] ?? 'User';

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'fullName': fullName,
          'email': user.email,
          'createdAt': DateTime.now(),
          'avatarUrl': null,
        }, SetOptions(merge: true));
      }

      if (mounted) {
        setState(() {
          _userName = fullName ?? 'User';
          _userAvatar = profile?['avatar'];
        });
      }
    } catch (e) {
      setState(() => _userName = 'User');
    }
  }

  Future<void> _initializeLessons() async {
    await SampleDataInitializer.initializeSampleLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
            constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER – matches original design
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "ReciteRight",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E4976),
                            ),
                          ),
                          Icon(
                            Icons.dark_mode,
                            color: Color(0xFF1E4976),
                            size: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SlideInWidget(
                        beginOffset: const Offset(0, 0.3),
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Assalam-o-Alaikum,",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Color(0xFF1E4976),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "😊 Are you ready to recite?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    _createSlideRoute(const ProfileScreen()),
                                  );
                                },
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: ClipOval(
                                    child: _userAvatar != null &&
                                        _userAvatar!.isNotEmpty
                                        ? Image.asset(
                                      _userAvatar!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                          stackTrace) {
                                        return Container(
                                          color:
                                          const Color(0xFF2E5F8F),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        );
                                      },
                                    )
                                        : Container(
                                      color: const Color(0xFF2E5F8F),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Feature cards row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const EnhancedReciteScreen(),
                                ),
                              );
                            },
                            child: _featureCard(
                              icon: Icons.mic_none,
                              title: 'Start Recitation',
                              subtitle: 'Recite',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const TajweedLessonsScreen(),
                                ),
                              );
                            },
                            child: _featureCard(
                              icon: Icons.menu_book_outlined,
                              title: 'Lessons',
                              subtitle: 'Start Daily',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const EnhancedProgressScreen(),
                                ),
                              );
                            },
                            child: _progressCard(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Stats button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createSlideRoute(const EnhancedStatsScreen()),
                          );
                        },
                        child: EnhancedCard(
                          gradientColors: [
                            const Color(0xFF1E4976).withOpacity(0.05),
                            const Color(0xFF2E5F8F).withOpacity(0.05),
                          ],
                          borderRadius: 16,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFF1E4976).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.show_chart,
                                  color: Color(0xFF1E4976),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Your Progress',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E4976),
                                      ),
                                    ),
                                    Text(
                                      'View weekly stats and insights',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Daily lesson card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "📖 Today's Lesson",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1E4976),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Ghunnah",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "A soft, nasal sound that is prolonged for two counts and produced entirely from the nasal cavity.",
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text("Recite"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E4976),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Listen section
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (int i = 0; i < 4; i++)
                                  Positioned(
                                    left: i * 25,
                                    child: CircleAvatar(
                                      radius: 18,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/Reciter.png',
                                          fit: BoxFit.cover,
                                          width: 36,
                                          height: 36,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                                size: 18,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  left: 105,
                                  top: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "+50",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const QariListenScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E4976),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(100, 36),
                            ),
                            child: const Text(
                              "Listen",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() => _currentIndex = 0);
          } else if (index == 1) {
            Navigator.push(
              context,
              _createSlideRoute(const TajweedLessonsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              _createSlideRoute(const AudioLessonsScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              _createSlideRoute(const ProfileScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 12,
        selectedItemColor: const Color(0xFF1E4976),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Tajweed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_outlined),
            label: 'Audio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 95,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: const Color(0xFF1E4976),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Progress",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF1E4976),
                  ),
                ),
              ),
              const Text("75%"),
            ],
          ),
        ],
      ),
    );
  }
}
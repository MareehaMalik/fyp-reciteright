import 'package:flutter/material.dart';

class ReciteRightScreen extends StatelessWidget {
  const ReciteRightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ReciteRight',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Circular Progress and Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Circular progress
                    SizedBox(
                      width: isTablet ? 160 : 120,
                      height: isTablet ? 160 : 120,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 0.84,
                            strokeWidth: 10,
                            color: const Color(0xFFB3882D),
                            backgroundColor: Colors.brown.shade100,
                          ),
                          Center(
                            child: Text(
                              '84%',
                              style: TextStyle(
                                fontSize: isTablet ? 28 : 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFB3882D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _StatItem(
                          icon: Icons.mic_none,
                          label: 'session',
                          value: '12',
                        ),
                        SizedBox(height: 10),
                        _StatItem(
                          icon: Icons.access_time,
                          label: 'minutes',
                          value: '120',
                        ),
                        SizedBox(height: 10),
                        _StatItem(
                          icon: Icons.local_fire_department_outlined,
                          label: 'streak',
                          value: '12-d',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 🔹 Statistics
              Text(
                'Statistics',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  fontSize: isTablet ? 22 : 18,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: const [
                    _ProgressBar(title: 'madd', value: 0.8),
                    _ProgressBar(title: 'ghunnah', value: 0.75),
                    _ProgressBar(title: 'makhrij', value: 0.4),
                    _ProgressBar(title: 'idgham', value: 0.9),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 🔹 Achievements
              Text(
                'Achievements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  fontSize: isTablet ? 22 : 18,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  _AchievementCard(
                    icon: Icons.local_fire_department_outlined,
                    title: 'Perfect Recitation\nstreak: 5 days',
                  ),
                  _AchievementCard(
                    icon: Icons.emoji_events_outlined,
                    title: '100 Ayah\ncompleted',
                  ),
                  _AchievementCard(
                    icon: Icons.check_circle_outline,
                    title: 'First Tajweed\nlesson completed',
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 🔹 Motivation
              Text(
                'Motivation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  fontSize: isTablet ? 22 : 18,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إِنَّ الَّذِينَ يَتْلُونَ كِتَابَ اللَّهِ وَأَقَامُوا الصَّلَاةَ...',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Indeed, those who recite the Book of Allah and establish prayer... hope for a reward that will never perish.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.share, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // 🔹 Bottom Navigation
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.home_outlined, color: Colors.green),
            Icon(Icons.menu_book_outlined, color: Colors.green),
            Icon(Icons.mic, color: Colors.green),
            Icon(Icons.bar_chart_outlined, color: Colors.green),
            Icon(Icons.person_outline, color: Colors.green),
          ],
        ),
      ),
    );
  }
}

// 🔸 Reusable Widgets
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown, size: 18),
          const SizedBox(width: 6),
          Text('$label : $value', style: const TextStyle(color: Colors.brown)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String title;
  final double value;

  const _ProgressBar({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${(value * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          color: const Color(0xFFB3882D),
          backgroundColor: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          minHeight: 6,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _AchievementCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: isTablet ? 180 : 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green.shade700, size: isTablet ? 36 : 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

